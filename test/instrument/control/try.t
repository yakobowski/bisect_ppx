Instrumentation of cases. No instrumentation of main subexpression.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try ()
  >   with
  >   | Exit -> ()
  >   | Failure _ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Recursive instrumentation of subexpressions.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try
  >     try () with _ -> ()
  >   with _ ->
  >     try () with _ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Main subexpression is not in tail position. Handler is in tail position iff the
whole expression is in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try print_endline "foo" with _ -> print_endline "bar"
  > let _ = fun () ->
  >   try print_endline "foo" with _ -> print_endline "bar"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Or-pattern.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   try ()
  >   with Exit | End_of_file -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
