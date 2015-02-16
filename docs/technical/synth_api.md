Synth API
---------

Versions 0.2 onwards involve synthesisers which work by various algorithms and methods.

This is a *minimum* API which outlines functions which every type of synthesiser.

Expected attributes:

These are attributes every synth will have, the internals will probably be different

* name
* muted (boolean)
* portamento (amount of time (in seconds) to change pitch, usually very low)
(pattern)
* note_on_steps (integer, bit mask of note on pattern)
* note_off_steps (integer, bit mask of note off pattern)
* step_count (integer, number of steps)
* pitches (array of integers, changes of pitch, midi note values)
(volume envelope)
* attack_time (seconds)
* decay_time (seconds)
* sustain_level (relative volume, from 0 to 1)
* release_time (seconds)

Expected methods:

These are methods all synths are expected to respond to, which make the API used by the player and for updating the synth.

After some discussion this may be best implemented as a prototype.

  set_step_info()

This method takes the note_on_steps and note_off_steps and converts them into a usable string of binary.

  attack()

Carry out the attack and decay part of the volume envelope.
(start the note)

  release()

Carry out the release part of the volume envelope.
(end the note)

  set_pitch(midi)

This accepts the midi note as an argument, translates to frequency and sets the pitch of the synth.

  play_step(step)

This accepts a step in the synths pattern and carries out the actions in that step:

* if the note_on pattern includes that step, it calls attack()
* if the note_off pattern includes that step, it calls release()
* if the pitches array has a value on that index it calls set_pitch()

  pitch_at_step(step)

Used in drawing diagrams, this is the most recent change of pitch at a given step.

  display()

This makes all expected changes to the UI based on the patterns of the synth.

Synth types
-----------

*Simple:*

Simple synths have one oscillator with a given wave shape:

  new Synth({
    constructor: 'SimpleSynth',
    osc_type: 'sine',
    attack_time: 0.1,
    decay_time: 0.2,
    sustain_level: 0.5,
    release_time: 0.5,
    muted: false,
    note_on_steps: 0,
    note_off_steps: 0,
    step_count: 32,
    pitches: [],
    name: 'sine'
  })

*Frequency Modulation*

FM syths implement a frequency modulation algorithm

In addition to the attributes required by all synths, FM will need to know:

* fm_frequency (as a proportion of the pitch, how fast will the modulation be, percentage)
* fm_depth (as a proportion of the pitch, how much the frequency will change, percentage)
* fm_wave_shape (a waveshape, sine, square, triangle, saw etc.)

  new FmSynth({
    constructor: 'FMSynth',
    fm_frequency: 40,
    fm_depth: 20,
    fm_wave_shape: 'sine'
    ...
  })
