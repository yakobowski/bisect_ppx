Exception patterns under or-pattern.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  >   | exception Exit | exception Failure _ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Exception pattern under type constraint.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  >   | (exception (Exit | Failure _) : unit) -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
