var need_to_login;
var encryptedData;
var unencryptedEvents;
// The root of the site is redirected to the calendar
$.getJSON('.json', function(data) {
  need_to_login = data['need_to_login'];
  encryptedData = data['contents'];
  $('.feedback_link').feedback({tabPosition: 'bottom_right'});
  $("#toolbar a").button();
  $('[type="button"]').button();
  // If the user needs to login, display the login box on top of the calendar
  if(need_to_login) {
  $("#hidden_link").fancybox({'modal':true,
                              'width': 350,
                              'height': 250
                            }).trigger('click');
  }
  $('#logout').click(function(){
    sessionStorage.clear();
    document.location.href='logout';
  });
  initFancyboxes();
  unencryptedEvents = unencryptData();
  initCalendar();
});

function unencryptData() {
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

function initCalendar () {

  //Preparing the delete links.
  // TODO fix this somehow
  var deleteLinkArray=new Array();
  //<% @events.each_with_index do |event,indexOfEvent| %>
    //var index='<%= event.id %>'
    //deleteLinkArray[index]= '<%= link_to 'Delete', event ,:confirm => 'Are you sure?',
                             //:method => :delete, :phone_number => @user.phone_number %>';
  //<% end %>

  var divMap;

  // Gets information about the calendar that was stored in session storage
  // The Session storage is used in order to remember what view the calendar is showing.
  // This information is used by the pie chart
  // For instance, if the calendar is currently on a week in January, the pie chart should show
  //   data only from that same week.
  var currentYear = sessionStorage.getItem('year');
  var currentDate= new Date();
  if (currentYear == null) {
    currentYear = currentDate.getFullYear();
  }
  var currentMonth = sessionStorage.getItem('month');
  if (currentMonth == null) {
    currentMonth = currentDate.getMonth();
  }
  var viewOfCalendar = sessionStorage.getItem('view');
  if (viewOfCalendar == null) {
    viewOfCalendar = 'month';
  }

  var startDate = sessionStorage.getItem('startDate');
  var currentDay = currentDate.getDate();
  if (startDate != null) {
    currentDay = new Date(startDate).getDate();
  }

  // page is now ready, initialize the calendar
    $('#calendar').fullCalendar({

      // put your options and callbacks here
      header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
              },
      year: currentYear,
      month: currentMonth,
      defaultView: viewOfCalendar,
      date: currentDay,
      height: 600,
      theme:true,
      events:[],
      // Triggered when the calendar loads and every time a different date-range is displayed.
      viewDisplay: function(view) {
        var calendarDate=$('#calendar').fullCalendar('getDate');
        // Remember the current view that the calendar is showing.
        sessionStorage.setItem('view', $('#calendar').fullCalendar('getView').name);
        sessionStorage.setItem('year', calendarDate.getFullYear());
        sessionStorage.setItem('month', calendarDate.getMonth());
        sessionStorage.setItem('startDate', $('#calendar').fullCalendar('getView').start.toString());
        sessionStorage.setItem('endDate', $('#calendar').fullCalendar('getView').end.toString());
        sessionStorage.setItem('pieChartName', $('.fc-header-title').text());
      },
      eventClick: function(calEvent, jsEvent, view) {
        // The following code initializes and constructs a dialog containing the data of the event
        //   that the user has just selected.
        $("#dialog").dialog({ modal: true, autoOpen:false });
        $("#dialog").dialog('open');
        //Clearing the div. This is done because we are reusing
        //  the same dialog so we have to clear the previous contents of the div
        $("#dialog").empty();
        var startTime=$.fullCalendar.parseDate(calEvent['start']);
        var endTime=$.fullCalendar.parseDate(calEvent['end']);
        $("#dialog").appendText("Start Time: " + $.fullCalendar.formatDate(startTime, "hh:mmtt")).append("<br>");
        $("#dialog").appendText("End Time: " + $.fullCalendar.formatDate(endTime, "hh:mmtt")).append("<br>");
        var divTag = document.createElement("div");
        if(calEvent['tag']){
          $(divTag).text("Tag: " + calEvent['tag']);
          $('#dialog').append(divTag);
        }
        //TODO fix this
        divMap=document.createElement("div");
        //divMap.innerHTML = '<%= link_to 'Map', "/#{@user.phone_number}/map/", :id => 'mapLink' ,:class => 'mapping'%>';
        divEdit=document.createElement("div");
        //divEdit.innerHTML = '<%= link_to 'Edit', "/events/", :class=>'editingEvent', :id =>'editing' %>';
        //divMap.children[0].href=divMap.children[0].href+calEvent['id'];
        //divEdit.children[0].href=divEdit.children[0].href+calEvent['id']+'/edit';
        divDelete=document.createElement("div");
        //divDelete.innerHTML =	deleteLinkArray[calEvent['id']];
        $("#dialog").append(divEdit.innerHTML+ " ");
        $("#dialog").append(divDelete.innerHTML + " ");

        if(calEvent['numGPSCoords'] > 0){
          $("#dialog").append(divMap.innerHTML+"<br>");
        }

        $("#dialog").dialog( "option", "title", "" );
        $('.ui-widget-overlay').click(function() { $("#dialog").dialog("close"); });
        $("#ui-dialog-title-dialog").text(calEvent['title']);

        // Initialize fancyboxes for both the map link and the edit link
        $(".mapping").fancybox({
          'width' : '70%',
          'height' : '100%',
          'autoScale' : false,
          'transitionIn' : 'none',
          'transitionOut' : 'none',
          'type' : 'iframe'
        });
        $('#editing').fancybox({
          'width' : '35%' ,
          'padding': 0,
          'height': '60%',
          'autoScale' : false,
          'transitionIn' : 'none',
          'transitionOut' : 'none',
          'type' : 'iframe'
        });
      }

    })
    var events1=initializeEvents();
    $('#calendar').fullCalendar( 'addEventSource', events1 )
}

function initFancyboxes() {

  $(".timeline").fancybox({
    'width' : '100%',
    'height' : '68%',
    'autoScale' : false,
    'transitionIn' : 'none',
    'transitionOut' : 'none',
    'type' : 'iframe'
  });
  $(".pi_chart").fancybox({
    'width' : 560,
    'height' : 450,
    'autoScale' : false,
    'transitionIn' : 'none',
    'transitionOut' : 'none',
    'type' : 'iframe'
  });
  $(".create_event").fancybox({
    'width' : '35%',
    'height' : '44%',
    'autoScale' : false,
    'transitionIn' : 'none',
    'transitionOut' : 'none',
    'type' : 'iframe'
  });
  $(".table").fancybox({
    'width' : '75%',
    'height' : '100%',
    'autoScale' : false,
    'transitionIn' : 'none',
    'transitionOut' : 'none',
    'type' : 'iframe'
  });
}

// After the data has been unencrypted, this method is used in order to turn the unencryptedEvents
//   array into another data structure that the calendar can better understand
function initializeEvents(){
  var events=new Array();
  for(var i=0; i < unencryptedEvents.length; i++){
    var event=unencryptedEvents[i];
    var eventDict={};
    eventDict['title']=event['name'];

    eventDict['start']= $.fullCalendar.formatDate(new Date(event['startTime']), "yyyy-MM-dd HH:mm:ss");
    eventDict['end']= $.fullCalendar.formatDate(new Date(event['endTime']), "yyyy-MM-dd HH:mm:ss");
    eventDict['tag']=event['tag'];
    eventDict['id']=event['id'];
    eventDict['numGPSCoords']=event['gpsCoordinates'].length
    if (eventDict["numGPSCoords"] > 0 ) {
      // attach a special css class
      // This css class will show a map icon to indiciate that
      //   this event contains an associated map.
      eventDict["className"] = "containsGPSData";
    }
    eventDict['allDay']=false // will make the time show
    events[i]=eventDict;
  }
  return events;
}
