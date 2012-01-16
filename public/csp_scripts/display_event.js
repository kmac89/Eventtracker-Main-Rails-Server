// Setting the input fields to read only in order to avoid confusion
$('#name').attr('disabled', true);
$('#notes').attr('disabled', true);
$('#tag').attr('disabled', true);
$('#endTime').attr('disabled', true);
$('#startTime').attr('disabled', true);
$('#startTime').unbind();
$('#endTime').unbind();
// Change the text color to the default since the text in disabled input fields by default
//  have a light grey color.
$('input').css('color', $('label').css('color'));
$('#notes').css('color', $('label').css('color'));
