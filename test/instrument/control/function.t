Instrumentation of cases.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   function
  >   | 0 -> ()
  >   | _ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Recursive instrumentation of cases.

  $ bash ../test.sh <<'EOF'
  > let _ = function () -> function () -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Instrumentation suppressed "between arguments."

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> function () -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Expressions in cases are in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = function () -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Or-pattern.

  $ bash ../test.sh <<'EOF'
  > let _ = function None | Some _ -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Or-pattern with polymorphic variants.

  $ bash ../test.sh <<'EOF'
  > let _ = function `A | `B -> print_endline "foo"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
