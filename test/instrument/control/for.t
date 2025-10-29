Loop body is instrumented. Condition and bound are not instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   for _index = 0 to 1 do
  >     ()
  >   done
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Direction is preserved.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   for _index = 1 downto 0 do
  >     ()
  >   done
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Recursive instrumentation of subexpressions.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   for _index = (for _i = 0 to 1 do () done); 0
  >   to (for _i = 0 to 1 do () done); 1
  >   do
  >     for _i = 0 to 1 do () done
  >   done
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Subexpressions not in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   for _index = int_of_string "0" to int_of_string "1" do
  >     print_endline "foo"
  >   done
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
