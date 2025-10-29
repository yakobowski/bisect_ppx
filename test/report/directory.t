Reporter fails to create the output directory.

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
  $ touch foo
  $ bisect-ppx-report html -o foo/bar/
  /tmp/dune_cram_ca634f_.cram.sh/main.sh: 1: /tmp/dune_cram_ca634f_.cram.sh/5.sh: bisect-ppx-report: not found
  [127]


Reporter fails to create intermediate directory.

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
  $ touch foo
  $ bisect-ppx-report html -o foo/bar/baz/
  /tmp/dune_cram_ca634f_.cram.sh/main.sh: 1: /tmp/dune_cram_ca634f_.cram.sh/10.sh: bisect-ppx-report: not found
  [127]
