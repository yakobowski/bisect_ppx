Bindings made under or-patterns remain consistent after instrumentation.

  $ (bash ../test.sh | tail -n +4) <<'EOF'
  > let _ =
  >   match `A with
  >   | (`A as x) | (`B as x) -> print_endline "foo"; x
  > EOF

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A () with
  >   | `A x | `B x -> print_endline "foo"; x
  > EOF
