// Caution: don't confuse Console (my terminal-type interaction) with
// console (built in js console)
var Console = {

  init:function () {
    Console.readout = $('#readout');
    Console.button = $('#submit');
    Console.field = $('#message');

    Console.button.on('click', function () {
      Console.send_message();
    });

    Console.field.on('keyup', function (event) {
      switch (event.keyCode) {
        case 13: //enter - submit message
          Console.send_message();
          break;
        case 38: // up - previous message
          Console.prev_message();
          break;
        case 40: // down - next message
          Console.next_message();
          break;
      }
    });

  },

  message:'',
  previous_messages:[],
  message_pointer:0,

  send_message:function () {
    this.message = this.field.val();

    this.previous_messages = this.previous_messages.concat(this.message);
    this.message_pointer = this.previous_messages.length;

    this.display('<div class="input">> ' + this.message + '</div>');
    this.field.val('');

    if (this.message.length > 0) {
      $.post(
        '/messages',
        {message:this.message},
        function (response) {
          console.log(response);
          var feedback = "<div class='" + response['response'] + "'>";
          feedback = feedback.concat(response['display'].replace(/\n/g, "<br/>"));
          feedback = feedback.concat('</div>');
          Console.display(feedback);
        },
        'json'
      );
    }
  },

  next_message:function () {
    if (this.message_pointer != this.previous_messages.length) {
      this.message_pointer += 1
    }
    if (this.message_pointer >= this.previous_messages.length) {
      this.message = '';
    } else {
      this.message = this.previous_messages[this.message_pointer];
    }
    this.field.val(this.message);
  },

  prev_message:function () {
    if (this.message_pointer != 0) {
      this.message_pointer -= 1
    }
    this.message = this.previous_messages[this.message_pointer];
    this.field.val(this.message);
  },

  display:function (content) {
    Console.readout.append(content);
    Console.scroll_to_bottom();
  },

  scroll_to_bottom:function () {
    Console.readout.scrollTop(Console.readout[0].scrollHeight);
  }

}