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

  $ git init --quiet -b main
  $ export GIT_COMMITTER_NAME=C
  $ export GIT_COMMITTER_EMAIL=d
  $ export GIT_COMMITTER_DATE='Jan 1 00:00:00 2020 +0000'
  $ git commit --allow-empty --author 'A <b>' -m Foo --date 'Jan 1 00:00:00 2020 +0000' --quiet


From Travis to Coveralls.

  $ bisect-ppx-report send-to --dry-run No-such-service --verbose 2>&1 | sed s/…/.../g | sed s/\`/\'/g
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/9.sh: bisect-ppx-report: not found

  $ bisect-ppx-report send-to --dry-run coveralls --verbose 2>&1 | sed s/…/.../g | sed s/\`/\'/g
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/10.sh: bisect-ppx-report: not found

  $ bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/11.sh: bisect-ppx-report: not found
  [127]

  $ TRAVIS=true bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/12.sh: bisect-ppx-report: not found
  [127]

  $ TRAVIS=true TRAVIS_JOB_ID=100 bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/13.sh: bisect-ppx-report: not found
  [127]
  $ cat coverage.json
  cat: coverage.json: No such file or directory
  [1]


From Travis to Codecov.

  $ TRAVIS=true TRAVIS_JOB_ID=100 bisect-ppx-report send-to --dry-run Codecov --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/15.sh: bisect-ppx-report: not found
  [127]
  $ cat coverage.json
  cat: coverage.json: No such file or directory
  [1]


From CircleCI to Coveralls.

  $ CIRCLECI=true bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/17.sh: bisect-ppx-report: not found
  [127]

  $ CIRCLECI=true CIRCLE_BUILD_NUM=100 bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/18.sh: bisect-ppx-report: not found
  [127]

  $ CIRCLECI=true CIRCLE_BUILD_NUM=100 CIRCLE_PULL_REQUEST=10 bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/19.sh: bisect-ppx-report: not found
  [127]

  $ CIRCLECI=true CIRCLE_BUILD_NUM=100 CIRCLE_PULL_REQUEST=10 COVERALLS_REPO_TOKEN=abc bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/20.sh: bisect-ppx-report: not found
  [127]
  $ cat coverage.json
  cat: coverage.json: No such file or directory
  [1]


From CircleCI to Codecov.

  $ CIRCLECI=true CIRCLE_BUILD_NUM=100 bisect-ppx-report send-to --dry-run Codecov --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/22.sh: bisect-ppx-report: not found
  [127]
  $ cat coverage.json
  cat: coverage.json: No such file or directory
  [1]


From GitHub Actions to Coveralls.

  $ GITHUB_ACTIONS=true bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/24.sh: bisect-ppx-report: not found
  [127]

  $ GITHUB_ACTIONS=true GITHUB_RUN_NUMBER=100 bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/25.sh: bisect-ppx-report: not found
  [127]

  $ GITHUB_ACTIONS=true GITHUB_RUN_NUMBER=100 COVERALLS_REPO_TOKEN=abc bisect-ppx-report send-to --dry-run Coveralls --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/26.sh: bisect-ppx-report: not found
  [127]
  $ cat coverage.json
  cat: coverage.json: No such file or directory
  [1]


From GitHub Actions to Codecov

  $ GITHUB_ACTIONS=true GITHUB_RUN_NUMBER=100 bisect-ppx-report send-to --dry-run Codecov --verbose
  /tmp/dune_cram_9e29d1_.cram.sh/main.sh: 1: /tmp/dune_cram_9e29d1_.cram.sh/28.sh: bisect-ppx-report: not found
  [127]
  $ cat coverage.json
  cat: coverage.json: No such file or directory
  [1]
