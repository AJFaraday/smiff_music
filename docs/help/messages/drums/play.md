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
