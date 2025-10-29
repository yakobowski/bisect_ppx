Alias.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | `A | `B as _x -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Constructor.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match Some `A with
  >   | Some (`A | `B) -> print_endline "foo"
  >   | None -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Polymorphic variant constructor.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A `B with
  >   | `A (`B | `C) -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Type constraint.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | (`A | `B : _) -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Lazy.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match lazy `A with
  >   | lazy (`A | `B) -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
