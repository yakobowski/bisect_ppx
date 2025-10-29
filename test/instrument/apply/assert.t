Out-edge instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = assert (bool_of_string "true")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Not instrumented for assert false.

  $ bash ../test.sh <<'EOF'
  > let _ = assert false
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
