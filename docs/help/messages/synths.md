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

<pre>
> set synth to sine
Any new notes will be added to 'sine' synthesiser
> set note length to 2 steps
Any new notes will be 2 steps long

> play C# 4 on step 5
> play C 4, D 4, E 4, F 4, G 4, G4, G4 from step 1
</pre>

## Remove note(s)

After adding one or more notes to a synth they can then be removed.

<pre>
> do not play sine on step 1
> do not play sine on steps 1, 7 and 14
</pre>

These messages will remove whichever note is playing at any of the steps mentioned.

<pre>
> do not play sine on steps 1 to 16
</pre>

This will stop the synth mentioned from playing within the range.

<pre>
> do not play sine on steps 1 to 8 skipping 1
</pre>

This will change the pattern so the synth is is cleared on steps 1 to 8, but there is a gap of one. So it will clear the sine pattern on steps 1, 3 5 and 7

<pre>
> do not play C# 4 on sine
> do not play C 4, D 4, E4 on sine
> do not play C 4 to G 4 on sine
</pre>



## mute

<pre>
mute sine
mute sine, square and triangle
</pre>

This will mute a synth, keeping it from sounding in playback.

You can still modify melodies while they are muted.

## mute all synths

<pre>
mute all synths
</pre>

This will mute all synth patterns, maintaining the pattern but preventing them from making a sound.

Not to be confused with:

<pre>
mute all
</pre>

Which will mute all patterns, not just the synths.

## unmute

<pre>
unmute sine
unmute sine, square and triangle
</pre>

This will unmute a synth, meaning it will now be heard.

### unmute all synths

<pre>
unmute all drums
</pre>

This will unmute all muted synth patterns, all patterns will now sound.

Not to be confused with:

<pre>
unmute all
</pre>

Which will unmute all patterns, not just the synths.

### clear

Example:

<pre>
> clear sine
</pre>

This will clear a sine pattern. Leaving it empty.

You can also clear more than one pattern:

<pre>
clear sine and square
</pre>

You can also clear all synths with this message:

<pre>
clear all synths
</pre>

Not to be confused with

<pre>
clear all
</pre>

Which will clear all patterns, not just the synths.
