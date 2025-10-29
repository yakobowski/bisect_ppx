Send instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = (object method foo = () end)#foo
  > EOF


Not instrumented in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> (object method foo = () end)#foo
  > EOF


Not instrumented inside a surrounding application expression.

  $ bash ../test.sh << 'EOF'
  > let _ = (object method foo () = () end)#foo ()
  > EOF
