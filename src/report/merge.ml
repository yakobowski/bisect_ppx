(* This file is part of Bisect_ppx, released under the MIT license. See
   LICENSE.md for details, or visit
   https://github.com/aantron/bisect_ppx/blob/master/LICENSE.md. *)

let read_lines file =
  let ic = open_in file in
  let rec read acc =
    try
      let line = input_line ic in
      read (line::acc)
    with End_of_file ->
      close_in_noerr ic;
      List.rev acc
  in
  read []

let partition n l =
  let rec part acc i l =
    if i = 0 then (List.rev acc)::(if l = [] then [] else part [] (n-1) l)
    else
      match l with
      | [] -> [List.rev acc]
      | h::t -> part (h::acc) (i-1) t
  in
  if n <= 0 || l = [] then []
  else
    let chunk_size = max 1 (List.length l / n) in
    part [] chunk_size l

let output ~to_file ~coverage_files ~coverage_paths ~j ~response_file =
  let all_coverage_files =
    match response_file with
    | Some f -> read_lines f
    | None ->
        Input.search_for_coverage_files ~coverage_files ~coverage_paths
  in
  let parent pid =
    let _, status = Unix.waitpid [] pid in
    match status with
    | WEXITED 0 -> ()
    | _ -> exit 1
  in
  let coverage =
    if j > 1 then (
      let partitions = partition j all_coverage_files in
      let temp_files = List.map (fun _ -> Filename.temp_file "bisect" ".coverage") partitions in
      let children =
        List.map2 (fun partition temp_file ->
          let files = Array.of_list (Sys.executable_name :: "merge" :: "-o" :: temp_file :: partition) in
          Unix.create_process Sys.executable_name files Unix.stdin Unix.stdout Unix.stderr
        ) partitions temp_files
      in
      List.iter parent children;
      let coverage = Input.load_coverage ~coverage_files:temp_files ~coverage_paths:[] ~expect:[] ~do_not_expect:[] in
      List.iter Sys.remove temp_files;
      coverage)
    else
      Input.load_coverage
        ~coverage_files:all_coverage_files ~coverage_paths:[] ~expect:[] ~do_not_expect:[]
  in
  let coverage_string = Bisect_common.write_coverage coverage in
  let () = Util.mkdirs (Filename.dirname to_file) in
  let oc = open_out to_file in
  try
    output_string oc coverage_string;
    close_out oc
  with exn ->
    close_out_noerr oc;
    raise exn
