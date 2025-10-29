.mli files are not instrumented.

  $ echo > .ocamlformat
  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test)
  >  (modes byte)
  >  (ocamlc_flags -dsource)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ cat > test.ml <<'EOF'
  > let f () = ()
  > EOF
  $ cat > test.mli <<'EOF'
  > val f : unit -> unit
  > EOF
  $ cat > sanitize.sh <<'EOF'
  > while read line
  > do
  >   echo "$line"
  >   ! [[ "$line" =~ val ]] || exit 0
  > done
  > EOF
  $ dune build --instrument-with bisect_ppx 2>&1 | grep -v ocamlc | grep -v '^    [^ =][^ =]* =\|^  {\|^  }]\|@@@ocaml.ppx' | bash sanitize.sh | ocamlformat --name test.mli -
  /tmp/dune_cram_b6dcb8_.cram.sh/main.sh: 1: /tmp/dune_cram_b6dcb8_.cram.sh/7.sh: ocamlformat: not found
  [127]

