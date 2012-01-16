var numOfEvents=0;
/*
* Function: fnGetFilteredData()
* Purpose:  Retrieve an array with all data that survived filtering
* by mikej
*/
// This function was added because it was not provided by default. It is needed
// in order to calulate the duration of filtered events
$.fn.dataTableExt.oApi.fnGetFilteredData = function ( oSettings ) {
  var a = [];
  for ( var i=0, iLen=oSettings.aiDisplay.length ; i<iLen ; i++ ) {
    a.push(oSettings.aoData[ oSettings.aiDisplay[i] ]._aData);
  }
  return a;
}
jQuery(document).ready(function () {
  jQuery('.datatable').dataTable({
    "oLanguage": {
                 "sSearch": "Search",
                 "sProcessing": '<img alt="Spinner" src="/images/spinner.gif?1314120056" />'
                 },
    "sPaginationType": "full_numbers",
    "iDisplayLength": 25,
    "bProcessing": true,
    "bServerSide": false,
    "bLengthChange": false,
    "bStateSave": true,
    "bFilter": true,
    "bAutoWidth": false,
    'aaSorting': [[3, 'desc']],
    'bJQueryUI': true,
    "aoColumns": [{
                  'sType': 'html',
                  'bSortable':true,
                  'bSearchable':true,
                  'sClass':'first'
                  },
                  {
                  'sType': 'html',
                  'bSortable':true,
                  'bSearchable':true,
                  },
                  {
                  'sType': 'html',
                  'bSortable':true,
                  'bSearchable':true,
                  },
                  {
                  'sType': 'date',
                  'bSortable':true,
                  'bSearchable':true,
                  },
                  {
                  'sType': 'date',
                  'bSortable':true,
                  'bSearchable':true,
                  },
                  {
                  'sType': 'html',
                  'bSortable':true,
                  'bSearchable':true,
                  },
                  {
                  'sType': 'html',
                  'bSortable':true,
                  'bSearchable':true,
                  },
                  {
                  'sType': 'html',
                  'bSortable':true,
                  'bSearchable':true,
                  'sClass':'last'
                  }], 'fnInfoCallback': function(oSettings,iStart, iEnd, iMax, iTotal, sPre) {
                    if(numOfEvents != 0) {
                      var totalHours= computeHours($('#events').dataTable().fnGetFilteredData(oSettings));
                      $('#displayTime').text('Total hours for '  + iTotal +' activities : ' + totalHours);
                     }
                    numOfEvents= iTotal;
                    return sPre; },
                 "fnServerData": function ( sSource, aoData, fnCallback ) {
                    aoData.push(  );
                    jQuery.getJSON( sSource, aoData, function (json) {
                      fnCallback(json);
} );
}
});
});
