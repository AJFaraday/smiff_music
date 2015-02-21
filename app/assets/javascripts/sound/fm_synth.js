function FMSynth(attrs) {

  Synth.apply(this, arguments);

  // Synthesis attributes in percentage
  this.fm_frequency = attrs['fm_frequency'] || 20;
  this.fm_depth = attrs['fm_depth'] || 40;
  this.fm_wave_shape = attrs['fm_waveshape'] ||'sine';

  this.carrier = Sound.context.createOscillator();
  this.carrier.type = 'sine';
  this.carrier.connect(this.envelope_gain);
  this.carrier.start(0);

  this.modulator = Sound.context.createOscillator();
  this.modulator.start(0);
  this.modulator.type = this.fm_wave_shape;
  this.modulator_gain = Sound.context.createGain();

  this.modulator.connect(this.modulator_gain);
  this.modulator_gain.connect(this.carrier.frequency);


  // functions used in playback
  this.set_pitch = function (midi) {
    this.pitch = midi;
    hz = 27.5 * Math.pow(2, ((midi - 21) / 12));
    this.carrier.frequency.setTargetAtTime(
      hz,
      Sound.context.currentTime,
      this.portamento
    );

    this.modulator.frequency.value = (hz * (this.fm_frequency / 100));
    this.modulator_gain.gain.value = (hz * (this.fm_depth / 100));
  };
  this.set_pitch(69);

  this.re_set = function(attrs) {
    this.note_on_steps = attrs['note_on_steps'];
    this.note_off_steps = attrs['note_off_steps'];
    this.pitches = attrs['pitches'];
    this.muted = attrs['muted'];
    this.set_step_info();
    this.display();
    // todo handle parameters
    this.set_volume(attrs['volume']);
    this.set_fm_waveshape(attrs['fm_waveshape']);
    this.set_fm_frequency(attrs['fm_frequency']);
    this.set_fm_depth(attrs['fm_depth']);
  };


  this.set_fm_waveshape = function(waveshape) {
    this.modulator.type = waveshape;
  };

  this.set_fm_frequency = function(frequency) {
    this.fm_frequency = frequency;
  };

  this.set_fm_depth = function(depth) {
    this.fm_depth = depth;
  }


}
