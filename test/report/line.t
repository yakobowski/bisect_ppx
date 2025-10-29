Reporter still works even in the presence of line number directives.

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test2)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ cat test.ml - >> test2.ml <<'EOF'
  > 
  > # 1 "other_file.ml"
  > 
  > let h () =
  >   ()
  > 
  > let () =
  >   h ()
  > EOF
  $ cat test2.ml
  let f () =
    ()
  
  let g () =
    ()
  
  let () =
    f ()
  
  (* Reproduces a HTML display bug that existed in development between 2.6.3 and
     2.7.0, starting with 1b8d7ec5985aa12a85e797e3d53fc72713e80c35. *)
  let a () =
    if true then
      true
    else
      false
  
  # 1 "other_file.ml"
  
  let h () =
    ()
  
  let () =
    h ()
  $ dune exec ./test2.exe --instrument-with bisect_ppx
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ bisect-ppx-report html --verbose
  /tmp/dune_cram_a0c671_.cram.sh/main.sh: 1: /tmp/dune_cram_a0c671_.cram.sh/6.sh: bisect-ppx-report: not found
  [127]
  $ cat _coverage/test2.ml.html
  cat: _coverage/test2.ml.html: No such file or directory
  [1]
