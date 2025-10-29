  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (include_subdirs unqualified)
  > 
  > (executable
  >   (name test_tree)
  >   (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test_tree.exe --instrument-with bisect_ppx
  $ bisect-ppx-report html --verbose
  Info: found *.coverage files in './'
  Info: Writing index file...
  $ grep handle_settings_clicks _coverage/coverage.js
  [1]
