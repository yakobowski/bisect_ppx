Instrumentation of partially-applied functions on the left of (@@) is
suppressed.

  $ bash ../test.sh <<'EOF'
  > let _ = ListLabels.iter ~f:ignore @@ []
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Subexpressions instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ = String.concat (String.trim "") @@ []
  > let _ = (fun () -> ()) @@ ()
  > let _ = String.concat "" @@ List.append [] []
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
