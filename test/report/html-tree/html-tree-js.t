  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (include_subdirs unqualified)
  > 
  > (executable
  >   (name test_tree)
  >   (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test_tree.exe --instrument-with bisect_ppx
  File "dune", line 5, characters 28-38:
  5 |   (instrumentation (backend bisect_ppx)))
                                  ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ bisect-ppx-report html --verbose
  /tmp/dune_cram_bc6058_.cram.sh/main.sh: 1: /tmp/dune_cram_bc6058_.cram.sh/4.sh: bisect-ppx-report: not found
  [127]
  $ grep handle_settings_clicks _coverage/coverage.js
  grep: _coverage/coverage.js: No such file or directory
  [2]
