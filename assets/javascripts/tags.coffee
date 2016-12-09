---
---

# filter the tags to display
$(document).ready ->
  current_tag = document.location.hash.substring(1)
  if current_tag.length > 0
    $(".tag-group").hide()
    $(document.getElementById(current_tag)).show()
    
  $(".tag-filter-link").click ->
    $(".tag-group").hide()
    id_from_href = $(this).attr("href").substring(1)
    $(document.getElementById(id_from_href)).show()

  $("#all_tags").click ->
    $(".tag-group").show()
