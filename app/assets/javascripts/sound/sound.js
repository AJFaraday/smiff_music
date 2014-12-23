var Sound = {

  context:null,
  samples:{},
  patterns: {},

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

  set_patterns: function(patts) {
    $.each(patts, function (key, attrs) {
      Sound.patterns[key] = new Pattern(attrs)
    });
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

  play_step: function(step) {
    $.each(this.patterns, function(name,pattern) {
      pattern.play_step(step)
    });
  }

}