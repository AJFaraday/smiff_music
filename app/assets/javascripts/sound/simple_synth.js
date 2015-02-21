function SimpleSynth(attrs) {

  Synth.apply(this, arguments);

  this.oscillator = Sound.context.createOscillator();
  this.oscillator.type = attrs['waveshape'] || 'sine';
  this.oscillator.connect(this.envelope_gain);
  this.oscillator.start(0);


  // functions used in playback
  this.set_pitch = function (midi) {
    this.pitch = midi;
    hz = 27.5 * Math.pow(2, ((midi - 21) / 12));
    this.oscillator.frequency.setTargetAtTime(
      hz,
      Sound.context.currentTime,
      this.portamento
    );
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
    this.set_waveshape(attrs['waveshape']);
  };

  this.set_waveshape = function(waveshape) {
    this.oscillator.type = waveshape;
  };

}