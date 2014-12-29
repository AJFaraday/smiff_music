require './test/test_helper'

class SystemSettingTest < ActiveSupport::TestCase

  def test_sound_init_params
    params = SystemSetting.sound_init_params
    assert_equal [:bpm], params.keys
    assert_equal SystemSetting['bpm'], params[:bpm]
  end

end
