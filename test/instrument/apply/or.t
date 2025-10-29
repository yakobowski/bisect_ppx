Logical OR is expanded so that the operands can be instrumented individually.

  $ bash ../test.sh <<'EOF'
  > let _ = true || false
  > let _ = true or false
  > EOF


If the right operand is also a logical OR, the instrumentation is "associative"
rather than nested.

  $ bash ../test.sh <<'EOF'
  > let _ = true || true || false
  > let _ = true or true or false
  > EOF


Recursive instrumentation of subexpressions.

  $ bash ../test.sh <<'EOF'
  > let _ = (bool_of_string "true") || (bool_of_string "false")
  > let _ = (bool_of_string "true") or (bool_of_string "false")
  > EOF


Function calls on the right in tail position remain in tail position. Any
would-be surrounding instrumentation is suppressed.

  $ bash ../test.sh <<'EOF'
  > let f _ = (bool_of_string "true") || (bool_of_string "false")
  > let g _ =
  >   (bool_of_string "true") or ((bool_of_string [@ocaml.tailcall]) "false")
  > EOF


Surrounding instrumentation is still generated when the second function is a
well-known trivial function.

  $ bash ../test.sh <<'EOF'
  > let f _ = (bool_of_string "true") || (true <> false)
  > EOF
