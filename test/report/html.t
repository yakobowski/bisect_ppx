  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test.exe --instrument-with bisect_ppx
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ bisect-ppx-report html --verbose
  /tmp/dune_cram_04a365_.cram.sh/main.sh: 1: /tmp/dune_cram_04a365_.cram.sh/4.sh: bisect-ppx-report: not found
  [127]
  $ ls _coverage | sort
  ls: cannot access '_coverage': No such file or directory
  $ cat _coverage/index.html
  cat: _coverage/index.html: No such file or directory
  [1]
  $ cat _coverage/test.ml.html
  cat: _coverage/test.ml.html: No such file or directory
  [1]
