## do not play

Examples:

<pre>
> do not play sine on step 1
> do not play sine on steps 1, 7 and 14
</pre>

After adding one or more notes to a synth they can then be removed.

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