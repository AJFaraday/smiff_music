## play

In order to play notes, SMIFF needs to know which instrument they will be played on and how long each note should be.

They have default values, but you can change them yourself like this.

<pre>
> set synth to sine
Any new notes will be added to 'sine' synthesiser
> set note length to 2 steps
Any new notes will be 2 steps long
</pre>

You tell it the pitch of a note with two parts:

* A note name, which is a letter which can be sharpened with the hash (#) symbol
* The octave number

The note name will be C, C#, D, D#, E, F, F#, G, G#, A, A# or B.

<pre>
> play C# 4 on step 5
> play C 4, D 4, E 4, F 4, G 4, G 4, G 4 from step 1
> play C 4, D 4, E 4, F 4, G 4, G 4, G 4 from step 1 skipping 4
</pre>

The last message form plays a melody of notes of your given length, but will leave a gap of 4 after each note.


