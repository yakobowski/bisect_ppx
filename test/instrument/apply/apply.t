Post-instrumented when they are not in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Not instrumented when in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Arguments instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ = String.trim (String.trim "foo")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Function position instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ = (List.map ignore) []
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Multiple arguments don't produce nested instrumentation.

  $ bash ../test.sh <<'EOF'
  > let _ = List.map ignore []
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Labels preserved.

  $ bash ../test.sh <<'EOF'
  > let _ = ListLabels.iter ~f:ignore []
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Instrumentation suppressed if all arguments labeled.

  $ bash ../test.sh <<'EOF'
  > [@@@ocaml.warning "-5"]
  > let _ = ListLabels.iter ~f:ignore
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
