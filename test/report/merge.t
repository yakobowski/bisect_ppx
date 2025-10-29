Merge two files

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executables
  >  (names test_merge1 test_merge2)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test_merge1.exe --instrument-with bisect_ppx
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ bisect-ppx-report summary --per-file
  /tmp/dune_cram_764d54_.cram.sh/main.sh: 1: /tmp/dune_cram_764d54_.cram.sh/4.sh: bisect-ppx-report: not found
  [127]
  $ dune exec ./test_merge2.exe --instrument-with bisect_ppx
  File "dune", line 3, characters 27-37:
  3 |  (instrumentation (backend bisect_ppx)))
                                 ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  [1]
  $ bisect-ppx-report summary --per-file
  /tmp/dune_cram_764d54_.cram.sh/main.sh: 1: /tmp/dune_cram_764d54_.cram.sh/6.sh: bisect-ppx-report: not found
  [127]
  $ bisect-ppx-report merge merged.temp
  /tmp/dune_cram_764d54_.cram.sh/main.sh: 1: /tmp/dune_cram_764d54_.cram.sh/7.sh: bisect-ppx-report: not found
  [127]
  $ rm -rf _build; rm *.coverage; mv merged.temp merged.coverage
  rm: cannot remove '*.coverage': No such file or directory
  mv: cannot stat 'merged.temp': No such file or directory
  [1]
  $ bisect-ppx-report summary --per-file
  /tmp/dune_cram_764d54_.cram.sh/main.sh: 1: /tmp/dune_cram_764d54_.cram.sh/9.sh: bisect-ppx-report: not found
  [127]
