function SubSynth(attrs) {

  Synth.apply(this, arguments);

  this.buffer_size = 2 * Sound.context.sampleRate;
  this.noise_buffer = Sound.context.createBuffer(
    1, 
    this.buffer_size, 
    Sound.context.sampleRate
  );
  this.output = this.noise_buffer.getChannelData(0);
  for (var i = 0; i < this.buffer_size; i++) {
    this.output[i] = Math.random() * 2 - 1;
  }

  this.white_noise = Sound.context.createBufferSource();
  this.white_noise.buffer = this.noise_buffer;
  this.white_noise.loop = true;
  this.white_noise.start(0);

  this.filter = Sound.context.createBiquadFilter();
  this.filter.type = 'bandpass';
  this.filter.frequency.value = 440;
  this.filter.Q.value = 1;
  this.white_noise.connect(this.filter);


  this.make_up_gain = Sound.context.createGain();
  this.make_up_gain.gain.value = 1;
  this.filter.connect(this.make_up_gain);
  this.make_up_gain.connect(this.envelope_gain);


  this.set_pitch = function(midi) {
    this.pitch = midi;
    hz = 27.5 * Math.pow(2, ((midi - 21) / 12));
    this.filter.frequency.setTargetAtTime(
      hz,
      Sound.context.currentTime,
      this.portamento
    )
  };

  this.re_set = function(attrs) {
    this.note_on_steps = attrs['note_on_steps'];
    this.note_off_steps = attrs['note_off_steps'];
    this.pitches = attrs['pitches'];
    this.muted = attrs['muted'];
    this.set_step_info();
    this.display();
    this.set_volume(attrs['volume']);
    this.set_bandwidth(attrs['bandwidth']);
  };

  // q value from 40 to 4000
  // bandwidth from 0 to 100
  // high bandwidth is low q
  // high bandwidth needs lower volume in this.make_up_gain
  this.set_bandwidth = function(bandwidth) {
    // q = (((bandwidth - 1) * -1) + 100) * 40;
    q = ((((bandwidth * -1) + 100) + 1) * 40);
    console.log('Q = ' + q);
    this.filter.Q.value = q;
    gain_val = (((bandwidth) * -1) + 120) * 8;
    this.make_up_gain.gain.value = gain_val;
    console.log('make up gain = ' + gain_val);
  };

}