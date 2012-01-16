$(".mapping").fancybox({
    'padding': 0,
    'width' : '85%',
    'height' : '85%',
    'autoScale' : false,
    'transitionIn' : 'none',
    'transitionOut' : 'none',
    'type' : 'iframe'

});
$(".eventData").fancybox({
    'padding': 0,
    'width' : '45%',
    'height' : '65%',
    'autoScale' : false,
    'transitionIn' : 'none',
    'transitionOut' : 'none',
    'type' : 'iframe'
});
$(".editing").fancybox({
    'padding': 0,
    'width' : '45%',
    'height' : '65%',
    'autoScale' : false,
    'transitionIn' : 'none',
    'transitionOut' : 'none',
    'type' : 'iframe'
});
var test;
$.getJSON('table.json', function(data) {
  var encryptedData = data['contents'];
  var unencryptedEvents = unencryptData(encryptedData);
  populateTable(unencryptedEvents);
  // Compute the total number of hours of the all the filtered events
  // Store this number in a div.
  $(document).ready(function() {
      // Compute the total number of hours of the all the filtered events
      // Store this number in a div.
      var totalHours=computeHours($('#events').dataTable().fnGetData());
      $('#events_wrapper').append("<div id=displayTime style=font-weight:bold;> </div>");
      $('#displayTime').text("Total hours for " +numOfEvents + " activities : " + totalHours);
    });
    window.onload = function () {
      var totalHours=computeHours($('#events').dataTable().fnGetData());
     }
});

function unencryptData(encryptedData) {
  var encryptedContent= new Array();
  for (var i=0; i<encryptedData.length; i++) {
    encryptedContent[i]=encryptedData[i]['event']['content'];
  }

  for (var i=0; i<encryptedData.length; i++) {
    encryptedContent[i] = encryptedContent[i].replace(/[ \r\n]+/g,'')
  }
  var unencryptedData=encryptionHelpers.unencryptAll(encryptedContent);
  var unencryptedEvents=new Array();
  for(var i=0; i < unencryptedData.length;i++){
    unencryptedEvents[i]=jQuery.parseJSON(unencryptedData[i]);
    unencryptedEvents[i]['id']=encryptedData[i]['event']['id'];
  }
  return unencryptedEvents;
}

function populateTable (unencryptedEvents) {
  var rowElements = ['name', 'notes', 'tag'];
  var index=0;
  // Look over the rows of the table in order to populate the table.
  $('.event_row').each(function () {
    var oTable = $('#events').dataTable();
    var event_data = unencryptedEvents[index];
    for (var i=0; i<rowElements.length; i++) {
      var paramName = rowElements[i];
      var data = event_data[paramName];
      var cutOffLimit = 15;
      if (typeof(data) != 'undefined' && data.length > cutOffLimit) {
        data = data.substr(0,cutOffLimit) + "..."
        $(this).find('#' + paramName + ' a').text(data);
      }else{
        $(this).find('#' + paramName).text(data);
      }
    }
    var startTime = new Date(event_data['startTime']);
    var endTime = new Date(event_data['endTime']);
    oTable.fnUpdate(dateHelpers.formatDateTime(event_data['startTime']), this, 3);
    oTable.fnUpdate(dateHelpers.formatDateTime(event_data['endTime']), this, 4);

    // If there is no gps data, remove the link to the map
    if(typeof event_data['gpsCoordinates'] == "undefined" || event_data['gpsCoordinates'].length < 1){
      var newLink="<% @user.phone_number %>#";
      $(this).find('#map_link').remove();
    }else{
      // There is a map to show, so we need to initialize the fancybox.
    }
    index++;
  });
}

function computeHours (arrayOfEvents) {
  var totalHours=0;
  for (var i=0; i < arrayOfEvents.length; i++) {
    var startTime=new Date(arrayOfEvents[i][3]);
    var endTime=new Date(arrayOfEvents[i][4]);
    var timeDifferenceMS=endTime.getTime() - startTime.getTime();
    var timeDifferenceHrs= timeDifferenceMS/3600000;
    totalHours += timeDifferenceHrs;
  }
  return Math.round(totalHours*100)/100;
}
