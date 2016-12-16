---
---

// create a template for a new post at GitHub
function create_new_post()
{
  var title = $("#post_title").val();

  if (title != "")
  {
    var file_name = title.replace(/ /g, "-").replace(/\//g, "");
    var date = new Date();
    var date_str = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
    var url = "https://github.com/yast/yast.github.io/new/master?filename=_posts/"
      + date_str + "-" + file_name + ".md";
    var tags = "";

    if ($("#post_tags").val() != null) {
      tags = "\n- " + $("#post_tags").val().join("\n- ");
    }

    var default_text = [
      '---',
      'layout: post',
      'date: ' + date.toISOString(),
      'title: ' + title,
      'description: ' + $("#post_description").val(),
      'comments: ' + $("#comments").is(':checked'),
      'category: ' + $("#post_category").val(),
      'tags: ' + tags,
      '---',
      '',
      '',
      '## Header1',
      '',
      'Your new post here. Adapt the YAML header as needed.',
      '',
      'See the documentation at {{ site.url }}{{ site.baseurl }}/blog/how_to_write',
      'for more details.',
      ''
    ].join('\n');

    url += "&value=" + encodeURIComponent(default_text);
    window.open(url, '_self');
  }
  else {
    $("#post_title_group").addClass("has-error");
  }
  return false;
}

// Sort the "select" option list alphabetically (use JS as Jekyll/Liquid support
// only case sensitive sort, we need case insenstive here).
function sort_select_options(select) {
  var selected = $(select).val();
  var options = $(select + " option");
  var arr = options.map(function(_, o) { return { t: $(o).text(), v: o.value }; }).get();
  arr.sort(function(o1, o2) {
    var t1 = o1.t.toLowerCase(), t2 = o2.t.toLowerCase();
    return t1 > t2 ? 1 : t1 < t2 ? -1 : 0;
  });

  options.each(function(i, o) {
    o.value = arr[i].v;
    $(o).text(arr[i].t);
  });

  $(select).val(selected);
}

// Similar to the sort_select_options() above, but for HTML5 datalist
// which unfortunately has a bit different structure.
function sort_datalist_options(dl) {
  var selected = $(dl).val();
  var options = $(dl + " option");
  var arr = options.map(function(_, o) { return o.value; }).get();
  arr.sort(function(o1, o2) {
    var t1 = o1.toLowerCase(), t2 = o2.toLowerCase();
    return t1 > t2 ? 1 : t1 < t2 ? -1 : 0;
  });

  options.each(function(i, o) {
    o.value = arr[i];
  });

  $(dl).val(selected);
}

$(document).ready(function() {
  // handle the button press
  $("#create_button").click(create_new_post);
  // initialize the form - sort the lists alphabetically
  sort_select_options("#post_tags");
  sort_datalist_options("#categories_list");
});
