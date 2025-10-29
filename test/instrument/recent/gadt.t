GADT. See https://github.com/aantron/bisect_ppx/issues/325.

  $ bash ../test.sh <<'EOF'
  > type _ t = A : unit t | B : bool t
  > let f : type a. a t -> unit = fun x ->
  >   match x with
  >   | A | B -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


With function.

  $ bash ../test.sh <<'EOF'
  > type _ t = A : unit t | B : bool t
  > let f : type a. a t -> unit = function
  >   | A | B -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
