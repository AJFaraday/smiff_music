var Sound = {

  context:null,
  samples:{},
  patterns:{},
  sixteenth_time: 150,
  step: 0,

  init:function (attributes) {
    // set up context and gain chain
    this.get_context();
    this.master_gain = this.context.createGainNode();
    this.master_gain.value = 0.5;
    this.master_gain.connect(this.context.destination);

    // load samples
    attributes['sample_names'].forEach(function (sample_name) {
      Sound.samples[sample_name] = new Sample(sample_name);
      Sound.samples[sample_name].load_sample();
    });
    this.set_patterns(attributes['patterns']);
  },

  set_patterns:function (patts) {
    $.each(patts, function (key, attrs) {
      Sound.patterns[key] = new Pattern(attrs)
    });
  },

  reset_patterns:function () {
    $.get(
      '/patterns',
      {},
      function (response) {
        $.each(response, function (key, attrs) {
          pattern = Sound.patterns[key];
          pattern.steps = attrs['steps'];
          pattern.display();
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
    this.step += 1
  },

  play: function() {
    setInterval(
      function() {Sound.play_step(Sound.step) },
      this.sixteenth_time
    )
  }



}