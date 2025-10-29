Exception or-patterns.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  >   | exception (Exit | Failure _) -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Mixed value-exception cases are partitioned. Order is preserved. Case are
factored out into functions, whose parameters are the bound variables of the
patterns.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match Exit with
  >   | Exit as x | exception (Exit as x) -> ignore x; print_endline "foo"
  >   | End_of_file as y | exception (End_of_file | Failure _ as y) ->
  >     ignore y; print_endline "bar"
  >   | _ -> print_endline "baz"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
