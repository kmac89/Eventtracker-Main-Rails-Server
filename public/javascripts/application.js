// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
  // Define a function for later use
  
function print_todays_date( ) {
	var d = new Date( );                  // Get today's date and time
	document.write(d.toLocaleString( ));  // Insert it into the document
}