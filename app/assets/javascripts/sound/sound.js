var Sound = {

  context:null,
  samples:{},
  patterns:{},
  sixteenth_time:100,
  step:0,
  lowest_common_multiple:0,
  player_active:false,


  init:function (attributes) {
    // set up context and gain chain
    this.get_context();
    this.master_gain = this.context.createGainNode();
    this.master_gain.value = 0.2;
    this.master_gain.connect(this.context.destination);

    // load samples
    attributes['sample_names'].forEach(function (sample_name) {
      Sound.samples[sample_name] = new Sample(sample_name);
      Sound.samples[sample_name].load_sample();
    });
    this.set_patterns(attributes['patterns']);
    this.init_player_controls();

    this.set_bpm(attributes['bpm']);
  },

  set_bpm:function (bpm) {
    var step_time = (60000 / bpm) / 4;
    Sound.sixteenth_time = step_time;

    if (Sound.player_active) {
      clearInterval(Sound.player);
      Sound.player_active = false;
      Sound.play()
    }
  },

  init_player_controls:function () {
    $('#play_button').on('click', function () {
      Sound.play()
    });
    $('#stop_button').on('click', function () {
      Sound.stop()
    });
    $('#stop_button').hide();
  },

  set_patterns:function (patts) {
    $.each(patts, function (key, attrs) {
      Sound.patterns[key] = new Pattern(attrs)
    });

    var step_counts = []
    for (key in Sound.patterns) {
      step_counts = step_counts.concat(Sound.patterns[key].steps.length);
    }
    ;
    Sound.lowest_common_multiple = Sound.LCM(step_counts);
  },

  reset_patterns:function () {
    $.get(
      '/patterns',
      {},
      function (response) {
        $.each(response, function (key, attrs) {
          if (key == 'bpm') {

            Sound.set_bpm(attrs);
          } else {
            pattern = Sound.patterns[key];
            pattern.steps = attrs['steps'];
            pattern.display();
          }
        });
      },
      'json'
    )
  },

  get_context:function () {
    if (typeof AudioContext !== "undefined") {
      this.context = new AudioContext();
    } else if (typeof webkitAudioContext !== "undefined") {
      this.context = new webkitAudioContext();
    } else {
      throw new Error('AudioContext not supported. :(');
    }
  },

  has_context:function () {
    return this.context != null
  },

  play_step:function (step) {
    $.each(this.patterns, function (name, pattern) {
      pattern.play_step(step)
    });
    this.step += 1;
    this.reset_step();
  },

  reset_step:function () {
    if ((Sound.step % Sound.lowest_common_multiple) == 0) {
      Sound.step = 0;
      Sound.reset_patterns();
    }
  },

  play:function () {
    if (!Sound.player_active) {
      Sound.step = 0;
      Sound.player = setInterval(
        function () {
          Sound.play_step(Sound.step)
        },
        this.sixteenth_time
      )
      Sound.player_active = true;
      $('#stop_button').show();
      $('#play_button').hide();
    }
  },

  stop:function () {
    if (Sound.player_active) {
      clearInterval(Sound.player);
      Sound.player_active = false;
    }
    $('#stop_button').hide();
    $('#play_button').show();
  },


  // lowest common multiple, pinched from
  // http://rosettacode.org/wiki/Least_common_multiple#JavaScript
  LCM:function (A) {
    var n = A.length, a = Math.abs(A[0]);
    for (var i = 1; i < n; i++) {
      var b = Math.abs(A[i]), c = a;
      while (a && b) {
        a > b ? a %= b : b %= a;
      }
      a = Math.abs(c * A[i]) / (a + b);
    }
    return a;
  }

}