Instrumentation of cases.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match true with
  >   | true -> ()
  >   | false -> ()
  > EOF


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


Expressions in selector don't need their out-edge instrumented. Expressions in
cases are in tail position iff the match expression is in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match print_endline "foo" with () -> print_endline "bar"
  > let _ = fun () ->
  >   match print_endline "foo" with () -> print_endline "bar"
  > EOF
