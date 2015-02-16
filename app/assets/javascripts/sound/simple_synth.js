function SimpleSynth(attrs) {

  Synth.apply(this, arguments);

  this.oscillator = Sound.context.createOscillator();
  this.oscillator.type = attrs['osc_type'] || 'sine';
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



}