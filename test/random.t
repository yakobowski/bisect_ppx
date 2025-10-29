Bisect's runtime does not clobber the global random number generator state.

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name random_test)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ cat > random_test.ml <<'EOF'
  > let () =
  >   Random.int 1000 |> string_of_int |> print_endline
  > EOF
  $ dune exec ./random_test.exe > pristine
  $ dune exec ./random_test.exe --instrument-with bisect_ppx > 1
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ dune exec ./random_test.exe --instrument-with bisect_ppx > 2
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ diff pristine 1
  1d0
  < 344
  [1]
  $ diff pristine 2
  1d0
  < 344
  [1]
