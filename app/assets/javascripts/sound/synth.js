function Synth(attrs) {

  this.attack_time = attrs['attack_time'] || 0.05;
  this.decay_time = attrs['decay_time'] || 0.05;
  this.sustain_level = attrs['sustain_level'] || 0.3;
  this.release_time = attrs['release_time'] || 0.5;

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

  this.set_pitch = function (midi) {
    hz = 27.5 * Math.pow(2, ((midi - 21) / 12));
    this.oscillator.frequency.value = hz;
  };

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


