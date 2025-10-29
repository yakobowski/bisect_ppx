Trivial.

  $ bash ../test.sh <<'EOF'
  > class foo =
  > object
  > end
  > EOF


Parameters are preserved.

  $ bash ../test.sh <<'EOF'
  > class foo_1 () =
  > object
  > end
  > class foo_2 ~l:_ =
  > object
  > end
  > class foo_3 ?l:_ () =
  > object
  > end
  > EOF


Default values are instrumented, and instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > [@@@ocaml.warning "-27"]
  > class foo ?(l = fun () -> ()) () =
  > object
  > end
  > EOF


Nested expressions and initializers instrumented.

  $ bash ../test.sh <<'EOF'
  > class foo =
  >   let () = print_endline "bar" in
  >   object
  >     initializer print_endline "baz"
  >   end
  > EOF
