Bisect's runtime can install a signal handler.

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executables
  >  (names daemon)
  >  (preprocess (pps bisect_ppx --bisect-sigterm)))
  > EOF
  $ dune exec ./daemon.exe
  File "dune", line 3, characters 18-28:
  3 |  (preprocess (pps bisect_ppx --bisect-sigterm)))
                        ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  -> required by _build/default/.merlin-conf/exe-daemon
  -> required by _build/default/daemon.exe
  [1]
  $ ls bisect*.coverage | wc -l | sed 's/ *//'
  ls: cannot access 'bisect*.coverage': No such file or directory
  0
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_f55f98_.cram.sh/main.sh: 1: /tmp/dune_cram_f55f98_.cram.sh/5.sh: bisect-ppx-report: not found
  [127]
  $ rm bisect*.coverage
  rm: cannot remove 'bisect*.coverage': No such file or directory
  [1]

An application instrumented with a signal handler will write coverage
data when terminating normally:

  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executables
  >  (names normal)
  >  (preprocess (pps bisect_ppx --bisect-sigterm)))
  > EOF
  $ cat > normal.ml <<'EOF'
  > let () = ()
  > EOF
  $ dune exec ./normal.exe
  File "dune", line 3, characters 18-28:
  3 |  (preprocess (pps bisect_ppx --bisect-sigterm)))
                        ^^^^^^^^^^
  Error: Library "bisect_ppx" not found.
  -> required by _build/default/.merlin-conf/exe-normal
  -> required by _build/default/normal.exe
  [1]
  $ bisect-ppx-report summary --verbose
  /tmp/dune_cram_f55f98_.cram.sh/main.sh: 1: /tmp/dune_cram_f55f98_.cram.sh/11.sh: bisect-ppx-report: not found
  [127]
  $ rm bisect*.coverage
  rm: cannot remove 'bisect*.coverage': No such file or directory
  [1]
