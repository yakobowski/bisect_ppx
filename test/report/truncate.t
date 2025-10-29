A successful run with a complete .coverage file.

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
  $ mv bisect*.coverage bisect0.coverage
  mv: cannot stat 'bisect*.coverage': No such file or directory
  [1]
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/6.sh: bisect-ppx-report: not found
  [127]


Truncate the .coverage file, clipping one of the integer arrays.

  $ truncate -c -s 56 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/9.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 55 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/12.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 54 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/15.sh: bisect-ppx-report: not found
  [127]


Truncate the whole array.

  $ truncate -c -s 53 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/18.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 52 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/21.sh: bisect-ppx-report: not found
  [127]


Truncate a string.

  $ truncate -c -s 30 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/24.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 29 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/27.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 28 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/30.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 22 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/33.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 21 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/36.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 20 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/39.sh: bisect-ppx-report: not found
  [127]


Truncate the file header.

  $ truncate -c -s 18 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/42.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 17 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/45.sh: bisect-ppx-report: not found
  [127]

  $ truncate -c -s 16 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/48.sh: bisect-ppx-report: not found
  [127]


Truncate the whole file.

  $ truncate -c -s 0 bisect0.coverage
  $ cat bisect0.coverage
  cat: bisect0.coverage: No such file or directory
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_d7c42c_.cram.sh/main.sh: 1: /tmp/dune_cram_d7c42c_.cram.sh/51.sh: bisect-ppx-report: not found
  [127]
