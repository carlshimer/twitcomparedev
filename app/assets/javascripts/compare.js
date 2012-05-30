// some syntactic sugar. 
jQuery.extend({
  format:function format() {
    var s = arguments[0];
    for(var i=0;i<arguments.length-1;i++) {
      s = s.replace(new RegExp('\\{' + i + '\\}','gm'),arguments[i+1]);
    };
    return s;
  }
});


function onCompare() {

  $.pjax({url:$.format("/compare/data?user1={0}&user2={1}",
                       $("#input1").attr("value"),
                       $("#input2").attr("value")),
          container:"#comparecontent"});
          
  return false;

};

// hook up events
function loader() {
  // TODO: look up users from URL args.
  $("a.complink").pjax("#comparecontent");
  $("#comparebutton").click(onCompare);
  
  $(document).
    on('pjax:start',function() { $("#spinner").show(); }).
    on('pjax:end',function() { 
         $("#spinner").hide(); 
         // extract the names from the url and put in the input
         // boxes
         var search = document.location.search;
         $("#input1").attr("value",search.match(/user1=(\w+)/)[1]);
         $("#input2").attr("value",search.match(/user2=(\w+)/)[1]);
       });


  // 45 second timeout. yeah we are doing a bunch of network stuff.
  $.pjax.defaults.timeout = 45000;

};




$(document).ready(loader);
