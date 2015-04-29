function PolySynth(attrs) {

  Synth.apply(this, arguments);
  this.synths = {};

  // normalise gain normalises all the osc levels to 1 
  this.normalise_gain = Sound.context.createGain();
  this.normalise_gain.gain.value = 0;
  this.normalise_gain.connect(this.envelope_gain);

  this.add_synth = function(type, gain_value) {
    synth = {};
    osc = Sound.context.createOscillator();
    osc.type = type;
    osc.start(0);
    synth.osc = osc;

    gain = Sound.context.createGain();
    gain.gain.value = gain_value / 100;
    synth.gain = gain;

    osc.connect(gain);
    gain.connect(this.normalise_gain);
    this.synths[type] = synth;
  };

  this.normalise_volume = function() {
    poly = this;
    synth_gains = Object.keys(this.synths).map(function(synth_name,i){
      return poly.synths[synth_name].gain.gain.value;
    });
    gain_sum = 0;
    $.each(synth_gains,function() {gain_sum += this;});
    this.normalise_gain.gain.value = (gain_sum / synth_gains.length);
  };

  this.add_synth('sine', (attrs['sine_level'] || 100));
  this.add_synth('square', (attrs['square_level'] || 20));
  this.add_synth('sawtooth', (attrs['sawtooth_level'] || 20));
  this.add_synth('triangle', (attrs['triangle_level'] || 70));
  this.normalise_volume();

  this.set_pitch = function(midi){
    poly = this;
    hz = 27.5 * Math.pow(2, ((midi - 21) / 12));
    $.each(this.synths, function(name,synth) {
      synth.osc.frequency.setTargetAtTime(
        hz,
        Sound.context.currentTime,
        poly.portamento
      )
    });
  };

  this.set_synth_level = function(synth_name,level) {
    if(typeof(level) == 'string'){
      level = parseInt(level);
    }
    synth = this.synths[synth_name];
    synth.gain.gain.value = (level / 100);
  };

  this.re_set = function(attrs) {
    this.note_on_steps = attrs['note_on_steps'];
    this.note_off_steps = attrs['note_off_steps'];
    this.pitches = attrs['pitches'];
    this.muted = attrs['muted'];
    this.set_step_info();
    this.display();
    this.set_volume(attrs['volume']);

    this.set_synth_level('sine',attrs['sine_level']);
    this.set_synth_level('square',attrs['square_level']);
    this.set_synth_level('sawtooth',attrs['sawtooth_level']);
    this.set_synth_level('triangle',attrs['triangle_level']);
    this.normalise_volume();
  };

}
