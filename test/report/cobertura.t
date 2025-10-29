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
  $ bisect-ppx-report cobertura coverage.xml --verbose
  /tmp/dune_cram_d4383b_.cram.sh/main.sh: 1: /tmp/dune_cram_d4383b_.cram.sh/4.sh: bisect-ppx-report: not found
  [127]
  $ cat coverage.xml
  cat: coverage.xml: No such file or directory
  [1]
