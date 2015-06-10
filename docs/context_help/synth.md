'{name}' is a {type} synthesiser, you can get more detailed information with:
* describe {name}

To add notes you first have to set it as your current synth:
* set synth to {name}

You can set the length of any notes you add like this:
* set note length to 2

Then you can change add notes like this:
* play {min_note} on step 1
* play {min_note}, {max_note} from step 9
* play {min_note}, {max_note}, {min_note} from step 17 skipping 1

You can remove them like this:
* do not play {max_note} on {name}
* do not play {min_note} to {max_note} on {name}
* do not play {name} on step 1
* do not play {name} on steps 1 to 17
* clear {name}

You can mute or unmute it with:
* mute {name}
* unmute {name}

You can find the parameters of {name} with:
* list parameters for {name}

And set them with:
* set {name} volume to 60