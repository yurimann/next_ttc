$(document).on("ready", function(){

  var url = "https://hooks.slack.com/services/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";
  var text = $("#result").val();
  $.ajax({
      data: 'payload=' + JSON.stringify({
          "text": text
      }),
      dataType: 'json',
      processData: false,
      type: 'POST',
      url: url
  });

})
