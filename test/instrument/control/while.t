Loop body is instrumented. Condition is not instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = while true do () done
  > EOF


Recursive instrumentation of subexpressions.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   while
  >     (while true do () done); true
  >   do
  >     while true do () done
  >   done
  > EOF


Subexpressions not in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = while bool_of_string "true" do print_endline "foo" done
  > EOF
