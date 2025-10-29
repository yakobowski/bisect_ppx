Instrumentation of branches.

  $ bash ../test.sh <<'EOF'
  > let _ = if true then 1 else 2
  > EOF


Recursive instrumentation of subexpressions.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   if if true then true else false then
  >     if true then true else false
  >   else
  >     if true then true else false
  > EOF


Supports if-then.

  $ bash ../test.sh <<'EOF'
  > let _ = if true then ()
  > EOF


The next expression after if-then is instrumented as if it were an else-case.

  $ bash ../test.sh <<'EOF'
  > let _ = (if true then ()); ()
  > EOF


Condition does not need its out-edge instrumented. Expressions in cases are in
tail position iff the whole if-expression is in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   if bool_of_string "true" then print_endline "foo" else print_endline "bar"
  > let _ = fun () ->
  >   if bool_of_string "true" then print_endline "foo" else print_endline "bar"
  > EOF
