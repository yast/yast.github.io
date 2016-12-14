
// open the full version of the thumbnail images on click
$(document).ready(function() {
  $("img.thumbnail").click(function(){
    url = $(this).attr("src");
    window.open(url, "_self");
  });
});

