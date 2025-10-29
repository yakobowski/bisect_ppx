  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (include_subdirs unqualified)
  > 
  > (executable
  >   (name test_tree)
  >   (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test_tree.exe --instrument-with bisect_ppx
  File "dune", line 5, characters 28-38:
  5 |   (instrumentation (backend bisect_ppx)))
                                  ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ bisect-ppx-report html --verbose
  /tmp/dune_cram_72e3e4_.cram.sh/main.sh: 1: /tmp/dune_cram_72e3e4_.cram.sh/4.sh: bisect-ppx-report: not found
  [127]
  $ ls _coverage | sort
  ls: cannot access '_coverage': No such file or directory
  $ ls _coverage/foo | sort
  ls: cannot access '_coverage/foo': No such file or directory
  $ ls _coverage/foo/bar | sort
  ls: cannot access '_coverage/foo/bar': No such file or directory
  $ ls _coverage/baz | sort
  ls: cannot access '_coverage/baz': No such file or directory
  $ cat _coverage/index.html
  cat: _coverage/index.html: No such file or directory
  [1]
  $ cat _coverage/test_tree.ml.html
  cat: _coverage/test_tree.ml.html: No such file or directory
  [1]
  $ cat _coverage/foo/foo.ml.html
  cat: _coverage/foo/foo.ml.html: No such file or directory
  [1]
