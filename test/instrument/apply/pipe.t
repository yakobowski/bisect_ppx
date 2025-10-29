Pipe is given special treatment, to instrument it intuitively as an application
of a function to an argument, rather than a function to two arguments.

  $ bash ../test.sh <<'EOF'
  > let _ = "" |> String.trim
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Subexpressions instrumented recursively.

  $ bash ../test.sh <<'EOF'
  > let _ = (String.trim "") |> (fun s -> String.trim s)
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Instrumentation suppressed in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> "" |> String.trim
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Right argument is not in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = [] |> List.mem 0
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
