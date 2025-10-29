Instrumentation of internal entry point.

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Preservation of labeled arguments and their patterns.

  $ bash ../test.sh <<'EOF'
  > let _ = fun ~l:_ -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Preservation of optional labeled arguments.

  $ bash ../test.sh <<'EOF'
  > let _ = (fun ?l:_ -> ()) [@ocaml.warning "-16"]
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Preservation of default values. Instrumentation of entry into default values.
Recursive instrumentation of default values.

  $ bash ../test.sh <<'EOF'
  > let _ = fun ?(l = fun () -> ()) -> l
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Recursive instrumentation of main subexpression. Instrumentation suppressed on
"between arguments."

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> fun () -> ()
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Instrumentation placed correctly if immediate child is a "return type"
constraint.

  $ bash ../test.sh <<'EOF'
  > let _ = fun () -> (() : unit)
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Gentle handling of optional argument elimination. See
https://github.com/aantron/bisect_ppx/issues/319.

  $ bash ../test.sh <<'EOF'
  > let f () ?x () =
  >   x
  > 
  > let () =
  >   ignore (List.map (f ()) [])
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


Expressions in default value are not in tail position; expressions in main
subexpression are.

  $ bash ../test.sh <<'EOF'
  > [@@@ocaml.warning "-27"]
  > let _ =
  >   fun ?(l = print_endline "foo") () -> print_endline "bar"
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
