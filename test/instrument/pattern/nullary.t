Wildcard.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | _ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Variable.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | x -> x
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Nullary constructor.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Constant.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match 0 with
  >   | 0 -> ()
  >   | _ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Interval.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match 'a' with
  >   | 'a'..'z' -> ()
  >   | _ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Nullary polymorphic variand.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | `A -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Polymorphic variant type name.

  $ bash ../test.sh <<'EOF'
  > type t = [ `A ]
  > let _ =
  >   match `A with
  >   | #t -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Module.

  $ bash ../test.sh <<'EOF'
  > module type L = module type of List
  > let _ =
  >   match (module List : L) with
  >   | (module L) -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
