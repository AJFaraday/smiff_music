Future Development Roadmap
--------------------------

Versions
--------

Versions are comprised of two parts:

* Major - a 'release' version of the application, this should be the long-term stable version used on production sites.
* Minor - a step release, starting to develop features for the next major version.

These are formatted as major.minor (e.g. 0.1)

This should be reflected in the branch name, e.g.:

* version_zero
* version_0_1
* version_0_2

etc.

This file contains versions of SMIFF both built and planned, and their intended contents. 

Version 0
---------

Features:

* A drum machine (pattern storage and playback)
* Terminal interface
* Help file displayed on website
* Full test suite
* Some technical docs to aid future dev

This was (officially) finished on January 5th 2015, any work on version zero after this date must be on the above features or bug fixes with the current version zero.


Version 0.1
-----------

0.1 has to focus on solving melodic lines. Monophonic.

Features:

* At least one melodic synthesizer (audio)
* Pitch, note_on, note_off pattern storage and transfer
* Separating melodic and drum patterns
* Displaying melodic lines alongside drums (overview) 
* Some messages for melody
* Help pages for melodic patterns
* Test new code 

End point: I can write a melody from terminal commands and hear it with the drum patterns

Version 0.2
-----------

0.2 will focus on modifying synthesis parameters.

* An FM synthesiser with a few changeable parameters
** Volume
** Modulation frequency
** Modulation depth 
* Messages for setting synthesis parameters
* Displaying synthesiser with pattern and synth params
* Help page which oulines synth and parameters
* Help page for changing synthesis parameters
* Test new code
* JS unit tests checking synth params change

End point: I can modify the parameters of a synthesiser which changes the sound whilst it plays.

Version 0.3
-----------

0.3 will focus on a wider variety of synths 

* Some more synths
** AM
** Additive
** Subtractive
** Wave shaping (change oscillator wave shape)
* Help patch for each synth

End point: There is an interesting selection of synths which can be modified via the terminal. 

Version 1
---------

* Melodic (monophonic) parts are now included in system playback
* Synthesis algorithms are user changeable
* Changes from every client change sound on every client
* Pattern and synth changes from server are as efficient as possible
* Everything is documented and as understandable as possible
* Tests to cover everything

End point: I can deploy this to a production server and people do not tweet me becaus the error message told them to. 

(in other words, users do not see error messages)







