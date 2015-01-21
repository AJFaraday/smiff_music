# Synths

_Note:_ this is speculative, no messages are set just yet.

Synth is short for synthesiser, a device which produces a sound from it's component parts.

In the context of SMIFF a synthesiser will play a note at a specific pitch, which starts at a given step and runs for a given amount of time.

SMIFF's synthesizers are monophonic, they will only play one note at any given time.

There are four things we neet to know to add a note to a synth in SMIFF:

* the name of the synth (e.g.: sine)
* pitch - made up of the note name and octave (e.g.: A 4)
* starting step (e.g.: 5)
* length (e.g.: 4)

## add note

Options:

Complete message style:
<pre>
> play C# 4 on step 5 on sine for 2 steps
> play C# 4, D 2, E 2 on step 5 on sine for 2 steps each
</pre>

pre-settings style:
<pre>
> set synth to sine
Any new notes will be added to 'sine' synthesiser
> set note length to 2 steps
Any new notes will be 2 steps long

> play C# 4 on step 5
> play C 4, D 4, E 4, F 4, G 4, G4, G4 from step 1
<pre>


