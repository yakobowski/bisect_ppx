Summary.

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
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_2248db_.cram.sh/main.sh: 1: /tmp/dune_cram_2248db_.cram.sh/4.sh: bisect-ppx-report: not found
  [127]


Per-file coverage.

  $ rm -rf *.coverage
  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test)
  >  (modules test)
  >  (instrumentation (backend bisect_ppx)))
  > 
  > (executable
  >  (name empty)
  >  (modules empty)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test.exe --instrument-with bisect_ppx
  File "dune", line 4, characters 27-37:
  4 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  File "dune", line 9, characters 27-37:
  9 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ dune exec ./empty.exe --instrument-with bisect_ppx
  File "dune", line 4, characters 27-37:
  4 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  File "dune", line 9, characters 27-37:
  9 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ bisect-ppx-report summary --per-file --verbose
  /tmp/dune_cram_2248db_.cram.sh/main.sh: 1: /tmp/dune_cram_2248db_.cram.sh/10.sh: bisect-ppx-report: not found
  [127]
