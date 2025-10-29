Instrumentation of cases. No instrumentation of main subexpression.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try ()
  >   with
  >   | Exit -> ()
  >   | Failure _ -> ()
  > EOF


Recursive instrumentation of subexpressions.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try
  >     try () with _ -> ()
  >   with _ ->
  >     try () with _ -> ()
  > EOF


Main subexpression is not in tail position. Handler is in tail position iff the
whole expression is in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try print_endline "foo" with _ -> print_endline "bar"
  > let _ = fun () ->
  >   try print_endline "foo" with _ -> print_endline "bar"
  > EOF


Or-pattern.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try ()
  >   with Exit | End_of_file -> ()
  > EOF
