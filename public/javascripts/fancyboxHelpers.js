/*! fancyboxHelpers
*
* A javascript file containing helper methods relating to fancybox
*/
var fancyboxHelpers={
  resize:function(document, docHeight, docWidth) {
    var hasVScroll = $("body").height() > $(window).height();
    var hasHScroll = $("body").width() > $(window).width();

    if (hasVScroll || hasHScroll) {
      var pageHeight = (typeof(docHeight) == 'undefined')  ? fancyboxHelpers.getDocHeight(document) : docHeight;
      var pageWidth = (typeof(docWidth) == 'undefined')  ? fancyboxHelpers.getDocWidth(document) : docWidth;
      var outer = window.parent.document.getElementById('fancybox-wrap');
      var inner = window.parent.document.getElementById('fancybox-content');
      outer.style.height= pageHeight+25 +"px";
      outer.style.width= pageWidth +20+"px";
      inner.style.height= pageHeight+12 +"px";
      inner.style.width= pageWidth +2+"px";
      parent.$.fancybox.center();
    }
  },
  getDocHeight:function(doc) {
    var docHt = 0, docScrollHeight, docOffsetHeight;
    if (navigator.appName=="Microsoft Internet Explorer") 
      docHt = docScrollHeight = doc.body.scrollHeight;
    else
      docHt = docOffsetHeight = doc.body.offsetHeight;
    return docHt;
  },
  getDocWidth:function(doc) {
    var docWt = 0, docScrollWidth, docOffsetWidth;
    if (doc.body.scrollWidth) 
      docWt = docScrollWidth= doc.body.scrollWidth;
    else
      docWt = docOffsetWidth = doc.body.offsetWidth;
    if (docScrollWidth && docOffsetWidth) 
      docHt = Math.max(docScrollWidth, docOffsetWidth);
    return docWt;
  }
}

