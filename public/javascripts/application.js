// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
  // Define a function for later use
  
function print_todays_date( ) {
	var d = new Date( );                  // Get today's date and time
	document.write(d.toLocaleString( ));  // Insert it into the document
}

/*
 * **  jquery.text.js -- Utilitaires sur l'utilisation de TextNode
 * **  Copyright (c) 2007 France T�l�com
 * **  Julien Wajsberg <julien.wajsberg@orange-ftgroupe.com>
 * **
 * **  Projet Siclome
 * **
 * **  $LastChangedDate$
 * **  $LastChangedRevision$
 * */

(function($) {
  /* jQuery object extension methods */
  $.fn.extend({
    appendText: function(e) {
      if ( typeof e == "string" )
        return this.append( document.createTextNode( e ) );
      return this;
    }
  });
})(jQuery);

