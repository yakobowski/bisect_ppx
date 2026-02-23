  $ echo "(lang dune 2.7)" > dune-project
  $ echo "(executable (name t) (instrumentation (backend bisect_ppx)))" > dune
  $ cat > t.ml <<'EOF'
  > let () = print_endline "Hello"
  > EOF
  $ rm -f *.coverage report*.coverage
  $ dune exec ./t.exe --instrument-with bisect_ppx
  Hello
  $ bisect-ppx-report merge report1.coverage
  $ bisect-ppx-report html-diff report1.coverage report1.coverage
  $ grep "class=\"both\"" _coverage/t.ml.html > /dev/null
  $ grep "class=\"new\"" _coverage/t.ml.html > /dev/null
  [1]
  $ grep "class=\"lost\"" _coverage/t.ml.html > /dev/null
  [1]
