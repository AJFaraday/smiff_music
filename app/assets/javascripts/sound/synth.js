function Synth(attrs) {

  // setup two pattern attributes
  this.note_on_steps = attrs['note_on_steps'] || 0
  this.note_off_steps = attrs['note_off_steps'] || 0
  this.step_count = attrs['step_count'] || 16
  this.pitches = attrs['pitches'] || [0,0,0,0,0,0,0,0];
  this.pitch = 69;
  this.portamento = 0.005;

  // setup envelope params
  this.attack_time = attrs['attack_time'] || 0.05;
  this.decay_time = attrs['decay_time'] || 0.05;
  this.sustain_level = attrs['sustain_level'] || 0.3;
  this.release_time = attrs['release_time'] || 0.5;

  // setup web audio stuff
  this.oscillator = Sound.context.createOscillator();
  this.master_gain = Sound.context.createGain();
  this.master_gain.gain.value = 0.6;
  this.envelope_gain = Sound.context.createGain();
  this.envelope_gain.gain.value = 0;
  this.oscillator.type = attrs['osc_type'] || 'sine';
  this.oscillator.connect(this.envelope_gain);
  this.envelope_gain.connect(this.master_gain);
  this.master_gain.connect(Sound.master_gain);
  this.oscillator.start(0);

  this.set_step_info = function() {
    this.note_on_step_string = this.note_on_steps.toString(2).leftJustify(this.step_count, '0');
    this.note_off_step_string = this.note_off_steps.toString(2).leftJustify(this.step_count, '0');
    this.length = this.note_on_step_string.length
  };
  this.set_step_info();

  // actual playback function
  this.play_step = function(step) {
    step = step % this.length;
    if (this.note_on_at_step(step) && !this.muted) {
      this.attack();
      if (this.note_off_at_step(step)) {
        setTimeout(
          this.release(),
          ((this.attack_time + this.decay_time) * 1000)
        );
      }
    } else if (this.note_on_at_step(step) == '1') {
      this.release();
      // for some readson both null and undefined equal undefined
    };
    if (this.pitches[step] != undefined ) {
      this.set_pitch(this.pitches[step]);
    };
  };

  this.note_on_at_step = function(step) {
    (this.note_on_step_string[step] == '1');
  };

  this.note_off_at_step = function(step) {
    (this.note_off_step_string[step] == '1');
  }

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

  this.attack = function () {
    // up to 1 in attack time
    this.envelope_gain.gain.setTargetAtTime(
      1,
      Sound.context.currentTime,
      this.attack_time
    );
    // after attack time, take decay to get to sustain level
    this.envelope_gain.gain.setTargetAtTime(
      this.sustain_level,
      (Sound.context.currentTime + this.attack_time),
      this.decay_time
    );
  };

  this.release = function () {
    this.envelope_gain.gain.setTargetAtTime(
      0, Sound.context.currentTime, this.release_time
    );
  };

}


