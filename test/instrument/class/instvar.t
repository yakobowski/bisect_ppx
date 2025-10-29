Pexp_setinstvar traversed.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     val mutable x = ()
  >     method foo = x <- (print_endline "foo")
  >   end
  > EOF


Pexp_override traversed.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     val x = ()
  >     method foo = {< x = print_endline "foo" >}
  >   end
