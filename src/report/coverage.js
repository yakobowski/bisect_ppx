function tool_tip_element()
{
    var element = document.querySelector("#tool-tip");
    if (element === null) {
        element = document.createElement("div");
        element.id = "tool-tip";
        document.querySelector("body").appendChild(element);
    }

    return element;
};

var tool_tip = tool_tip_element();
var html = document.getElementsByTagName("html")[0];

function attach_tool_tip()
{
    document.querySelector("body").onmousemove = function (event)
    {
        var element = event.target;
        if (element.dataset.count === undefined)
            element = event.target.parentNode;

        if (element.dataset.count && element.dataset.count !== "0") {
            tool_tip.textContent = element.dataset.count;
            tool_tip.classList.add("visible");

            if (event.clientY < html.clientHeight - 48)
                tool_tip.style.top = event.clientY + 7 + "px";
            else
                tool_tip.style.top = event.clientY - 32 + "px";

            tool_tip.style.left = event.clientX + 7 + "px";
        }
        else
            tool_tip.classList.remove("visible");
    }
};

attach_tool_tip();

function move_line_to_cursor(cursor_y, line_number)
{
    var id = "L" + line_number;

    var line_anchor =
      document.querySelector("a[id=" + id + "] + span");
    if (line_anchor === null)
        return;

    var line_y = line_anchor.getBoundingClientRect().top + 18;

    var y = window.scrollY;
    window.location = "#" + id;
    window.scrollTo(0, y + line_y - cursor_y);
};

function handle_navbar_clicks()
{
    var line_count = document.querySelectorAll("a[id]").length;
    var navbar = document.querySelector("#navbar");

    if (navbar === null)
        return;

    navbar.onclick = function (event)
    {
        event.preventDefault();

        var line_number =
          Math.floor(event.clientY / navbar.clientHeight * line_count + 1);

        move_line_to_cursor(event.clientY, line_number);
    };
};

handle_navbar_clicks();

function handle_line_number_clicks()
{
    document.querySelector("body").onclick = function (event)
    {
        if (event.target.tagName != "A")
          return;

        var line_number_location = event.target.href.search(/#L[0-9]+\$/);
        if (line_number_location === -1)
          return;

        var anchor = event.target.href.slice(line_number_location);

        event.preventDefault();

        var y = window.scrollY;
        window.location = anchor;
        window.scrollTo(0, y);
    };
};

handle_line_number_clicks();

function handle_collapsible_click()
{
    document.querySelectorAll("summary").forEach(
        function (summary)
        {
            summary.onclick = function (event)
            {
                var details = summary.parentElement;

                function update_collapsible_state() {
                    var collapsible_state = JSON.parse(localStorage.getItem("bisect_ppx_collapsible_state") || "{}");
                    document.querySelectorAll("#files details").forEach(function(d) {
                        var path = d.dataset.path;
                        if (path) {
                            collapsible_state[path] = d.hasAttribute('open') ? 'expanded' : 'collapsed';
                        }
                    });
                    localStorage.setItem("bisect_ppx_collapsible_state", JSON.stringify(collapsible_state));
                }

                var all_open = function (sub_details) {
                    var all_are_open = true;
                    for (let details of sub_details) {
                        all_are_open =
                            all_are_open &&
                            details.hasAttribute('open');
                    }
                    return all_are_open;
                };

                var all_toggle = function (sub_details, toggle) {
                    for (let details of sub_details) {
                        if (toggle)
                            details.removeAttribute('open');
                        else
                            details.setAttribute('open', '');
                    }
                };

                setTimeout(update_collapsible_state, 0);

                // ctrl-click toggles the state of the folder and all sub-folders, recursively:
                //  - if all sub-folders are opened, then all sub-folders are closed
                //  - if at least one sub-folder is closed (or the folder itself),
                //    then all sub-folders are opened
                if (event.ctrlKey) {
                    var sub_details = Array.prototype.slice.call(
                        details.querySelectorAll("details")
                    );
                    sub_details.push(details);
                    all_toggle(sub_details, all_open(sub_details));
                    return false;
                }

                // shift-click toggles the state of all immediate sub-folders:
                //   - if the folder is closed, just open it
                //   - if the folder is opened:
                //     - if all sub-folders are opened, then all sub-folders are closed
                //     - if at least one sub-folder is closed, then all sub-folders are opened
                if (event.shiftKey && details.hasAttribute('open')) {
                    details.setAttribute('open', '');
                    var sub_details =
                        Array.prototype.filter.call(
                            details.querySelectorAll("details"),
                            function (sub_details) {
                                return sub_details.parentNode === details;
                            }
                        );
                    all_toggle(sub_details, all_open(sub_details));
                    return false;
                }
            };
        });
}

handle_collapsible_click();

function handle_settings_clicks()
{
    var show_empty_checkbox = document.querySelector("#show-empty-files-input");
    var tree_view_checkbox = document.querySelector("#tree-view-input");

    if (show_empty_checkbox === null)
        return; // Not on the index page

    var settings_div = document.querySelector("#settings");
    var show_empty_label = document.querySelector("label[for='show-empty-files-input']");
    var tree_view_label = document.querySelector("label[for='tree-view-input']");

    var div1 = document.createElement('div');
    div1.appendChild(show_empty_checkbox.cloneNode(true));
    div1.appendChild(show_empty_label.cloneNode(true));

    var div2 = document.createElement('div');
    div2.appendChild(tree_view_checkbox.cloneNode(true));
    div2.appendChild(tree_view_label.cloneNode(true));

    var group_files_checkbox = document.createElement('input');
    group_files_checkbox.type = 'checkbox';
    group_files_checkbox.id = 'group-files-input';

    var group_files_label = document.createElement('label');
    group_files_label.htmlFor = 'group-files-input';
    group_files_label.textContent = ' group files';

    var div3 = document.createElement('div');
    div3.style.marginLeft = '20px';
    div3.appendChild(group_files_checkbox);
    div3.appendChild(group_files_label);

    settings_div.innerHTML = '';
    settings_div.appendChild(div1);
    settings_div.appendChild(div2);
    settings_div.appendChild(div3);

    show_empty_checkbox = document.querySelector("#show-empty-files-input");
    tree_view_checkbox = document.querySelector("#tree-view-input");
    group_files_checkbox = document.querySelector("#group-files-input");

    var files_container = document.querySelector("#files");
    // Clone elements to keep originals pristine
    var all_files = Array.prototype.slice.call(files_container.querySelectorAll("div[data-total]")).map(function (el) {
        return el.cloneNode(true);
    });

    function render() {
        var show_empty = show_empty_checkbox.checked;
        var use_tree_view = tree_view_checkbox.checked;
        var group_files = group_files_checkbox.checked;

        var visible_files = all_files.filter(function(el) {
            return show_empty || el.dataset.total !== '0';
        });

        if (use_tree_view) {
            var tree = { dirs: {}, files: [], stats: { visited: 0, total: 0 } };

            visible_files.forEach(function(file_element) {
                var link = file_element.querySelector("a");
                var dirname_span = link.querySelector("span.dirname");
                var dirname = dirname_span ? dirname_span.textContent : "";
                var basename = link.lastChild.textContent;
                var path = dirname + basename;

                var stats_span = file_element.querySelector("span.stats");
                var stats_text = stats_span.textContent;
                var matches = stats_text.match(/\((\d+)\s*\/\s*(\d+)\)/);
                var visited = parseInt(matches[1]);
                var total = parseInt(matches[2]);

                var path_components = path.split('/').filter(function(c) { return c.length > 0; });

                var current_level = tree;
                tree.stats.visited += visited;
                tree.stats.total += total;

                for (var j = 0; j < path_components.length - 1; j++) {
                    var dir = path_components[j];
                    if (!current_level.dirs[dir]) {
                        current_level.dirs[dir] = { dirs: {}, files: [], stats: { visited: 0, total: 0 } };
                    }
                    current_level = current_level.dirs[dir];
                    current_level.stats.visited += visited;
                    current_level.stats.total += total;
                }

                var filename = path_components.length > 0 ? path_components[path_components.length - 1] : basename;
                current_level.files.push({ element: file_element, name: filename });
            });

            var collapsible_state = JSON.parse(localStorage.getItem("bisect_ppx_collapsible_state") || "{}");

            function render_tree_node(node, name, path) {
                var dir_html = "";
                var sorted_dirs = Object.keys(node.dirs).sort();
                var current_path = path ? path + '/' + name : name;

                sorted_dirs.forEach(function(dir_name) {
                    dir_html += render_tree_node(node.dirs[dir_name], dir_name, current_path);
                });

                var file_html = "";
                node.files.sort(function(a, b) {
                    return a.name.localeCompare(b.name);
                }).forEach(function(file) {
                    var new_file_element = file.element.cloneNode(true);
                    var link = new_file_element.querySelector("a");
                    var dirname_span = link.querySelector("span.dirname");
                    if (dirname_span) {
                        dirname_span.textContent = "";
                    }

                    var indicator_html = '<span class="summary-indicator"></span>';
                    new_file_element.insertAdjacentHTML('afterbegin', indicator_html);

                    file_html += new_file_element.outerHTML;
                });

                if (group_files && dir_html !== "" && file_html !== "") {
                    var file_stats = { visited: 0, total: 0 };
                    node.files.forEach(function(file) {
                        var stats_span = file.element.querySelector("span.stats");
                        var stats_text = stats_span.textContent;
                        var matches = stats_text.match(/\((\d+)\s*\/\s*(\d+)\)/);
                        file_stats.visited += parseInt(matches[1]);
                        file_stats.total += parseInt(matches[2]);
                    });

                    var file_percentage = 0;
                    if (file_stats.total > 0) {
                        file_percentage = Math.floor(100 * file_stats.visited / file_stats.total);
                    }

                    var files_path = (current_path ? current_path + '/' : '') + '(files)';
                    var files_open_attr;
                    if (collapsible_state[files_path] === 'collapsed') {
                        files_open_attr = '';
                    } else if (collapsible_state[files_path] === 'expanded') {
                        files_open_attr = 'open';
                    } else {
                        files_open_attr = ''; // Default collapsed
                    }

                    file_html = '<details data-path="' + files_path + '" ' + files_open_attr + '>' +
                        '<summary>' +
                        '<span class="summary-indicator"></span>' +
                        '<div class="directory">' +
                        '<span class="meter">' +
                        '<span class="covered" style="width: ' + file_percentage + '%"></span>' +
                        '</span>' +
                        '<span class="percentage">' + file_percentage + '% <span class="stats">(' + file_stats.visited + ' / ' + file_stats.total + ')</span></span>' +
                        '<span class="dirname">(files)</span>' +
                        '</div>' +
                        '</summary>' +
                        file_html +
                        '</details>';
                }

                if (name === null) { // Root
                    return dir_html + file_html;
                }

                var percentage = 0;
                if (node.stats.total > 0) {
                    percentage = Math.floor(100 * node.stats.visited / node.stats.total);
                }

                var open_attr;
                if (collapsible_state[current_path] === 'collapsed') {
                    open_attr = '';
                } else if (collapsible_state[current_path] === 'expanded') {
                    open_attr = 'open';
                } else {
                    var has_subdirs = sorted_dirs.length > 0;
                    if(has_subdirs) {
                        open_attr = 'open'; // Default open
                    } else {
                        open_attr = '';
                    }
                }

                return '<details data-path="' + current_path + '" ' + open_attr + '>' +
                    '<summary>' +
                    '<span class="summary-indicator"></span>' +
                    '<div class="directory">' +
                    '<span class="meter">' +
                    '<span class="covered" style="width: ' + percentage + '%"></span>' +
                    '</span>' +
                    '<span class="percentage">' + percentage + '% <span class="stats">(' + node.stats.visited + ' / ' + node.stats.total + ')</span></span>' +
                    '<span class="dirname">' + name + '/</span>' +
                    '</div>' +
                    '</summary>' +
                    dir_html + file_html +
                    '</details>';
            }

            files_container.innerHTML = render_tree_node(tree, null, null);

        } else { // flat view
            files_container.innerHTML = "";
            visible_files.forEach(function(el) {
                files_container.appendChild(el);
            });
        }
        handle_collapsible_click();
    }

    show_empty_checkbox.onchange = function () {
        localStorage.setItem("show-empty-files", show_empty_checkbox.checked);
        render();
    };

    tree_view_checkbox.onchange = function () {
        localStorage.setItem("tree-view", tree_view_checkbox.checked);
        group_files_checkbox.disabled = !tree_view_checkbox.checked;
        render();
    };

    group_files_checkbox.onchange = function () {
        localStorage.setItem("group-files", group_files_checkbox.checked);
        render();
    };

    var show_empty_files = localStorage.getItem("show-empty-files");
    if (show_empty_files === null) show_empty_files = "false";
    show_empty_checkbox.checked = show_empty_files === "true";

    var tree_view = localStorage.getItem("tree-view");
    if (tree_view === null) tree_view = "true";
    tree_view_checkbox.checked = tree_view === "true";
    group_files_checkbox.disabled = !tree_view_checkbox.checked;

    var group_files = localStorage.getItem("group-files");
    if (group_files === null) group_files = "true";
    group_files_checkbox.checked = group_files === "true";

    render();
};

handle_settings_clicks();
