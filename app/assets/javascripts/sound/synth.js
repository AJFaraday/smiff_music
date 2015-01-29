function Synth(attrs) {

  this.name = attrs['name'];
  this.muted = attrs['muted'];

  // setup two pattern attributes
  this.note_on_steps = attrs['note_on_steps'] || 0
  this.note_off_steps = attrs['note_off_steps'] || 0
  this.step_count = attrs['step_count'] || 16
  this.pitches = attrs['pitches'] || [0,0,0,0,0,0,0,0];
  this.pitch = 69;
  this.portamento = 0.001;

  // setup envelope params
  this.attack_time = attrs['attack_time'] || 0.05;
  this.decay_time = attrs['decay_time'] || 0.05;
  this.sustain_level = attrs['sustain_level'] || 0.3;
  this.release_time = attrs['release_time'] || 0.5;

  // setup web audio stuff
  this.oscillator = Sound.context.createOscillator();
  this.master_gain = Sound.context.createGain();
  this.master_gain.gain.value = ((this.sustain_level * -1) + 1) * 0.8;
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
      };
    } else if (this.note_off_at_step(step)) {
      this.release();
    };
    // for some reason both null and undefined equal undefined
    if (this.pitches[step] != undefined ) {
      this.set_pitch(this.pitches[step]);
    };
  };

  this.note_on_at_step = function(step) {
    return this.note_on_step_string[step] == '1';
  };

  this.note_off_at_step = function(step) {
    return this.note_off_step_string[step] == '1';
  };

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
      0,
      // adding 100ms seems to help avoid the envelope action being missed.
      (Sound.context.currentTime + 0.1),
      this.release_time
    );
  };

  this.pitch_at_step = function(step) {
    pitch_slice = this.pitches.slice(0,(step + 1))
    pitch_slice = pitch_slice.filter(function(n){ return n != null });
    return pitch_slice.pop();
  };

  this.display = function() {
    this.set_diagram('tbody#synth_'+this.name+'_overview');
    this.set_diagram('tbody#synth_'+this.name+'_table');
  };

  this.set_diagram = function(tbody_id) {
    this.clear_diagram(tbody_id);
    diagram = $(tbody_id);
    synth = this;
    $.each(diagram.children(), function(index,row) {
      synth.set_row(row);
    });
  };

  this.clear_diagram = function(tbody_id) {
    cells = $(''+tbody_id+' tr td');
    cells.removeClass('note_start');
    cells.removeClass('note_continues');
    cells.removeClass('note_end');
    cells.removeClass('inactive');
  };

  this.set_row = function(row) {
    row = $(row);
    synth = this;
    active = false;
    $.each(row.children('td'), function(index,cell) {
      cell = $(cell);
      pitch = cell.data('pitch');
      step = cell.data('step');

      if(synth.pitch_at_step(step) == pitch) {
        if(synth.note_on_at_step(step)) {
          cell.addClass('note_start');
          if (!synth.note_off_at_step(step)) {active = true};
        } else if (synth.note_off_at_step(step) && active) {
          cell.addClass('note_end');
          active = false;
        } else if (active) {
          cell.addClass('note_continues');
        } else {
          cell.addClass('inactive');
        };
      } else {
        cell.addClass('inactive');
      };

    });
  };


}


