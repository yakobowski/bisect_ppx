Wildcard.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | _ -> ()
  > EOF


Variable.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | x -> x
  > EOF


Nullary constructor.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match () with
  >   | () -> ()
  > EOF


Constant.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match 0 with
  >   | 0 -> ()
  >   | _ -> ()
  > EOF


Interval.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match 'a' with
  >   | 'a'..'z' -> ()
  >   | _ -> ()
  > EOF


Nullary polymorphic variand.

  $ bash ../test.sh <<'EOF'
  > let _ =
  >   match `A with
  >   | `A -> ()
  > EOF


Polymorphic variant type name.

  $ bash ../test.sh <<'EOF'
  > type t = [ `A ]
  > let _ =
  >   match `A with
  >   | #t -> ()
  > EOF


Module.

  $ bash ../test.sh <<'EOF'
  > module type L = module type of List
  > let _ =
  >   match (module List : L) with
  >   | (module L) -> ()
  > EOF
