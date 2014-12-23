function Sample(name) {
  this.name = name;
  this.url = '/audio/' + name + '.wav';
  this.audio = null;

  // run on initialise, gets audio from server
  this.load_sample = function () {
    sample = this;
    console.log('loading: ' + sample.name);
    if (Sound.has_context()) {
      request = new XMLHttpRequest();
      request.sample_name = sample.name
      request.open("GET", this.url, true);
      request.responseType = "arraybuffer";

      // Our asynchronous callback
      request.onload = function () {
        sample = Sound.samples[this.sample_name];
        console.log('loaded: ' + sample.name)
        var audio_data = this.response;
        sample.audio = Sound.context.createBuffer(audio_data, true);
      };
      request.send();
    } else {
      throw new Error('Sound is not yet initialised on this page');
    }
  }

  this.play = function () {
    if (this.audio != null) {
      var source = Sound.context.createBufferSource();
      source.buffer = this.audio;
      source.connect(Sound.master_gain);
      source.start(0);
    } else {
      throw new Error('Sound is not loaded')
    }
  }

}