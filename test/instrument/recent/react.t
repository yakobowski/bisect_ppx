Let-bindings with [@@react.component] are not instrumented at their top level.

  $ bash ../test.sh <<'EOF'
  > module React = struct let forwardRef f = f () end
  > 
  > let make1 = fun () -> ignore ignore
  >   [@@react.component]
  > 
  > let make2 () = ignore ignore
  >   [@@react.component]
  > 
  > let make3 = React.forwardRef (fun r -> ignore r)
  >   [@@react.component]
  > EOF
  ../test.sh: line 48: ocamlformat: command not found
  [127]
