var Sound = {

  context:null,
  samples:{},
  patterns:{},
  synths:{},
  sixteenth_time:100,
  step:0,
  lowest_common_multiple:0,
  player_active:false,
  version:0,

  init:function (attributes) {
    // set up context and gain chain

    this.version = (attributes['version']);

    if (this.context) {
      this.init_player_controls();
      this.display_already_loaded_samples();
      $.each(this.samples, function(key,sample){sample.setup_row()});
      $.each(this.patterns, function(key, pattern){pattern.setup_row()});
    } else {
      this.get_context();
      this.user_gain = this.context.createGain();
      this.user_gain.gain.value = 0.7;
      this.user_gain.connect(this.context.destination);

      this.master_gain = this.context.createGain();
      this.master_gain.gain.value = 0.4;
      this.master_gain.connect(this.user_gain);

      // load samples
      attributes['sample_names'].forEach(function (sample_name) {
        Sound.samples[sample_name] = new Sample(sample_name);
        Sound.samples[sample_name].load_sample();
      });
      // load synths
      attributes['synths'].forEach(function (attrs) {
        name = attrs['name'];
        Sound.synths[name] = new Synth(attrs);
      });


      this.set_patterns(attributes['patterns']);

      this.init_player_controls();

      this.set_bpm(attributes['bpm']);


    }
  },

  display_already_loaded_samples:function () {
    $('.indicator').each(function(i,indicator) {
      if (Sound.samples[indicator.id].audio) {
        $(indicator).addClass('done')
      }
    })
  },

  set_bpm:function (bpm) {
    var step_time = (60000 / bpm) / 4;
    if (step_time != Sound.sixteenth_time) {
      Sound.sixteenth_time = step_time;
      if (Sound.player_active) {
        clearInterval(Sound.player);
        Sound.player_active = false;
        Sound.play(false)
      }
    }
  },

  init_player_controls:function () {
    $('#play_button').on('click', function () {
      Sound.play(true);
    });
    $('#stop_button').on('click', function () {
      Sound.stop();
    });
    if (this.player_active) {
      $('#play_button').hide();
    } else {
      $('#stop_button').hide();
    }

    $('#user_vol').on('change', function () {
      Sound.user_gain.gain.value = $('#user_vol').val();
    });
  },

  set_patterns:function (patts) {
    $.each(patts, function (key, attrs) {
      Sound.patterns[key] = new Pattern(attrs)
    });

    var step_counts = []
    for (key in Sound.patterns) {
      step_counts = step_counts.concat(Sound.patterns[key].step_string.length);
    }
    ;
    Sound.lowest_common_multiple = Sound.LCM(step_counts);
  },

  reset_patterns:function () {
    $.get(
      '/patterns.json',
      {version:Sound.version},
      function (response) {
        $.each(response, function (key, attrs) {
          if (key == 'bpm') {
            Sound.set_bpm(attrs);
          } else if (key == 'version') {
            Sound.version = attrs;
          } else {
            pattern = Sound.patterns[key];
            pattern.step_source = attrs['steps'];
            pattern.muted = attrs['muted'];
            pattern.set_step_info();
            pattern.display();
          }
        });
      },
      'json'
    );
    return false;
  },

  get_context:function () {
    if (typeof AudioContext !== "undefined") {
      console.log('using AudioContext')
      this.context = new AudioContext();
      return true
    } else if (typeof webkitAudioContext !== "undefined") {
      console.log('using webkitAudioContext')
      this.context = new webkitAudioContext();
      return true
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

  play:function (set_to_start) {
    if (!Sound.player_active) {
      if (set_to_start) {
        Sound.step = 0;
      }
      ;
      Sound.player = setInterval(
        function () {
          Sound.play_step(Sound.step)
        },
        this.sixteenth_time
      );
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