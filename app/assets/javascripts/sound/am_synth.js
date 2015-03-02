function AMSynth(attrs) {

  Synth.apply(this, arguments);

  // Synthesis attributes in percentage
  this.am_frequency = attrs['am_frequency'] || 20;
  this.am_depth = attrs['am_depth'] || 40;
  this.am_waveshape = attrs['am_waveshape'] ||'sine';

  this.carrier = Sound.context.createOscillator();
  this.carrier.type = 'sine';
  this.carrier.start(0);

  this.modulator = Sound.context.createOscillator();
  this.modulator.start(0);
  this.modulator.type = this.am_waveshape;
  this.modulator_gain = Sound.context.createGain();
  this.modulator_gain.gain.value = 0.5;
  this.joining_gain = Sound.context.createGain();
  this.joining_gain.gain.value = 0.5;

  this.carrier.connect(this.joining_gain);
  this.modulator.connect(this.modulator_gain);
  this.modulator_gain.connect(this.joining_gain.gain);
  this.joining_gain.connect(this.envelope_gain);


  // functions used in playback
  this.set_pitch = function (midi) {
    this.pitch = midi;
    hz = 27.5 * Math.pow(2, ((midi - 21) / 12));
    this.carrier.frequency.setTargetAtTime(
      hz,
      Sound.context.currentTime,
      this.portamento
    );

    this.modulator.frequency.value = (hz * (this.am_frequency / 100));
    this.modulator_gain.gain.value = (this.am_depth / 100);
  };
  this.set_pitch(69);

  this.re_set = function(attrs) {
    this.note_on_steps = attrs['note_on_steps'];
    this.note_off_steps = attrs['note_off_steps'];
    this.pitches = attrs['pitches'];
    this.muted = attrs['muted'];
    this.set_step_info();
    this.display();
    this.set_volume(attrs['volume']);
    this.set_am_waveshape(attrs['am_waveshape']);
    this.set_am_frequency(attrs['am_frequency']);
    this.set_am_depth(attrs['am_depth']);
  };


  this.set_am_waveshape = function(waveshape) {
    this.am_waveshape = waveshape;
    this.modulator.type = waveshape;
  };

  this.set_am_frequency = function(frequency) {
    this.am_frequency = frequency;
  };

  this.set_am_depth = function(depth) {
    this.am_depth = depth;
  };


}
