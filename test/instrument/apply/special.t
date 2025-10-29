Instrumentation is suppressed for all of the following function names.
Subexpressions are still instrumented.

  $ bash ../test.sh <<'EOF'
  > let _ = not (List.mem () [])
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash ../test.sh <<'EOF'
  > let _ = (print_endline "foo") = (print_endline "bar")
  > let _ = (=) (print_endline "foo") (print_endline "bar")
  > let _ = (print_endline "foo") <> (print_endline "bar")
  > let _ = (<>) (print_endline "foo") (print_endline "bar")
  > let _ = (print_endline "foo") < (print_endline "bar")
  > let _ = (<) (print_endline "foo") (print_endline "bar")
  > let _ = (print_endline "foo") <= (print_endline "bar")
  > let _ = (<=) (print_endline "foo") (print_endline "bar")
  > let _ = (print_endline "foo") > (print_endline "bar")
  > let _ = (>) (print_endline "foo") (print_endline "bar")
  > let _ = (print_endline "foo") >= (print_endline "bar")
  > let _ = (>=) (print_endline "foo") (print_endline "bar")
  > let _ = (print_endline "foo") == (print_endline "bar")
  > let _ = (==) (print_endline "foo") (print_endline "bar")
  > let _ = (print_endline "foo") != (print_endline "bar")
  > let _ = (!=) (print_endline "foo") (print_endline "bar")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash ../test.sh <<'EOF'
  > let _ = ref (print_endline "foo")
  > let _ = !(ref (print_endline "foo"))
  > let _ = ref (print_endline "foo") := (print_endline "bar")
  > let _ = (:=) (ref (print_endline "foo")) (print_endline "bar")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash ../test.sh <<'EOF'
  > let _ = (List.rev []) @ (List.rev [])
  > let _ = (@) (List.rev []) (List.rev [])
  > let _ = (String.trim "") ^ (String.trim "")
  > let _ = (^) (String.trim "") (String.trim "")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]

  $ bash ../test.sh <<'EOF'
  > let _ = (List.length []) + (List.length [])
  > let _ = (+) (List.length []) (List.length [])
  > let _ = (List.length []) - (List.length [])
  > let _ = (-) (List.length []) (List.length [])
  > let _ = (List.length []) * (List.length [])
  > let _ = ( * ) (List.length []) (List.length [])
  > let _ = (List.length []) / (List.length [])
  > let _ = (/) (List.length []) (List.length [])
  > let _ = (List.length []) mod (List.length [])
  > let _ = (mod) (List.length []) (List.length [])
  > let _ = (float_of_int 0) +. (float_of_int 0)
  > let _ = (+.) (float_of_int 0) (float_of_int 0)
  > let _ = (float_of_int 0) +. (float_of_int 0)
  > let _ = (-.) (float_of_int 0) (float_of_int 0)
  > let _ = (float_of_int 0) *. (float_of_int 0)
  > let _ = ( *. ) (float_of_int 0) (float_of_int 0)
  > let _ = (float_of_int 0) /. (float_of_int 0)
  > let _ = (/.) (float_of_int 0) (float_of_int 0)
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash ../test.sh <<'EOF'
  > let _ = (List.length []) land (List.length [])
  > let _ = (land) (List.length []) (List.length [])
  > let _ = (List.length []) lor (List.length [])
  > let _ = (lor) (List.length []) (List.length [])
  > let _ = (List.length []) lxor (List.length [])
  > let _ = (lxor) (List.length []) (List.length [])
  > let _ = (List.length []) lsl (List.length [])
  > let _ = (lsl) (List.length []) (List.length [])
  > let _ = (List.length []) lsr (List.length [])
  > let _ = (lsr) (List.length []) (List.length [])
  > let _ = (List.length []) asr (List.length [])
  > let _ = (asr) (List.length []) (List.length [])
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]


  $ bash ../test.sh <<'EOF'
  > let _ = raise (print_endline "foo"; Exit)
  > let _ = raise_notrace (print_endline "foo"; Exit)
  > let _ = failwith (print_endline "foo"; "bar")
  > let _ = ignore (print_endline "foo")
  > let _ = Obj.magic (print_endline "foo")
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
