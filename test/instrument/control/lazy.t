Thunk body is instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = lazy (1 + 1)
  > EOF


Recursive instrumentation of subexpression.

  $ bash ../test.sh <<'EOF'
  > let _ = lazy (lazy (1 + 1))
  > EOF


Subexpression in tail position.

  $ bash ../test.sh <<'EOF'
  > let _ = lazy (print_endline "foo")
  > EOF


Trivial syntactic values are not instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = lazy ()
  > let _ = lazy false
  > let _ = lazy 0
  > let _ = lazy 0.
  > let _ = lazy ""
  > let _ = lazy '0'
  > let _ = lazy []
  > let _ = lazy None
  > let _ = lazy Exit
  > let _ = lazy (fun () -> ())
  > let _ = lazy (function () -> ())
  > let _ = lazy (() : unit)
  > let _ = lazy (() :> unit)
  > let x = 1 + 1
  > let _ = lazy x
  > EOF
