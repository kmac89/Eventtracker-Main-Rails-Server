// Javascript for the view used to both show events and create events
AnyTime.picker('startTime', { format: "%I:%i %p %b %d, %Y", firstDOW: 1 } );
AnyTime.picker('endTime', { format: "%I:%i %p %b %d, %Y", firstDOW: 1 } );
var encryptedData;
var unencryptedEvent;
$.getJSON(window.location.href.split("/").pop() + '.json', function(data) {
  $('#button').live("click", submitButton);
  encryptedData = data['contents'];
  if (encryptedData) {
    unencryptedEvent = unencryptData(encryptedData);
    unencryptedEvent['startTime']=dateHelpers.formatDateTime(unencryptedEvent['startTime']);
    unencryptedEvent['endTime']=dateHelpers.formatDateTime(unencryptedEvent['endTime']);
    $('#startTime').attr('value', unencryptedEvent['startTime']);
    $('#endTime').attr('value', unencryptedEvent['endTime']);
    $('#name').attr('value', unencryptedEvent['name']);
    $('#notes').attr('value', unencryptedEvent['notes']);
    $('#tag').attr('value', unencryptedEvent['tag']);
  }
  // Resize the fancybox to make room for the datepicker
  $('#startTime').click(function() {
    fancyboxHelpers.resize(document);
  })
  // Resize the fancybox to make room for the datepicker
  $('#endTime').click(function() {
    fancyboxHelpers.resize(document);
  })
  // Resize the window in case the default sizes provided were too small.
  $(window).load(function() {
    fancyboxHelpers.resize(document);
  });
});

function unencryptData(encryptedData) {
  var encryptedContent=encryptedData['event']['content'];
  encryptedContent = encryptedContent.replace(/[ \r\n]+/g,'')
  var unencryptedData=encryptionHelpers.unencrypt(encryptedContent);
  var unencryptedEvent = jQuery.parseJSON(unencryptedData);
  unencryptedEvent['id']= encryptedData['event']['id'];
  return unencryptedEvent;
}

function submitButton() {
  var passwd = localStorage.pwd;
  var startTimeString = $('#startTime').attr('value');
  var endTimeString = $('#endTime').attr('value');
  if (startTimeString == "" && endTimeString == ""){
    alert("Please enter a start time and end time");
    return;
  }else if (startTimeString == ""){
    alert("Please enter a start time");
    return;
  }else if (endTimeString == "") {
    alert("Please enter an end time");
    return;
  }
  if (new Date(startTimeString) > new Date(endTimeString)) {
    alert("Start time must be before end time");
    return;
  }
  var content = {};
  content['startTime'] = Date.parse(startTimeString);
  content['endTime'] = Date.parse(endTimeString);
  content['name'] = $('#name').attr('value');
  content['notes'] = $('#notes').attr('value');
  content['tag'] = $('#tag').attr('value');
  if (encryptedData) {
    content['gpsCoordinates'] = unencryptedEvent['gpsCoordinates'];
  }else {
    content['gpsCoordinates'] = [];
  }
  //<% if @contents %>
    //content['gpsCoordinates'] = unencryptedEvent['gpsCoordinates'];
  //<% else %>
    //content['gpsCoordinates'] = [];
  //<% end %>
  var encrypted_content = GibberishAES.enc(JSON.stringify(content), passwd);
  $('#encrypted_content').attr('value', encrypted_content);
  document.forms[0].submit();
}

