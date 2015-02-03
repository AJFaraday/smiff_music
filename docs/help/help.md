# SMIFF music help

*Note:* This is a generated help file, do not modify this file directly.

# SMIFF Music


## What is SMIFF?

SMIFF Music is a web application by Andrew Faraday (@MarmiteJunction), exploring the use of the internet as a tool for creating music collaboratively.

SMIFF Music stands for Social Media InterFace For Music.

In the current version (version zero), SMIFF is just a drum machine, and does not have a Social Media Interface. Version zero is a proof of concept, demonstrating that music can be made within a web browser and modifed via a collection of text messages. It also demonstrates that more than one person can modify the same pattern, and everyone listening will hear the resultant changes.

This means that SMIFF is a tool for making electronic music as a social activity, but anonymously. So the resulting sound is created by and, in part, owned by everyone who uses the application.

## What does SMIFF do?

SMIFF Music consists of two main components:

* the player
* the terminal

The player holds patterns and sounds for each instrument, and when you click play (situated in the header) it plays through the sequence, looping back to the begining when it reaches the end.

Next to the play or stop button you will see a slider which acts as a volume control. 

At the end of each pattern, it checks with the database to see if someone else has changed the pattern. If it has then it will modify the pattern in the player. 

You can see the patterns currently being played in the Overview tab on SMIFFs home page.

The terminal can be found in the Terminal tab on SMIFFs home page.

You can use the terminal to change the pattern simply by typing in messages (in the white text field, below the large black area) and pressing enter. 

# Using The Terminal

_Note: if you use a unix or linux terminal, stop reading now. You know this already._

The main way to interact with SMIFF is via the terminal. This is the black area with a text field beneath it. 

Click on the text field to focus on the terminal, then you can type messages (as described under 'messages'), and either press enter or click 'Send' to send the message.

Having sent the message you can see the result of this message on the terminal.

Once you have sent one message you can press up and down to scroll through your previous messages which you can run again.

Once you have scrolled back to a previous message you can modify it before re-running it.

This behaviour is useful for building patterns, you can re-use the format of a message, but change the details.


# Available Messages

The next section contains messages you can send to SMIFF which will affect the music you hear:

## Player

There are a number of messages to modify the speed of the player.

* show speed
* set speed to 120 bpm
* speed up
* speed down



### show speed

This will tell you what speed, in beats per minute (BPM), the sequence is being played at.

<pre>
> show speed
Sequence is being played at 180 bpm
</pre>
### set speed to X

Example:

<pre>
> set speed to 140 bpm
</pre>

This will set playback to a specific speed in beats per minutes (BPM).

*Note:* The outer limits of speeds available will be set by SMIFF, but there will be a lot of freedom within this range.

### speed up

Example:

<pre>
> speed up
</pre>

This will increase the speed of playback by 5bpm
### speed down

Example:

<pre>
> speed down
</pre>

This will decrease the speed of playback by 5bpm

This can also be written as:

<pre>
> slow down
</pre>

## Drums

There are a number of drum patterns available:

* kick
* snare
* hihat
* tom1
* tom2
* tom3
* crash

For each of these you can perform one of a number of actions:

* show
* play
* do not play
* mute
* unmute
* clear


### list

Example:

<pre>
list drums
</pre>

You can find the names of all drums with this command.

The result is a lot like the list above:

<pre>
* kick
* snare
* hihat
...
</pre>
### show

Example:

<pre>
> show kick
</pre>

This will display a text representation of the contents of the kick pattern

<pre>
-----1---5---9---13--
kick-#-----#-#-----#-
</pre>

You can also show a list of patterns:

<pre>
> show hihat, snare and kick
</pre>

This will display all of the patterns specified

<pre>
------1---5---9---13--
hihat-#-#-#-#-#-#-#-##
snare-----#-------#---
kick--#-----#-#-----#-
</pre>

### play

Examples:

<pre>
> play kick on step 1
> play snare on step 5
> play hihat on steps 1 to 4
> play hihat on steps 1 to 16 skipping 1
> play snare on steps 5, 9 and 13
</pre>


Play can do one of 3 basic things:

* Add a drum hit to a certain step
* Add a drum to a range of steps
* Add a drum to specific steps

To add to a certain step:

<pre>
> play kick on step 1
</pre>

This will change the pattern so the kick is played on step 1

To add to a range of steps:

<pre>
> play hihat on steps 1 to 8
</pre>

This will change the pattern so the hihat is played on steps 1 to 8, including steps 1 and 8.

<pre>
> play hat on steps 1 to 8 skipping 1
</pre>

This will change the pattern so the hihat is played on steps 1 to 8, but after each hit there is a gap of one. So it will play the hihat on steps 1, 3 5 and 7

Example:

<pre>
> clear hihat
> play hihat on steps 1 to 8 skipping 1
> show hihat
------1---5---9---13--
hihat-#-#-#-#---------
</pre>

You can also pick out a list of numbered steps:

<pre>
> play snare on steps 5, 8 and 13
> show hihat
------1---5---9---13--
hihat-----#--#----#---
</pre>

### do not play

Examples:

<pre>
> do not play kick on beat 5
> do not play snare on beats 1 to 8
> do not play hihat on beats 1 to 16 skipping 1
> do not play hihat on steps 1, 3 and 5
</pre>

This works in exactly the same way as play, except that the result is the exact opposite. The sequence will be changed so that the sound will not be played on the steps identified.
### mute

<pre>
mute kick
mute kick and snare
mute tom1, tom2 and tom3
</pre>

This will mute a pattern, keeping it from sounding in playback.

You can still modify patterns while they are muted.
### mute all drums

<pre>
mute all drums
</pre>

This will mute all drum patterns, maintaining the pattern but preventing them from making a sound.

Not to be confused with:

<pre>
mute all
</pre>

Which will mute all patterns, not just the drums.
### unmute

<pre>
unmute kick
unmute kick and snare
unmute tom1, tom2 and tom3
</pre>

This will unmute any muted patterns, meaning they are now heard.
### unmute all drums

<pre>
unmute all drums
</pre>

This will unmute all muted drum patterns, all patterns will now sound.

Not to be confused with:

<pre>
unmute all
</pre>

Which will unmute all patterns, not just the drums.
### clear

Example:

<pre>
> clear kick
</pre>

This will clear a drum pattern. Leaving it empty.

You can also clear more than one pattern:

<pre>
clear kick and snare
clear kick, snare and hihat
</pre>

You can also clear all drums with this message:

<pre>
clear all drums
</pre>


Not to be confused with

<pre>
clear all
</pre>

Which will clear all patterns, not just the drums.
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

## list synths

Example:

<pre>
> list synths
</pre>

This shows a list of the available synths.

The result will look a little like this:

<pre>
* sine
* square
</pre>
## show

Example:

<pre>
> show sine
</pre>

This will display a text representation of the notes being played on this synth.

<pre>
> show sine
-----1---5---9---13--17--21--25--29--
C 5----------------------------------
B 4----------------------------------
A# 4---------------------------------
A 4----------------------------------
G# 4---------------------------------
G 4----------------------------------
F# 4---------------------------------
F 4----------------------------------
E 4------##--------------------------
D# 4---------------------------------
D 4----##----------------------------
C# 4---------------------------------
C 4--##------------------------------
B 3----------------------------------
A# 3---------------------------------
</pre>

Unlike drums, you can only show the contents of one synth at a time.
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



## do not play

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
