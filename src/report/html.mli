(* This file is part of Bisect_ppx, released under the MIT license. See
   LICENSE.md for details, or visit
   https://github.com/aantron/bisect_ppx/blob/master/LICENSE.md. *)



val output :
  to_directory:string ->
  title:string ->
  tab_size:int ->
  theme:[ `Light | `Dark | `Auto ] ->
  coverage_files:string list ->
  coverage_paths:string list ->
  source_paths:string list ->
  ignore_missing_files:bool ->
  expect:string list ->
  do_not_expect:string list ->
  tree:bool ->
  sort_by_stats:bool ->
    unit

val diff_output :
  to_directory:string ->
  title:string ->
  tab_size:int ->
  theme:[ `Auto | `Dark | `Light ] ->
  report1:string ->
  report2:string ->
  source_paths:string list ->
  ignore_missing_files:bool ->
  expect:string list ->
  do_not_expect:string list ->
  tree:bool ->
  sort_by_stats:bool ->
  unit
