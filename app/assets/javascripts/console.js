var Console = {

  init:function () {
    Console.readout = $('#readout');
  },

  message:'',


  send_message:function () {
    this.message = $('#message').val();
    this.readout.append('<div class="input">> ' + this.message + '</div>');

    if (this.message.length > 0) {
      $.post(
        '/messages',
        {message:this.message},
        function (response) {
          console.log(response);
          var feedback = "<div class='"+response['response']+"'></div>" ;
          feedback = feedback.concat(response['display'].replace("\n","<br/>"));
          feedback = feedback.concat('</div>');
          Console.readout.append(feedback);
        },
        'json'
      )
    }
  },

  scroll_to_bottom:function () {
    $('#readout').scrollTop($('#readout')[0].scrollHeight);
  }

}