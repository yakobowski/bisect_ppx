No instrumentation is inserted into expressions that are (syntactic) values.


  $ bash test.sh <<'EOF'
  > let _ = ignore
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = 0
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = let x = 0 in x
  > let _ = let _x = print_endline "foo" in print_endline "bar"
  > let _ = fun () -> let _x = print_endline "foo" in print_endline "bar"
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = let x = 0 and _y = 1 in x
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = (let rec x = 0 and _y = 1 in x) [@ocaml.warning "-39"]
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = (0, 1)
  > let _ = (print_endline "foo", print_endline "bar")
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = Exit
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = Failure "foo"
  > let _ = Failure (String.concat "" [])
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = `Foo
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = `Foo "bar"
  > let _ = `Foo (print_endline "foo")
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = {contents = 0}
  > let _ = {contents = print_endline "foo"}
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > [@@@ocaml.warning "-23"]
  > let _ = {{contents = 0} with contents = 1}
  > let _ = {{contents = ()} with contents = print_endline "foo"}
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = {contents = 0}.contents
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = {contents = 0}.contents <- 1
  > let _ = {contents = ()}.contents <- print_endline "foo"
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = [|0; 1|]
  > let _ = [|print_endline "foo"; print_endline "bar"|]
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = (); 0
  > let _ = print_endline "foo"; print_endline "bar"
  > let _ = fun () -> print_endline "foo"; print_endline "bar"
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = (0 : int)
  > let _ = (print_endline "foo" : unit)
  > let _ = fun () -> (print_endline "foo" : unit)
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = (`Foo :> [ `Foo | `Bar ])
  > let f () = `Foo
  > let _ = (f () :> [ `Foo | `Bar ])
  > let _ = fun () -> (f () :> [ `Foo | `Bar ])
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > let _ = let module Foo = struct end in 0
  > let _ =
  >   let module Foo = struct let () = print_endline "foo" end in
  >   print_endline "bar"
  > let _ = fun () ->
  >   let module Foo = struct let () = print_endline "foo" end in
  >   print_endline "bar"
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > module type X = sig val x : unit end
  > let _ = (module struct let x = () end : X)
  > let _ = (module struct let x = print_endline "foo" end : X)
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash test.sh <<'EOF'
  > [@@@ocaml.warning "-33"]
  > let _ = let open List in ignore
  > let _ = let open List in print_endline "foo"
  > let _ = fun () -> let open List in print_endline "foo"
  > EOF
  test.sh: line 48: ocamlformat: command not found
  [127]
