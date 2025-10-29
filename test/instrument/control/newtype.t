Pseudo-entry point of newtype is not instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = fun (type _t) -> ()
  > EOF


Recursive instrumentation of subexpression.

  $ bash ../test.sh <<'EOF'
  > let _ = fun (type _t) -> fun x -> x
  > EOF


Subexpression in tail position iff whole expression is in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   fun (type _t) -> print_endline "foo"
  > let _ = fun () ->
  >   fun (type _t) -> print_endline "foo"
  > EOF
