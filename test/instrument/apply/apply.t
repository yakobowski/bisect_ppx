Post-instrumented when they are not in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = print_endline "foo"
  > EOF


Not instrumented when in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> print_endline "foo"
  > EOF


Arguments instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ = String.trim (String.trim "foo")
  > EOF


Function position instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ = (List.map ignore) []
  > EOF


Multiple arguments don't produce nested instrumentation.

  $ bash ../test.sh <<'EOF'
  > let _ = List.map ignore []
  > EOF


Labels preserved.

  $ bash ../test.sh <<'EOF'
  > let _ = ListLabels.iter ~f:ignore []
  > EOF


Instrumentation suppressed if all arguments labeled.

  $ bash ../test.sh <<'EOF'
  > [@@@ocaml.warning "-5"]
  > let _ = ListLabels.iter ~f:ignore
  > EOF
