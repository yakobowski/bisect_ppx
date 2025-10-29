Out-edge instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = assert (bool_of_string "true")
  > EOF


Not instrumented for assert false.

  $ bash ../test.sh <<'EOF'
  > let _ = assert false
  > EOF
