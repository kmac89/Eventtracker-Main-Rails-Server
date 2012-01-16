var encryptedData;
var unencryptedEvents;
var phoneNumber;
$.getJSON('timeline.json', function(data) {
  encryptedData = data['contents'];
  phoneNumber = data['phone_number'];
  unencryptedEvents = unencryptData(encryptedData);
  $(window).load(onLoad);
  $(window).resize(onResize);
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

var tl;
var evt;
var eventSource;
var eventObject;

function onLoad() {
  eventSource = new Timeline.DefaultEventSource();
  initializeEvents();
  var bandInfos = [Timeline.createBandInfo({eventSource: eventSource,width: "70%",
                                            intervalUnit:    SimileAjax.DateTime.DAY,
                                            intervalPixels: 300,
                                          }),
                   Timeline.createBandInfo({overview: true, eventSource: eventSource,
                                            width: "30%",intervalUnit:   SimileAjax.DateTime.WEEK,
                                            intervalPixels: 200
                                          })];
  bandInfos[1].syncWith = 0;
  bandInfos[1].highlight = true;
  var oldFillInfoBubble = Timeline.DefaultEventSource.Event.prototype.fillInfoBubble;
  Timeline.DefaultEventSource.Event.prototype.fillInfoBubble = function(elmt, theme, labeller) {
    eventObject = this;
    var div = document.createElement("div");
    $(div).appendText(eventObject._text).append("</b><hr>");
    var div2 = document.createElement("div");
    $(div2).text("Start Time: " + dateHelpers.formatDateTime(eventObject._start));
    var div3 = document.createElement("div");
    $(div3).text("End Time: " + dateHelpers.formatDateTime(eventObject._end));
    var div4 = document.createElement("div");
    $(div4).text("Tag: " + eventObject._description);
    var div5 = document.createElement("div");
    div5.innerHTML = '<a href="/' + phoneNumber + '/map/' +'" class="mapping" id="mapLink">Map</a>';
    $(div5).find('a').fancybox({
         'width' : '70%',
         'height' : '100%',
         'autoScale' : false,
         'transitionIn' : 'none',
         'transitionOut' : 'none',
         'type' : 'iframe'
    });
    elmt.appendChild(div);
    elmt.appendChild(div2);
    elmt.appendChild(div3);

    //adds a tag if one exists
    if(eventObject._description){
      elmt.appendChild(div4);
    }

    //if size of gpsCoordinates is greater than 0
    //eventObject._id contains the size of gpsCoordinates

    if(eventObject._id > 0){
      elmt.appendChild(div5);
      div5.children[0].href=div5.children[0].href+eventObject._eventID;
    }
  }
 tl = Timeline.create(document.getElementById("my-timeline"), bandInfos);
}

var resizeTimerID = null;
function onResize() {
    if (resizeTimerID == null) {
        resizeTimerID = window.setTimeout(function() {
            resizeTimerID = null;
            tl.layout();
        }, 500);
    }
}

function initializeEvents(){
  for(var i=0; i < unencryptedEvents.length; i++){
    var event=unencryptedEvents[i];
    var myhash = new Object();
    var startDate=new Date(event['startTime']);
    var endDate=new Date(event['endTime']);
    myhash.start=startDate;
    myhash.end=endDate;
    myhash.eventID=event['id']+'';
    myhash.text=event['name'];
    myhash.description=event['tag'];
    myhash.id=myhash.gps=event['gpsCoordinates'].length + '';
    //myhash.trackNum=i%10;
    var evt = new Timeline.DefaultEventSource.Event(myhash);
    eventSource.add(evt);
  }
}
