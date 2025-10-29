Subexpressions instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let (let*) x f = f x
  > let (and*) x y = (x, y)
  > let return x = x
  > let _ =
  >   let* () = print_endline "foo"
  >   and* () = print_endline "bar" in
  >   let* () = print_endline "baz" in
  >   return ()
  > EOF
