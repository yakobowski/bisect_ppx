Pexp_setinstvar traversed.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     val mutable x = ()
  >     method foo = x <- (print_endline "foo")
  >   end
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Pexp_override traversed.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     val x = ()
  >     method foo = {< x = print_endline "foo" >}
  >   end
  ../test.sh: line 48: ocamlformat: command not found
  [127]
