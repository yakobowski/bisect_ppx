Instrumentation of cases.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   function
  >   | 0 -> ()
  >   | _ -> ()
  > EOF


Recursive instrumentation of cases.

  $ bash ../test.sh <<'EOF'
  > let _ = function () -> function () -> ()
  > EOF


Instrumentation suppressed "between arguments."

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> function () -> ()
  > EOF


Expressions in cases are in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = function () -> print_endline "foo"
  > EOF


Or-pattern.

  $ bash ../test.sh <<'EOF'
  > let _ = function None | Some _ -> print_endline "foo"
  > EOF


Or-pattern with polymorphic variants.

  $ bash ../test.sh <<'EOF'
  > let _ = function `A | `B -> print_endline "foo"
  > EOF
