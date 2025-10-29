Instrumentation of cases.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match true with
  >   | true -> ()
  >   | false -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Recursive instrumentation of cases.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match
  >     match () with
  >     | () -> ()
  >   with
  >   | () ->
  >     match () with
  >     | () -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Expressions in selector don't need their out-edge instrumented. Expressions in
cases are in tail position iff the match expression is in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match print_endline "foo" with () -> print_endline "bar"
  > let _ = fun () ->
  >   match print_endline "foo" with () -> print_endline "bar"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
