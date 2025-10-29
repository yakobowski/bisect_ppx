If there is a pattern guard, pattern instrumentation is placed on it instead.
The nested expression gets a fresh instrumentation point, being the out-edge of
the guard, rather than the pattern.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A `B with
  >   | `A (`B | `C) when print_endline "foo"; true -> ()
  >   | _ -> ()
  > EOF

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  >   | exception (Exit | Failure _) when print_endline "foo"; true -> ()
  > EOF
