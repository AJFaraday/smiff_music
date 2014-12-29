function Pattern(attrs) {
  this.sample = Sound.samples[attrs['sample']];

  this.row = this.sample.row;
  this.step_source = attrs['steps'];
  this.step_count = attrs['step_count'];
  this.muted = attrs['muted'];

  this.set_step_info = function () {
    this.step_string = this.step_source.toString(2).leftJustify(this.step_count, '0');
    this.length = this.step_string.length
  };
  this.set_step_info();


  this.play_step = function (step) {
    step = step % this.length;
    if (this.step_string[step] == '1' && !this.muted) {
      this.sample.play();
    }
  };

  this.display = function () {
    this.row.children('td.step').removeClass('active');
    this.row.children('td.step').addClass('inactive');
    if (this.muted) {
      this.row.addClass('muted');
    } else {
      this.row.removeClass('muted');
    }

    step_cells = $(this.row).children('td.step');

    var i = 0;
    for (i; i < this.length; ++i) {
      if (this.step_string[i] == '1') {
        $(step_cells[i]).removeClass('inactive');
        $(step_cells[i]).addClass('active');
      }
    }
  };


}