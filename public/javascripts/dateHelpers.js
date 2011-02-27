/*! encryptionHelpers 
*
* A javascript file containing helper methods relating to encryption
*/
var dateHelpers ={

	formatDateTime:function(time) {
	var dateTime=new Date(time);
	var am_pm = '';
	var hour = dateTime.getHours();
	var min = dateTime.getMinutes();
	var month = dateTime.getMonth() + 1;
	var monthIndex=dateTime.getMonth();
	var monthArray=['Jan','Feb','Mar','Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
	var day = dateTime.getDate();
	day = (day < 10) ? '0' + day : day;
	month = (month < 10) ? '0' + month : month;
	am_pm = (hour < 12) ? "AM" : "PM";
	hour = (hour == 0) ? 12 : (hour > 12) ? hour - 12 : hour;
	hour = (hour < 10) ? '0' + hour : hour;
	min = (min < 10) ? '0' + min : min;
  	return hour + ':' + min + ' ' + am_pm + ' ' + monthArray[monthIndex]+ ' ' + day + ',' + " " + dateTime.getFullYear();
        }
	
	
}
