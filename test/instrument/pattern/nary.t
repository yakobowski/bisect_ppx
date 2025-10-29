Tuple.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match (`A, `C) with
  >   | ((`A | `B), (`C | `D)) -> print_endline "foo"
  > EOF


Record.

  $ bash ../test.sh <<'EOF'
  > type t = {a : bool; b : bool}
  > let _ =
  >   match {a = true; b = false} with
  >   | {a = true | false; b = true | false} -> print_endline "foo"
  > EOF


Array.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match [|`A; `C|] with
  >   | [|`A | `B; `C | `D|] -> print_endline "foo"
  >   | _ -> ()
  > EOF
