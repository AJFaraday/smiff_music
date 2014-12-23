# Message help

*Please note:* This is currently a speculative document, and is subject to future change.

## Drums

There are a number of drum patterns available:

* kick
* snare

For each of these you can perform one of a number of actions:

* show
* clear
* play
* do not play

### show

Example:

```
> show kick
```

This will display a text representation of the contents of 

```
-----1---5---9---13--     
kick-#-----#-#-----#-
```
You can show up to 4 drum patterns at once

```
> show hihat, snare and kick
```

```
------1---5---9---13-- 
hihat-#-#-#-#-#-#-#-##
snare-----#-------#---
kick--#-----#-#-----#-
```

### clear

Example:

```
> clear kick
```

This will clear a drum pattern. Leaving it empty.

### play

Examples:

```
> play kick on step 1
> play snare on step 5
> play hihat on steps 1 to 4
> play hihat on steps 1 to 16 skipping 1
```


Play can do one of 2 basic things:

* Add a drum hit to a certain step
* Add a drum to a range of steps

To add to a certain step:

```
> play kick on step 1
```

This will change the pattern so the kick is played on step 1

To add to a range of steps:

```
> play hihat on steps 1 to 8
```

This will change the pattern so the hihat is played on steps 1 to 8, including steps 1 and 8.

```
> play hat on steps 1 to 8 skipping 1
```

This will change the pattern so the hihat is played on steps 1 to 8, but after each hit there is a gap of one. So it will play the hihat on steps 1, 3 5 and 7

Example:

```
> clear hihat
> play hat on steps 1 to 8 skipping 1
> show hihat
------1---5---9---13--
hihat-#-#-#-#---------
```

### do not play

Examples:

```
> do not play kick on beat 5
> do not play snare on beats 1 to 8
> do not play hihat on beats 1 to 16 skipping 1
```

This works in exactly the same way as play, except that the sequence will be changed so that the notes specified will not be played on the steps identified.

## Player

There are a number of messages to modify the speed of the player.

* show speed
* speed up
* speed down
* speed to 120 bpm

### show speed

This will tell you what speed, in beats per minute (BPM), the sequence is being played at.

```
> show speed
Sequence is being played at 180 bpm
```

### speed to X

Example:

```
> speed to 140 bpm
```

This will set playback to a specific speed in beats per minutes (BPM).

*Note:* The outer limits of speeds available will be set by SMIFF, but there will be a lot of freedom within this range.

### speed up

Example:

```
> speed up
```

This will increase the speed of playback by 5bpm

### speed down 

Example:

```
> speed down
```

This will decrease the speed of playback by 5bpm
