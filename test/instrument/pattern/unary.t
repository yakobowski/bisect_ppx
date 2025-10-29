Alias.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | `A | `B as _x -> print_endline "foo"
  > EOF


Constructor.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match Some `A with
  >   | Some (`A | `B) -> print_endline "foo"
  >   | None -> ()
  > EOF


Polymorphic variant constructor.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A `B with
  >   | `A (`B | `C) -> print_endline "foo"
  > EOF


Type constraint.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | (`A | `B : _) -> print_endline "foo"
  > EOF


Lazy.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match lazy `A with
  >   | lazy (`A | `B) -> print_endline "foo"
  > EOF
