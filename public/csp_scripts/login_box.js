$('#login_button').live("click", storePassAndSubmit);
var width = $.cookie('login_width');
var height = $.cookie('login_height');

if (width) {
  width = parseInt(width);
  height = parseInt(height);
  fancyboxHelpers.forceSize(document,height-20, width+20);
  // Resetting the cookies
  $.cookie('login_width', null);
  $.cookie('login_height', null);
}
$('#password').keypress(function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if (code==13) {
      storePassAndSubmit();
    }
});
fancyboxHelpers.resize(document);

function storePassAndSubmit() {
  var pw = $('#password').attr('value');
  var b64_password = b64_md5(pw);
  localStorage.setItem('pwd', b64_password);
  // Hash the password again and send it to the web server to compare
  $('#user_session_password').attr('value', b64_md5(b64_password));
  $('#new_user_session').submit();
}


