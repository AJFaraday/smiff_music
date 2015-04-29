# Quick-start Guide

So, there`s a lot more help pages to get through if you want to know everything you can do with SMIFF, but what if you just want to wade right in, and work it out for yourself.

First, go back to home, and click the terminal page.

Press the play icon in the top left corner of the page.

Then, type these commands in, line by line, presing enter after each line. After each command, listen to the result.

<pre>
> play kick on step 1
> play snare on step 5
> play hihat on steps 17 to 21
> do not play hihat on steps 18 to 20
> play kick on steps 9 to 32 skipping 3
> play crash on steps 1 to 32
> clear crash
</pre>

So, if everything worked, you will be hearing a nice steady beat, and a little shock from the crash. Now let`s get funky with the tom toms:

<pre>
> play tom1 on steps 1 to 16 skipping 2
> play tom2 on steps 1 to 32 skipping 4
</pre>

That`s a lot to type, huh? There`s a special feature of the SMIFF terminal. If you press up you can scroll through your previous commands and modify them before sending them again. Try this as we add more tom toms.

<pre>
> play tom2 on steps 1 to 32 skipping 5
> play tom3 on steps 1 to 32 skipping 6
> play tom3 on steps 1 to 32 skipping 2
</pre>

Okay, we`ve got some pretty cool sounds going on, so perhaps we just want to hear the toms and not the snare?

<pre>
> mute kick, snare and hihat
</pre>

But we can still change these patterns while we`re not listening to them:

<pre>
> play kick on steps 1 to 32 skipping 3
> play snare on steps 5 to 32 skipping 7
> play hihat on steps 1 to 32 
> do not play hihat on steps 1 to 32 skipping 2
> unmute all drums
</pre>

So, how about some tunes to go with it? Here`s some building blocks, I`ll leave you to explore from now on. The help page contains more detailed information on each command and instrument.

<pre>
> set note length to 2
> set synth to anne
> play c5 on step 1
> play c5 on step 7
> set synth to sarah
> play c6, d6, e6, f6, g6 from step 17
> play c6, d6, e6, f6, g6 from step 17 skipping 2 
> set synth to brain
> play c3, c3, g3, c3 from step 1 skipping 1
> play c4, c4, g4, c4 from step 17 skipping 1
</pre>

Now, go play :)
