  $ echo > .ocamlformat
  $ echo "(lang dune 2.9)" > dune-project
  $ cat > dune <<'EOF'
  > (executables
  >  (names not_excluded excluded_1)
  >  (modes byte)
  >  (ocamlc_flags -dsource)
  >  (instrumentation
  >   (backend bisect_ppx --exclusions bisect.exclude) (deps bisect.exclude)))
  > EOF
  $ cat > bisect.exclude <<'EOF'
  > file "excluded_1.ml"
  > EOF
  $ cat > not_excluded.ml <<'EOF'
  > let _f () = ()
  > EOF
  $ cat > excluded_1.ml <<'EOF'
  > let _f () = ()
  > EOF
  $ dune build ./not_excluded.bc --instrument-with bisect_ppx 2>&1
  File "dune", line 6, characters 11-21:
  6 |   (backend bisect_ppx --exclusions bisect.exclude) (deps bisect.exclude)))
                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]

  $ dune build ./excluded_1.bc --instrument-with bisect_ppx 2>&1
  File "dune", line 6, characters 11-21:
  6 |   (backend bisect_ppx --exclusions bisect.exclude) (deps bisect.exclude)))
                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]

