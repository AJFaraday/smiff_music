require './test/test_helper'

class SampleTest < ActiveSupport::TestCase

  def setup
    Sample.rebuild
  end

  def test_sound_init_params
    assert_equal(
      Sample.all.collect{|sample|sample.name},
      Sample.sound_init_params[:sample_names]
    )
  end

end
