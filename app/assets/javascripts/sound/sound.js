var Sound = {

  context:null,
  samples:{},

  init:function () {
    // set up context and gain chain
    this.get_context();
    this.master_gain = this.context.createGainNode();
    this.master_gain.value = 0.5;
    this.master_gain.connect(this.context.destination);

    // load samples
    sample_names = ['kick', 'snare'];
    sample_names.forEach(function (sample_name) {
      Sound.samples[sample_name] = new Sample(sample_name);
      Sound.samples[sample_name].load_sample();
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
  }

}