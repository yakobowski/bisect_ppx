Sys.opaque_identity instrumentation is suppressed.

  $ bash ../test.sh <<'EOF'
  > let _ = Sys.opaque_identity (print_endline "foo")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
