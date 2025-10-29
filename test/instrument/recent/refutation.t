Refutation cases must not be instrumented in order to still be recognized by the
compiler.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | `A | `B -> ()
  >   | `A | `B -> .
  > EOF


assert false gets special treatment by the compiler and must not be
instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | `A | `B -> ()
  >   | `C | `D -> assert false
  > EOF


assert false exception cases don't get instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | `A -> ()
  >   | exception Not_found -> assert false
  >   | exception Invalid_argument _ | exception Exit -> assert false
  > EOF
