In logical AND, control might not reach the second argument, so it is
instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = true && false
  > let _ = (true & false) [@ocaml.warning "-3"]
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Recursive instrumentation of subexpressions.

  $ bash ../test.sh <<'EOF'
  > let _ = (bool_of_string "true") && (bool_of_string "false")
  > let _ =
  >   ((bool_of_string "true") & (bool_of_string "false")) [@ocaml.warning "-3"]
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Partial application. See https://github.com/aantron/bisect_ppx/issues/333.

  $ bash ../test.sh <<'EOF'
  > [@@@ocaml.warning "-5"]
  > let _ = (&&) (List.mem 0 [])
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


The second subexpression is not post-instrumented if it is in tail position.

  $ bash ../test.sh <<'EOF'
  > let f _ = (bool_of_string "true") && (bool_of_string "false")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
