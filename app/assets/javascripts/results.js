$(document).on("ready", function(){

  var url = "https://hooks.slack.com/services/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";
  var text = $("#result").val();
  $.ajax({
      data: 'payload=' + "{" + '"text"' + ":" + '"' + text + '"' + "}",
      dataType: 'json',
      processData: false,
      type: 'POST',
      url: url
  });

  // $.ajax({
  //   url: "https://peaceful-everglades-87508.herokuapp.com/next.json",
  //   // url: "/next",
  //   dataType: 'JSON',
  //   type: 'POST',
  //   data: {}
  // }).done(function(e){
  //   console.log(e);
  // }).fail(function(jqXHR, textStatus, errorThrown){
  //    console.log("error " + textStatus);
  //    console.log("incoming Text " + jqXHR.responseText);
  // })
})
