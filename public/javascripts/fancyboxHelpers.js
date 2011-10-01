/*! fancyboxHelpers
*
* A javascript file containing helper methods relating to fancybox
*/
var fancyboxHelpers={
  forceSize:function(mDocument, docHeight, docWidth) {
      var pageHeight = docHeight;
      var pageWidth =  docWidth;
      var outer = window.parent.document.getElementById('fancybox-wrap');
      var inner = window.parent.document.getElementById('fancybox-content');
      outer.style.height= pageHeight+35 +"px";
      outer.style.width= pageWidth +20+"px";
      inner.style.height= pageHeight+30 +"px";
      inner.style.width= pageWidth +2+"px";
      parent.$.fancybox.center();
  },
  resize:function(mDocument, docHeight, docWidth) {
    var hasVScroll = $(document).height() > $(window).height();
    var hasHScroll = $(document).width() > $(window).width();
    if (hasVScroll || hasHScroll) {
      var pageHeight = (typeof(docHeight) == 'undefined')  ? fancyboxHelpers.getDocHeight(mDocument) : docHeight;
      var pageWidth = (typeof(docWidth) == 'undefined')  ? fancyboxHelpers.getDocWidth(document) : docWidth;
      var outer = window.parent.document.getElementById('fancybox-wrap');
      var inner = window.parent.document.getElementById('fancybox-content');
      outer.style.height= pageHeight+35 +"px";
      outer.style.width= pageWidth +20+"px";
      inner.style.height= pageHeight+30 +"px";
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
    return Math.max(docHt, $(doc).height());
  },
  getDocWidth:function(doc) {
    var docWt = 0, docScrollWidth, docOffsetWidth;
    if (doc.body.scrollWidth) 
      docWt = docScrollWidth= doc.body.scrollWidth;
    else
      docWt = docOffsetWidth = doc.body.offsetWidth;
    if (docScrollWidth && docOffsetWidth) 
      docHt = Math.max(docScrollWidth, docOffsetWidth);
    return Math.max(docWt, $(doc).width());
  }
}

