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

}