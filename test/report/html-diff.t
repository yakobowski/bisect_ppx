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
  $ grep "lost-sort" _coverage/index.html
            <input type="radio" id="lost-sort" name="sort" value="lost" />
            <label for="lost-sort">no longer covered</label>
  $ grep "new-sort" _coverage/index.html
            <input type="radio" id="new-sort" name="sort" value="new" />
            <label for="new-sort">newly covered</label>
  $ grep "percentage" _coverage/index.html
          <span class="percentage" title="Report 1: report1.coverage&#10;Report 2: report1.coverage">100% -> 100% <span class="stats">(1, +0, -0, 0)</span></span>
