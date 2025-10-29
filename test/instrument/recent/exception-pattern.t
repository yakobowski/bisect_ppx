Exception patterns under or-pattern.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  >   | exception Exit | exception Failure _ -> ()
  > EOF


Exception pattern under type constraint.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  >   | (exception (Exit | Failure _) : unit) -> ()
  > EOF
