Method "entry point" instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     method foo = ()
  >   end
  > EOF


Instrumentation is inserted into nested abstractions.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     method foo () () = ()
  >     method bar = function () -> ()
  >   end
  > EOF


Subexpressions instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     val foo = print_endline "foo"
  >     method bar = print_endline "bar"
  >   end
  > EOF


Virtual method preserved.

  $ bash ../test.sh <<'EOF'
  > class virtual foo =
  > object
  >   method virtual bar : unit
  > end
  > EOF


Polymorphic type annotations preserved.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     method foo : 'a. unit = ()
  >     method bar : 'a. 'a -> unit = fun _ -> ()
  >   end
  > EOF
