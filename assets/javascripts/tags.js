
// filter the tags to display
$(document).ready(function() {
  var current_tag = document.location.hash.substring(1);
  if (current_tag.length > 0) {
    $(".tag-group").hide();
    $(document.getElementById(current_tag)).show();
  }

  $(".tag-filter-link").click(function() {
    $(".tag-group").hide();
    var id_from_href = $(this).attr("href").substring(1);
    $(document.getElementById(id_from_href)).show();
  });

  $("#all_tags").click(function() {
    $(".tag-group").show();
  });
});

