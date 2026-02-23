(* This file is part of Bisect_ppx, released under the MIT license. See
   LICENSE.md for details, or visit
   https://github.com/aantron/bisect_ppx/blob/master/LICENSE.md. *)



let theme_class = function
  | `Light -> {| class="light"|}
  | `Dark -> {| class="dark"|}
  | `Auto -> ""

let split_filename name =
  let dirname =
    match Filename.dirname name with
    | "" -> ""
    | dir when dir = Filename.current_dir_name -> ""
    | dir -> dir ^ Filename.dir_sep
  in
  let basename = Filename.basename name in
  dirname, basename

let percentage (visited, total) =
  if total = 0 then
    100.
  else
    100. *. (float_of_int visited) /. (float_of_int total)

type index_file = (string * string * (int * int))

(** Coverage statistics comparison between two reports. *)
type diff_stats = {
  both : int; (** Number of points covered in both reports. *)
  only1 : int; (** Number of points covered only in the first report. *)
  only2 : int; (** Number of points covered only in the second report. *)
  neither : int; (** Number of points covered in neither report. *)
}

type index_element =
  | File of index_file
  | Directory of (string * index_element list * (int * int))

(** Data for a single file in the diff index. *)
type diff_index_file = (string * string * diff_stats)

(** Elements in the diff index tree. *)
type diff_index_element =
  | Diff_File of diff_index_file
  | Diff_Directory of (string * diff_index_element list * diff_stats)

module Index_element :
sig
  val sort_by_stats : index_element list -> index_element list
  val flatten : index_element list -> index_element list
end =
struct
  let percentage = function
    | File (_, _, stat) -> percentage stat
    | Directory (_, _, stat) -> percentage stat

  let compare_by_stat e1 e2 =
    compare (percentage e1, e1) (percentage e2, e2)

  let rec sort_by_stats files =
    files
    |> List.map (function
      | (File _) as f -> f
      | Directory (name, files, stats) ->
        Directory (name, sort_by_stats files, stats))
    |> List.sort compare_by_stat

  let rec flatten files =
    files
    |> List.map (function
      | (File _) as f -> [f]
      | Directory (_, files, _) -> flatten files)
    |> List.concat
end

(** Total number of instrumentation points in the diff stats. *)
let diff_total s = s.both + s.only1 + s.only2 + s.neither

(** Percentage of points covered in the second report. *)
let diff_percentage s =
  let total = diff_total s in
  if total = 0 then 100.
  else 100. *. (float_of_int (s.both + s.only2)) /. (float_of_int total)

module Diff_index_element :
sig
  val sort_by_stats : diff_index_element list -> diff_index_element list
  val flatten : diff_index_element list -> diff_index_element list
end =
struct
  let percentage = function
    | Diff_File (_, _, stat) -> diff_percentage stat
    | Diff_Directory (_, _, stat) -> diff_percentage stat

  let compare_by_stat e1 e2 =
    compare (percentage e1, e1) (percentage e2, e2)

  let rec sort_by_stats files =
    files
    |> List.map (function
      | (Diff_File _) as f -> f
      | Diff_Directory (name, files, stats) ->
        Diff_Directory (name, sort_by_stats files, stats))
    |> List.sort compare_by_stat

  let rec flatten files =
    files
    |> List.map (function
      | (Diff_File _) as f -> [f]
      | Diff_Directory (_, files, _) -> flatten files)
    |> List.concat
end

(*
  [subdirectory_of dir ~directory file] returns [Some subdirectory] if file is
  a contained in the subdirectory [subdirectory] of [directory].

  If [file] is not contained in [directory] or if [file] is
  contained directly in [directory] then [None] is returned.
 *)
let subdirectory_of ~directory file =
  let len_file = String.length file in
  let len_directory = String.length directory in
  if len_file < len_directory then None
  else if (String.sub file 0 len_directory <> directory) then None
  else
    let lfind_string_opt ~needle haystack =
      let rec aux i =
        if String.(length haystack - i < length needle) then None
        else if String.(sub haystack i (length needle)) = needle then Some i
        else aux (i+1)
      in aux 0
    in
    let file_rel = String.sub file len_directory (len_file - len_directory) in
    match lfind_string_opt ~needle:Filename.dir_sep file_rel with
    | Some i -> Some (String.sub file_rel 0 i)
    | None -> None

(* [partition_files ~directory files] returns two lists:

     - the first is a list of pairs [(sub_directory, sub_files)],
       each corresponding to a [sub_directory] of [~directory] and the [sub_files]
       contained (recursively) therein
     - the second is a list of files, corresponding to the set of immediate sub-files of
       [~directory]

   This function assumes that [files] are sorted lexicographically.
 *)
let partition_files ~directory files =
  let immediate_child_of ~directory name =
    let directory', _ = split_filename name in
    directory' = directory
  in
  let rec aux sub_dirs sub_files =
    function
      [] -> (List.rev sub_dirs, List.concat (List.rev sub_files))
    | (name, _, _) as file :: files ->
       match subdirectory_of ~directory name with
       | None ->
          let (sub_files_here, files') =
            Util.split
              (fun (name, _, _) -> immediate_child_of ~directory name)
              (file :: files)
          in
          aux sub_dirs (sub_files_here :: sub_files) files'
       | Some root ->
          let sub_dir, files' =
            Util.split
              (fun (name, _, _) -> subdirectory_of ~directory name = Some root)
              (file :: files) in
          aux ((root, sub_dir) :: sub_dirs) sub_files files'
  in aux [] [] files

let output_html_index ~tree ~sort_by_stats title theme filename files =
  Util.info "Writing index file...";

  let add_stats (visited, total) (visited', total') =
    (visited + visited', total + total') in

  let sum_stats files =
    List.fold_left
      (fun stats (_, _, stats') -> add_stats stats stats')
      (0, 0)
      files
  in

  let collate : index_file list -> index_element list * (int * int) =
    fun files ->
    let rec collate_aux :
              string -> index_file list ->
              (index_element list * (int * int)) =
      fun directory files ->
      let (sub_dirs, sub_files) = partition_files ~directory files in
      let (dir_elements, dir_stats) =
        List.fold_left
          (fun (lines, stats) (sub_dir, files)  ->
            let directory = directory ^ sub_dir ^ "/" in
            let (sub_dir_elements, sub_dir_stats) = collate_aux directory files in
            let sub_dir_element = Directory (directory, sub_dir_elements, sub_dir_stats) in
            (sub_dir_element :: lines, add_stats stats sub_dir_stats))
          ([], (0, 0)) sub_dirs in
      let sub_files_element = List.map (fun file -> File file) sub_files in
      let dir_stats = add_stats dir_stats (sum_stats sub_files) in
      ((List.rev dir_elements) @ sub_files_element, dir_stats)
    in
    collate_aux "" files
  in

  let channel =
    try open_out filename
    with Sys_error message ->
      Util.fatal "cannot open output file '%s': %s" filename message
  in
  try
    let write format = Printf.fprintf channel format in

    let (files, stats) = collate files in

    let files =
      match sort_by_stats, tree with
      | false, _ -> files
      | true, false ->
        files |> Index_element.flatten |> Index_element.sort_by_stats
      | true, true -> files |> Index_element.sort_by_stats
    in

    let overall_coverage =
      Printf.sprintf "%.02f%%" (floor ((percentage stats) *. 100.) /. 100.) in
    write {|<!DOCTYPE html>
<html lang="en"%s>
  <head>
    <meta charset="utf-8"/>
    <title>%s</title>
    <meta name="description" content="%s coverage overall"/>
    <link rel="stylesheet" type="text/css" href="coverage.css"/>
  </head>
  <body data-tree-view="%b">
    <div id="header">
      <h1>%s</h1>
      <h2>%s</h2>
    </div>
    <div id="settings">
      <div>
        <input type="checkbox" id="show-empty-files-input" />
        <label for="show-empty-files-input">show empty files</label>
      </div>
      <div>
        <input type="checkbox" id="tree-view-input" />
        <label for="tree-view-input">tree view</label>
      </div>
      <div style="margin-left: 20px">
        <input type="checkbox" id="group-files-input" />
        <label for="group-files-input">group files</label>
      </div>
      <div id="sorting-options">
        <span>sort by:</span>
        <div>
          <input type="radio" id="filename-sort" name="sort" value="filename" checked />
          <label for="filename-sort">filename</label>
        </div>
        <div>
          <input type="radio" id="coverage-sort" name="sort" value="coverage" />
          <label for="coverage-sort">coverage</label>
        </div>
        <div>
          <input type="radio" id="lost-sort" name="sort" value="lost" />
          <label for="lost-sort">no longer covered</label>
        </div>
        <div>
          <input type="radio" id="new-sort" name="sort" value="new" />
          <label for="new-sort">newly covered</label>
        </div>
        <div>
          <input type="radio" id="nb-statements-sort" name="sort" value="nb-statements" />
          <label for="nb-statements-sort">nb statements</label>
        </div>
      </div>
    </div>
    <div id="files">
|}
      (theme_class theme)
      title
      overall_coverage
      tree
      title
      overall_coverage;

    let print_line =
      let write_meter ((visited, total) as stats) =
        let percentage = Printf.sprintf "%.00f" (floor (percentage stats)) in
        write {|        <span class="meter">
          <span class="covered" style="width: %s%%"></span>
        </span>
        <span class="percentage">%s%% <span class="stats">(%d / %d)</span></span>
|}
          percentage
          percentage
          visited total;
      in
      function
      | File (name, html_file, ((_, total) as stats)) ->
         let p = percentage stats in
         write {|      <div data-total="%d" data-statements="%d" data-coverage="%.2f">
|}
           total total p;
         write_meter stats ;
         let dirname, basename = split_filename name in
         let relative_html_file =
           if Filename.is_relative html_file then
             html_file
           else
             let prefix_length = String.length Filename.dir_sep in
             String.sub
               html_file prefix_length (String.length html_file - prefix_length)
         in
         write {|        <a href="%s">
          <span class="dirname">%s</span>%s
        </a>
      </div>
|}
           relative_html_file
           dirname basename;
      | Directory (_, _, _) ->
         ()
    in

    files |> Index_element.flatten |> List.iter print_line;

    write {|    </div>
    <script src="coverage.js"></script>
  </body>
</html>
|};

    close_out channel

  with
  | Sys_error message ->
    Util.fatal "cannot write output file '%s': %s" filename message
  | exn ->
    close_out_noerr channel;
    raise exn



(** Generates the index page for a diff report. *)
let output_html_diff_index ~tree ~sort_by_stats title theme filename files =
  Util.info "Writing index file...";

  let add_diff_stats s1 s2 = {
    both = s1.both + s2.both;
    only1 = s1.only1 + s2.only1;
    only2 = s1.only2 + s2.only2;
    neither = s1.neither + s2.neither;
  } in

  let sum_diff_stats files =
    List.fold_left
      (fun stats (_, _, stats') -> add_diff_stats stats stats')
      { both = 0; only1 = 0; only2 = 0; neither = 0 }
      files
  in

  let collate : diff_index_file list -> diff_index_element list * diff_stats =
    fun files ->
    let rec collate_aux :
              string -> diff_index_file list ->
              (diff_index_element list * diff_stats) =
      fun directory files ->
      let (sub_dirs, sub_files) = partition_files ~directory files in
      let (dir_elements, dir_stats) =
        List.fold_left
          (fun (lines, stats) (sub_dir, files)  ->
            let directory = directory ^ sub_dir ^ "/" in
            let (sub_dir_elements, sub_dir_stats) = collate_aux directory files in
            let sub_dir_element = Diff_Directory (directory, sub_dir_elements, sub_dir_stats) in
            (sub_dir_element :: lines, add_diff_stats stats sub_dir_stats))
          ([], { both = 0; only1 = 0; only2 = 0; neither = 0 }) sub_dirs in
      let sub_files_element = List.map (fun file -> Diff_File file) sub_files in
      let dir_stats = add_diff_stats dir_stats (sum_diff_stats sub_files) in
      ((List.rev dir_elements) @ sub_files_element, dir_stats)
    in
    collate_aux "" files
  in

  let channel =
    try open_out filename
    with Sys_error message ->
      Util.fatal "cannot open output file '%s': %s" filename message
  in
  try
    let write format = Printf.fprintf channel format in

    let (files, stats) = collate files in

    let files =
      match sort_by_stats, tree with
      | false, _ -> files
      | true, false ->
        files |> Diff_index_element.flatten |> Diff_index_element.sort_by_stats
      | true, true -> files |> Diff_index_element.sort_by_stats
    in

    let overall_coverage =
      Printf.sprintf "%.02f%%" (floor ((diff_percentage stats) *. 100.) /. 100.) in
    write {|<!DOCTYPE html>
<html lang="en"%s>
  <head>
    <meta charset="utf-8"/>
    <title>%s</title>
    <meta name="description" content="%s coverage overall"/>
    <link rel="stylesheet" type="text/css" href="coverage.css"/>
  </head>
  <body data-tree-view="%b" data-diff-view="true">
    <div id="header">
      <h1>%s</h1>
      <h2>%s</h2>
    </div>
    <div id="settings">
      <div>
        <input type="checkbox" id="show-empty-files-input" />
        <label for="show-empty-files-input">show empty files</label>
      </div>
      <div>
        <input type="checkbox" id="tree-view-input" />
        <label for="tree-view-input">tree view</label>
      </div>
      <div style="margin-left: 20px">
        <input type="checkbox" id="group-files-input" />
        <label for="group-files-input">group files</label>
      </div>
      <div id="sorting-options">
        <span>sort by:</span>
        <div>
          <input type="radio" id="filename-sort" name="sort" value="filename" checked />
          <label for="filename-sort">filename</label>
        </div>
        <div>
          <input type="radio" id="coverage-sort" name="sort" value="coverage" />
          <label for="coverage-sort">coverage</label>
        </div>
        <div>
          <input type="radio" id="lost-sort" name="sort" value="lost" />
          <label for="lost-sort">no longer covered</label>
        </div>
        <div>
          <input type="radio" id="new-sort" name="sort" value="new" />
          <label for="new-sort">newly covered</label>
        </div>
        <div>
          <input type="radio" id="nb-statements-sort" name="sort" value="nb-statements" />
          <label for="nb-statements-sort">nb statements</label>
        </div>
      </div>
    </div>
    <div id="files">
|}
      (theme_class theme)
      title
      overall_coverage
      tree
      title
      overall_coverage;

    let print_line =
      let write_meter s =
        let total = diff_total s in
        let p_both = if total = 0 then 0. else 100. *. (float_of_int s.both) /. (float_of_int total) in
        let p_only2 = if total = 0 then 0. else 100. *. (float_of_int s.only2) /. (float_of_int total) in
        let p_only1 = if total = 0 then 0. else 100. *. (float_of_int s.only1) /. (float_of_int total) in
        let percentage = Printf.sprintf "%.00f" (floor (diff_percentage s)) in
        write {|        <span class="meter">
          <span class="both" style="width: %.00f%%"></span>
          <span class="new" style="width: %.00f%%"></span>
          <span class="lost" style="width: %.00f%%"></span>
        </span>
        <span class="percentage">%s%% <span class="stats">(%d, +%d, -%d, %d)</span></span>
|}
          p_both
          p_only2
          p_only1
          percentage
          s.both s.only2 s.only1 s.neither;
      in
      function
      | Diff_File (name, html_file, s) ->
         let p = diff_percentage s in
         let total = diff_total s in
         write {|      <div data-both="%d" data-only1="%d" data-only2="%d" data-neither="%d" data-total="%d" data-statements="%d" data-coverage="%.2f">
|}
           s.both s.only1 s.only2 s.neither total total p;
         write_meter s ;
         let dirname, basename = split_filename name in
         let relative_html_file =
           if Filename.is_relative html_file then
             html_file
           else
             let prefix_length = String.length Filename.dir_sep in
             String.sub
               html_file prefix_length (String.length html_file - prefix_length)
         in
         write {|        <a href="%s">
          <span class="dirname">%s</span>%s
        </a>
      </div>
|}
           relative_html_file
           dirname basename;
      | Diff_Directory (_, _, _) ->
         ()
    in

    files |> Diff_index_element.flatten |> List.iter print_line;

    write {|    </div>
    <script src="coverage.js"></script>
  </body>
</html>
|};

    close_out channel

  with
  | Sys_error message ->
    Util.fatal "cannot write output file '%s': %s" filename message
  | exn ->
    close_out_noerr channel;
    raise exn



let escape_line tab_size line offset points =
  let buff = Buffer.create (String.length line) in
  let ofs = ref offset in
  let pts = ref points in

  let marker_if_any content =
    match !pts with
    | (o, n)::tl when o = !ofs ->
      Printf.bprintf buff {|<span data-count="%i">%s</span>|} n content;
      pts := tl
    | _ ->
      Buffer.add_string buff content
  in
  line
  |> String.iter
    begin fun ch ->
      let s =
        match ch with
        | '<' -> "&lt;"
        | '>' -> "&gt;"
        | '&' -> "&amp;"
        | '\t' -> String.make tab_size ' '
        | c -> Printf.sprintf "%c" c
      in
      marker_if_any s;
      incr ofs
    end;
  Buffer.contents buff



(* Individual HTML files corresponding to each source file. *)

let output_for_source_file
    tab_size title theme source_file_on_disk html_file_on_disk
    {Bisect_common.filename; points; counts} =

  let len = Array.length counts in
  let stats = ref (0, 0) in
  let points =
    points
    |> Array.to_list
    |> List.mapi (fun index offset -> (offset, index))
    |> List.sort compare
  in
  let pts =
    ref (points |> List.map (fun (offset, index) ->
      let nb =
        if index < len then
          counts.(index)
        else
          0
      in
      let visited, total = !stats in
      let visited =
        if nb > 0 then
          visited + 1
        else
          visited
      in
      stats := (visited, total + 1);
      (offset, nb)))
  in
  let dirname, basename = split_filename filename in
  Util.mkdirs (Filename.dirname html_file_on_disk);
  let in_channel =
    try open_in source_file_on_disk
    with Sys_error message ->
      Util.fatal "cannot open source file '%s': %s" source_file_on_disk message
  in
  let out_channel =
    try open_out html_file_on_disk
    with Sys_error message ->
      Util.fatal "cannot open output file '%s': %s" html_file_on_disk message
  in
  let rec make_path_to_report_root acc in_file_path_remaining =
    if in_file_path_remaining = "" ||
        in_file_path_remaining = Filename.current_dir_name ||
        in_file_path_remaining = Filename.dir_sep then
      acc
    else
      let path_component = Filename.basename in_file_path_remaining in
      let parent = Filename.dirname in_file_path_remaining in
      if path_component = Filename.current_dir_name then
        make_path_to_report_root acc parent
      else
        make_path_to_report_root
          (Filename.concat acc Filename.parent_dir_name)
          parent
  in
  let path_to_report_root =
    make_path_to_report_root "" (Filename.dirname filename) in
  let style_css = Filename.concat path_to_report_root "coverage.css" in
  let coverage_js = Filename.concat path_to_report_root "coverage.js" in
  let highlight_js =
    Filename.concat path_to_report_root "highlight.pack.js" in
  let index_html = Filename.concat path_to_report_root "index.html" in
  (try
    let lines, line_count =
      let rec read number acc =
        let start_ofs = pos_in in_channel in
        match input_line in_channel with
        | exception End_of_file -> List.rev acc, number - 1
        | line ->
          let end_ofs = pos_in in_channel in
          let before, after = Util.split (fun (o, _) -> o < end_ofs) !pts in
          pts := after;
          let line' = escape_line tab_size line start_ofs before in
          let visited, unvisited =
            List.fold_left
              (fun (v, u) (_, nb) ->
                ((v || (nb > 0)), (u || (nb = 0))))
              (false, false)
              before
          in
          read (number + 1) ((number, line', visited, unvisited)::acc)
      in
      read 1 []
    in

    let class_of_visited = function
      | true, false -> {|class="visited"|}
      | false, true -> {|class="unvisited"|}
      | true, true -> {|class="some-visited"|}
      | false, false -> ""
    in

    let write format = Printf.fprintf out_channel format in

    (* Head and header. *)
    let file_coverage = Printf.sprintf "%.02f%%" (percentage !stats) in
    write {|<!DOCTYPE html>
<html lang="en"%s>
  <head>
    <meta charset="utf-8"/>
    <title>%s &mdash; %s</title>
    <meta name="description" content="%s coverage in %s">
    <link rel="stylesheet" href="%s"/>
    <script src="%s"></script>
    <script>hljs.initHighlightingOnLoad();</script>
  </head>
  <body>
    <div id="header">
      <h1>
        <a href="%s">
          <span class="dirname">%s</span>%s
        </a>
      </h1>
      <h2>%s</h2>
    </div>
    <div id="navbar">
|}
      (theme_class theme)
      basename
      title
      file_coverage
      filename
      style_css
      highlight_js
      index_html
      dirname basename
      file_coverage;

    (* Navigation bar items. *)
    lines |> List.iter begin fun (number, _, visited, unvisited) ->
      if unvisited then begin
        let offset =
          (float_of_int number) /. (float_of_int line_count) *. 100. in
        let origin, offset =
          if offset <= 50. then
            "top", offset
          else
            "bottom", (100. -. offset)
        in
        write "      <span %s style=\"%s:%.02f%%\"></span>\n"
          (class_of_visited (visited, unvisited)) origin offset;
      end
    end;

    write {|    </div>
    <div id="report">
      <div id="lines-layer">
        <pre>
|};

    (* Line highlights. *)
    lines |> List.iter (fun (number, _, visited, unvisited) ->
      write "<a id=\"L%i\"></a><span %s> </span>\n"
        number
        (class_of_visited (visited, unvisited)));

    write {|</pre>
      </div>
      <div id="text-layer">
        <pre id="line-numbers">
|};

    let width = string_of_int line_count |> String.length in

    (* Line numbers. *)
    lines |> List.iter (fun (number, _, _, _) ->
      let formatted = string_of_int number in
      let padded =
        (String.make (width - String.length formatted) ' ') ^ formatted in
      write "<a href=\"#L%s\">%s</a>\n" formatted padded);

    let syntax =
      if Filename.check_suffix basename ".re" then
        "reasonml"
      else
        "ocaml"
    in

    write "</pre>\n";
    write "<pre><code class=\"%s\">" syntax;

    (* Code lines. *)
    lines |> List.iter (fun (_, markup, _, _) -> write "%s\n" markup);

    write {|</code></pre>
      </div>
    </div>
    <script src="%s"></script>
  </body>
</html>
|}
      coverage_js

  with e ->
    close_in_noerr in_channel;
    close_out_noerr out_channel;
    raise e);

  close_in_noerr in_channel;
  close_out_noerr out_channel;
  !stats



(** Coverage state of a single source line in a diff report. *)
type diff_line_state =
  | Diff_both (** All points on the line are covered in both reports. *)
  | Diff_only1 (** All points on the line are covered only in the first report. *)
  | Diff_only2 (** All points on the line are covered only in the second report. *)
  | Diff_neither (** No points on the line are covered in either report. *)
  | Diff_mixed of string (** Line contains points with different coverage states. *)
  | Diff_none (** Line contains no instrumentation points. *)

(** Escapes a line of source code for HTML and wraps points in markers. *)
let escape_diff_line tab_size line offset points =
  let buff = Buffer.create (String.length line) in
  let ofs = ref offset in
  let pts = ref points in

  let marker_if_any content =
    match !pts with
    | (o, n1, n2)::tl when o = !ofs ->
      let cls =
        if n1 > 0 && n2 > 0 then "both"
        else if n1 > 0 then "lost"
        else if n2 > 0 then "new"
        else "neither"
      in
      let count_text =
        if n1 = n2 then Printf.sprintf "%d" n1
        else Printf.sprintf "%d -> %d" n1 n2
      in
      Printf.bprintf buff {|<span class="%s" data-count="%s">%s</span>|} cls count_text content;
      pts := tl
    | _ ->
      Buffer.add_string buff content
  in
  line
  |> String.iter
    begin fun ch ->
      let s =
        match ch with
        | '<' -> "&lt;"
        | '>' -> "&gt;"
        | '&' -> "&amp;"
        | '\t' -> String.make tab_size ' '
        | c -> Printf.sprintf "%c" c
      in
      marker_if_any s;
      incr ofs
    end;
  Buffer.contents buff

(** Generates an HTML page for a single source file in a diff report. *)
let output_for_diff_source_file
    tab_size title theme source_file_on_disk html_file_on_disk
    {Bisect_common.filename; points; counts = counts1}
    {Bisect_common.counts = counts2; _} =

  let len1 = Array.length counts1 in
  let len2 = Array.length counts2 in
  let stats = ref { both = 0; only1 = 0; only2 = 0; neither = 0 } in

  (* Combine instrumentation points from both reports and calculate stats. *)
  let points =
    points
    |> Array.to_list
    |> List.mapi (fun index offset -> (offset, index))
    |> List.sort compare
  in
  let pts =
    ref (points |> List.map (fun (offset, index) ->
      let n1 = if index < len1 then counts1.(index) else 0 in
      let n2 = if index < len2 then counts2.(index) else 0 in
      let s = !stats in
      (* Update aggregate stats for the file based on this point's state. *)
      let s =
        if n1 > 0 && n2 > 0 then { s with both = s.both + 1 }
        else if n1 > 0 then { s with only1 = s.only1 + 1 }
        else if n2 > 0 then { s with only2 = s.only2 + 1 }
        else { s with neither = s.neither + 1 }
      in
      stats := s;
      (offset, n1, n2)))
  in
  let dirname, basename = split_filename filename in
  Util.mkdirs (Filename.dirname html_file_on_disk);
  let in_channel =
    try open_in source_file_on_disk
    with Sys_error message ->
      Util.fatal "cannot open source file '%s': %s" source_file_on_disk message
  in
  let out_channel =
    try open_out html_file_on_disk
    with Sys_error message ->
      Util.fatal "cannot open output file '%s': %s" html_file_on_disk message
  in
  let rec make_path_to_report_root acc in_file_path_remaining =
    if in_file_path_remaining = "" ||
        in_file_path_remaining = Filename.current_dir_name ||
        in_file_path_remaining = Filename.dir_sep then
      acc
    else
      let path_component = Filename.basename in_file_path_remaining in
      let parent = Filename.dirname in_file_path_remaining in
      if path_component = Filename.current_dir_name then
        make_path_to_report_root acc parent
      else
        make_path_to_report_root
          (Filename.concat acc Filename.parent_dir_name)
          parent
  in
  let path_to_report_root =
    make_path_to_report_root "" (Filename.dirname filename) in
  let style_css = Filename.concat path_to_report_root "coverage.css" in
  let highlight_js =
    Filename.concat path_to_report_root "highlight.pack.js" in
  let coverage_js =
    Filename.concat path_to_report_root "coverage.js" in
  let index_html = Filename.concat path_to_report_root "index.html" in

  (* Processes one line of source code and returns its representation.
     [number] is the line number, [line] is the raw text, [start_ofs] is the
     byte offset of the line start, and [before] are points on this line. *)
  let handle_line number line start_ofs before =
    (* Escape the line content and wrap points in markers. *)
    let line' = escape_diff_line tab_size line start_ofs before in

    (* Determine the overall coverage state of the line. *)
    let state =
      match before with
      | [] -> Diff_none
      | (_, n1, n2)::tl ->
        (* Helper to determine the diff state of a single point. *)
        let get_state n1 n2 =
          if n1 > 0 && n2 > 0 then Diff_both
          else if n1 > 0 then Diff_only1
          else if n2 > 0 then Diff_only2
          else Diff_neither
        in
        let first_state = get_state n1 n2 in
        (* Check if all points on this line have the same state. *)
        let is_mixed =
          List.exists (fun (_, n1, n2) -> get_state n1 n2 <> first_state) tl
        in
        if is_mixed then
          (* If states are mixed, calculate the breakdown for the tooltip. *)
          let b, o1, o2, n =
            List.fold_left (fun (b, o1, o2, n) (_, n1, n2) ->
              match get_state n1 n2 with
              | Diff_both -> (b + 1, o1, o2, n)
              | Diff_only1 -> (b, o1 + 1, o2, n)
              | Diff_only2 -> (b, o1, o2 + 1, n)
              | Diff_neither -> (b, o1, o2, n + 1)
              | Diff_none | Diff_mixed _ -> assert false
            )
            (* Start with the state of the first point. *)
            (match first_state with
             | Diff_both -> (1, 0, 0, 0)
             | Diff_only1 -> (0, 1, 0, 0)
             | Diff_only2 -> (0, 0, 1, 0)
             | Diff_neither -> (0, 0, 0, 1)
             | Diff_mixed _ | Diff_none -> assert false)
            tl
          in
          Diff_mixed (Printf.sprintf "Mixed coverage: %d both, %d only 1st, %d only 2nd, %d neither" b o1 o2 n)
        else
          first_state
    in
    (number, line', state)
  in

  (try
    (* Read source file lines and process them. *)
    let lines, line_count =
      let rec read number acc =
        let start_ofs = pos_in in_channel in
        match input_line in_channel with
        | exception End_of_file -> List.rev acc, number - 1
        | line ->
          let end_ofs = pos_in in_channel in
          let before, after = Util.split (fun (o, _, _) -> o < end_ofs) !pts in
          pts := after;
          let line_representation = handle_line number line start_ofs before in
          read (number + 1) (line_representation::acc)
      in
      read 1 []
    in

    let class_of_state = function
      | Diff_both -> {|class="both"|}
      | Diff_only1 -> {|class="lost"|}
      | Diff_only2 -> {|class="new"|}
      | Diff_neither -> {|class="neither"|}
      | Diff_mixed _ -> {|class="mixed"|}
      | Diff_none -> ""
    in

    let tooltip_of_state = function
      | Diff_mixed m -> Printf.sprintf {|data-tooltip="%s"|} m
      | _ -> ""
    in

    let write format = Printf.fprintf out_channel format in

    (* HTML Head and header. *)
    let file_coverage = Printf.sprintf "%.02f%%" (diff_percentage !stats) in
    write {|<!DOCTYPE html>
<html lang="en"%s>
  <head>
    <meta charset="utf-8"/>
    <title>%s &mdash; %s</title>
    <meta name="description" content="%s coverage in %s">
    <link rel="stylesheet" href="%s"/>
    <script src="%s"></script>
    <script>hljs.initHighlightingOnLoad();</script>
  </head>
  <body>
    <div id="header">
      <h1>
        <a href="%s">
          <span class="dirname">%s</span>%s
        </a>
      </h1>
      <h2>%s</h2>
    </div>
    <div id="navbar">
|}
      (theme_class theme)
      basename
      title
      file_coverage
      filename
      style_css
      highlight_js
      index_html
      dirname basename
      file_coverage;

    (* Navigation bar items. *)
    lines |> List.iter begin fun (number, _, state) ->
      match state with
      | Diff_none | Diff_both -> ()
      | _ ->
        let offset =
          (float_of_int number) /. (float_of_int line_count) *. 100. in
        let origin, offset =
          if offset <= 50. then
            "top", offset
          else
            "bottom", (100. -. offset)
        in
        write "      <span %s style=\"%s:%.02f%%\"></span>\n"
          (class_of_state state) origin offset;
    end;

    write {|    </div>
    <div id="report">
      <div id="lines-layer">
        <pre>
|};

    (* Line highlights. *)
    lines |> List.iter (fun (number, _, state) ->
      write "<a id=\"L%i\"></a><span %s %s> </span>\n"
        number
        (class_of_state state)
        (tooltip_of_state state));

    write {|</pre>
      </div>
      <div id="text-layer">
        <pre id="line-numbers">
|};

    let width = string_of_int line_count |> String.length in

    (* Line numbers. *)
    lines |> List.iter (fun (number, _, state) ->
      let formatted = string_of_int number in
      let padded =
        (String.make (width - String.length formatted) ' ') ^ formatted in
      let tooltip = tooltip_of_state state in
      write "<a href=\"#L%s\" %s>%s</a>\n" formatted tooltip padded);

    let syntax =
      if Filename.check_suffix basename ".re" then
        "reasonml"
      else
        "ocaml"
    in

    write "</pre>\n";
    write "<pre><code class=\"%s\">" syntax;

    (* Code lines. *)
    lines |> List.iter (fun (_, markup, _) -> write "%s\n" markup);

    write {|</code></pre>
      </div>
    </div>
    <script src="%s"></script>
  </body>
</html>
|}
      coverage_js

  with e ->
    close_in_noerr in_channel;
    close_out_noerr out_channel;
    raise e);

  close_in_noerr in_channel;
  close_out_noerr out_channel;
  !stats



(* Assets, such as CSS and JavaScript files. *)

let output_string_to_separate_file content filename =
  let channel =
    try open_out filename
    with Sys_error message ->
      Util.fatal "cannot open output file '%s': %s" filename message
  in
  try
    Printf.fprintf channel "%s" content;
    close_out channel
  with
  | Sys_error message ->
    Util.fatal "cannot write output file '%s': %s" filename message
  | exn ->
    close_out_noerr channel;
    raise exn



(* HTML generator entry point. *)

let output
    ~to_directory ~title ~tab_size ~theme ~coverage_files ~coverage_paths
    ~source_paths ~ignore_missing_files ~expect ~do_not_expect ~tree
    ~sort_by_stats =

  (* Read all the [.coverage] files and get per-source file visit counts. *)
  let coverage =
    Input.load_coverage
      ~coverage_files ~coverage_paths ~expect ~do_not_expect in

  (* Write each of the HTML files corresponding to each source file. *)
  Util.mkdirs to_directory;
  let files =
    Hashtbl.fold begin fun _ file acc ->
      let filename = Bisect_common.(file.filename) in
      let source_file_on_disk =
        Util.find_source_file
          ~source_roots:source_paths ~ignore_missing_files ~filename in
      match source_file_on_disk with
      | None ->
        acc
      | Some source_file_on_disk ->
        let html_file_on_disk =
          (Filename.concat to_directory filename) ^ ".html" in
        let html_file_relative = filename ^ ".html" in
        let stats =
          output_for_source_file
            tab_size title theme source_file_on_disk html_file_on_disk file in
        (filename, html_file_relative, stats)::acc
    end
    coverage
    []
  in

  (* Write the coverage report landing page. *)
  output_html_index
    ~tree
    ~sort_by_stats
    title
    theme
    (Filename.concat to_directory "index.html")
    (List.sort compare files);

  (* Write the asset files. *)
  output_string_to_separate_file
    Assets.js
    (Filename.concat to_directory "coverage.js");
  output_string_to_separate_file
    Assets.highlight_js
    (Filename.concat to_directory "highlight.pack.js");
  output_string_to_separate_file
    Assets.css
    (Filename.concat to_directory "coverage.css")



(** Entry point for generating a diff coverage report. *)
let diff_output
    ~to_directory ~title ~tab_size ~theme ~report1 ~report2
    ~source_paths ~ignore_missing_files ~expect ~do_not_expect ~tree
    ~sort_by_stats =

  let coverage1 =
    Input.load_coverage
      ~coverage_files:[report1] ~coverage_paths:[] ~expect ~do_not_expect in
  let coverage2 =
    Input.load_coverage
      ~coverage_files:[report2] ~coverage_paths:[] ~expect ~do_not_expect in

  let all_filenames = Hashtbl.create 17 in
  Hashtbl.iter (fun name _ -> Hashtbl.replace all_filenames name ()) coverage1;
  Hashtbl.iter (fun name _ -> Hashtbl.replace all_filenames name ()) coverage2;

  Util.mkdirs to_directory;
  let files =
    Hashtbl.fold begin fun filename () acc ->
      let file1_opt = Hashtbl.find_opt coverage1 filename in
      let file2_opt = Hashtbl.find_opt coverage2 filename in
      let filename, file1, file2 =
        match file1_opt, file2_opt with
        | Some f1, Some f2 -> filename, f1, f2
        | Some f1, None ->
          filename, f1, {f1 with counts = Array.make (Array.length f1.counts) 0}
        | None, Some f2 ->
          filename, {f2 with counts = Array.make (Array.length f2.counts) 0}, f2
        | None, None -> assert false
      in
      let source_file_on_disk =
        Util.find_source_file
          ~source_roots:source_paths ~ignore_missing_files ~filename in
      match source_file_on_disk with
      | None ->
        acc
      | Some source_file_on_disk ->
        let html_file_on_disk =
          (Filename.concat to_directory filename) ^ ".html" in
        let html_file_relative = filename ^ ".html" in
        let stats =
          output_for_diff_source_file
            tab_size title theme source_file_on_disk html_file_on_disk
            file1 file2 in
        (filename, html_file_relative, stats)::acc
    end
    all_filenames
    []
  in

  output_html_diff_index
    ~tree
    ~sort_by_stats
    title
    theme
    (Filename.concat to_directory "index.html")
    (List.sort compare files);

  output_string_to_separate_file
    Assets.js
    (Filename.concat to_directory "coverage.js");
  output_string_to_separate_file
    Assets.highlight_js
    (Filename.concat to_directory "highlight.pack.js");
  output_string_to_separate_file
    Assets.css
    (Filename.concat to_directory "coverage.css")
