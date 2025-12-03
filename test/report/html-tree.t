  $ echo "(lang dune 2.7)" > dune-project
  $ cat > dune <<'EOF'
  > (executable
  >  (name test)
  >  (instrumentation (backend bisect_ppx)))
  > EOF
  $ dune exec ./test.exe --instrument-with bisect_ppx
  $ bisect-ppx-report html --tree
  $ cat _coverage/index.html
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8"/>
      <title>Coverage report</title>
      <meta name="description" content="33.33% coverage overall"/>
      <link rel="stylesheet" type="text/css" href="coverage.css"/>
    </head>
    <body data-tree-view="true">
      <div id="header">
        <h1>Coverage report</h1>
        <h2>33.33%</h2>
      </div>
      <div id="settings">
        <div>
          <input type="checkbox" id="show-empty-files-input" />
          <label for="show-empty-files-input">show empty files</label>
        </div>
        <div>
          <input type="checkbox" id="tree-view-input" />
          <label for="tree-view-input">tree view</label>
        </div>
        <div style="margin-left: 20px">
          <input type="checkbox" id="group-files-input" />
          <label for="group-files-input">group files</label>
        </div>
        <div id="sorting-options">
          <span>sort by:</span>
          <div>
            <input type="radio" id="filename-sort" name="sort" value="filename" checked />
            <label for="filename-sort">filename</label>
          </div>
          <div>
            <input type="radio" id="coverage-sort" name="sort" value="coverage" />
            <label for="coverage-sort">coverage</label>
          </div>
          <div>
            <input type="radio" id="nb-statements-sort" name="sort" value="nb-statements" />
            <label for="nb-statements-sort">nb statements</label>
          </div>
        </div>
      </div>
      <div id="files">
        <div data-total="6" data-statements="6" data-coverage="33.33">
          <span class="meter">
            <span class="covered" style="width: 33%"></span>
          </span>
          <span class="percentage">33% <span class="stats">(2 / 6)</span></span>
          <a href="test.ml.html">
            <span class="dirname"></span>test.ml
          </a>
        </div>
      </div>
      <script src="coverage.js"></script>
    </body>
  </html>
