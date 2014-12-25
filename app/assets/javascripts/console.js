var Console = {

  init:function () {
    Console.readout = $('#readout');
    Console.button = $('#submit');
    Console.field = $('#message');

    Console.button.on('click', function() {
      Console.send_message();
    });

    Console.field.on('keyup', function(event){
      if (event.keyCode == 13) {
        Console.send_message();
      }
    });

  },

  message:'',


  send_message:function () {
    this.message = this.field.val();
    this.display('<div class="input">> ' + this.message + '</div>');
    this.field.val('');

    if (this.message.length > 0) {
      $.post(
        '/messages',
        {message:this.message},
        function (response) {
          console.log(response);
          var feedback = "<div class='"+response['response']+"'>" ;
          feedback = feedback.concat(response['display'].replace(/\n/g,"<br/>"));
          feedback = feedback.concat('</div>');
          Console.display(feedback);
        },
        'json'
      );
    }
  },

  display: function(content) {
    Console.readout.append(content);
    Console.scroll_to_bottom();
  },

  scroll_to_bottom: function () {
    Console.readout.scrollTop(Console.readout[0].scrollHeight);
  }

}