Missing files trigger a neat error.

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test.exe --instrument-with bisect_ppx
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ rm -rf _build
  $ mv test.ml test2.ml
  $ bisect-ppx-report html
  /tmp/dune_cram_e019b5_.cram.sh/main.sh: 1: /tmp/dune_cram_e019b5_.cram.sh/6.sh: bisect-ppx-report: not found
  [127]


--ignore-missing-files turns this error into a warning.

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ mv test2.ml test.ml
  $ dune exec ./test.exe --instrument-with bisect_ppx
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ rm -rf _build
  $ mv test.ml test2.ml
  $ bisect-ppx-report html --ignore-missing-files --verbose
  /tmp/dune_cram_e019b5_.cram.sh/main.sh: 1: /tmp/dune_cram_e019b5_.cram.sh/13.sh: bisect-ppx-report: not found
  [127]


The warning is visible only when --verbose is provided.

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ mv test2.ml test.ml
  $ dune exec ./test.exe --instrument-with bisect_ppx
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ rm -rf _build
  $ mv test.ml test2.ml
  $ bisect-ppx-report html --ignore-missing-files
  /tmp/dune_cram_e019b5_.cram.sh/main.sh: 1: /tmp/dune_cram_e019b5_.cram.sh/20.sh: bisect-ppx-report: not found
  [127]
