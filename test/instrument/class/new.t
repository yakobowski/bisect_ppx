New instrumented.

  $ bash ../test.sh << 'EOF'
  > class foo = object end
  > let _ = new foo
  > EOF


Not instrumented in tail position.

  $ bash ../test.sh << 'EOF'
  > class foo = object end
  > let _ = fun () -> new foo
  > EOF


Not instrumented inside a surrounding application expression.

  $ bash ../test.sh << 'EOF'
  > class foo () = object end
  > let _ = new foo ()
  > EOF
