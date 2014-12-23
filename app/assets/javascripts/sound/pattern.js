function Pattern(attrs) {
  this.sample = Sound.samples[attrs['sample']];
  this.row = this.sample.row;
  this.steps = attrs['steps'];

  this.play_step = function (step) {
    step = step % this.steps.length;
    if (this.steps[step]) {
      this.sample.play();
    }
  }

  this.display = function () {
    $(this.row).children('td.step').removeClass('active');
    $(this.row).children('td.step').addClass('inactive');

    step_cells = $(this.row).children('td.step');
    var i = 0;
    for (i; i < this.steps.length; ++i) {
      if (this.steps[i] != null && this.steps[i] != false) {
        $(step_cells[i]).removeClass('inactive');
        $(step_cells[i]).addClass('active');
      }
    }
  }

}