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



function onCompareData(docdata) {
  $("#comparecontent")[0].innerHTML = docdata;
};

function onCompare() {
  if($("#input1").attr("value").length == 0 || 
     $("#input2").attr("value").length == 0) {
    alert("Both users must be specified.");
  }
  $.ajax({url:$.format("/compare/data?user1={0}&user2={1}",
                       $("#input1").attr("value"),
                       $("#input2").attr("value"))}).
    success(onCompareData).
    error(function(err) { 
            alert($.format("error. check your logs\n{0}",err)); 
          });  

};

// hook up events
function loader() {
  // TODO: look up users from URL args.
  
  $("#comparebutton").click(onCompare);
};




$(document).ready(loader);
