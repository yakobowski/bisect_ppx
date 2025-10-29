New instrumented.

  $ bash ../test.sh << 'EOF'
  > class foo = object end
  > let _ = new foo
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Not instrumented in tail position.

  $ bash ../test.sh << 'EOF'
  > class foo = object end
  > let _ = fun () -> new foo
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Not instrumented inside a surrounding application expression.

  $ bash ../test.sh << 'EOF'
  > class foo () = object end
  > let _ = new foo ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
