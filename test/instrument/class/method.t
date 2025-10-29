Method "entry point" instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     method foo = ()
  >   end
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Instrumentation is inserted into nested abstractions.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     method foo () () = ()
  >     method bar = function () -> ()
  >   end
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Subexpressions instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     val foo = print_endline "foo"
  >     method bar = print_endline "bar"
  >   end
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Virtual method preserved.

  $ bash ../test.sh <<'EOF'
  > class virtual foo =
  > object
  >   method virtual bar : unit
  > end
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Polymorphic type annotations preserved.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   object
  >     method foo : 'a. unit = ()
  >     method bar : 'a. 'a -> unit = fun _ -> ()
  >   end
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
