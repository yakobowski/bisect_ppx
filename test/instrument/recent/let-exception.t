  $ bash ../test.sh <<'EOF'
  > [@@@ocaml.warning "-38"]
  > let _ =
  >   let exception E in print_endline "foo"
  > let _ = fun () ->
  >   let exception E in print_endline "foo"
  > EOF
