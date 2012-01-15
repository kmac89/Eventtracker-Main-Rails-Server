$(document).ready(function () {
  var width = $(window).width();
  var height = $(window).height();
  $.cookie('login_width', width);
  $.cookie('login_height', height);
  $("#back_link").attr("href", "/login");
  fancyboxHelpers.resize(document);
});

