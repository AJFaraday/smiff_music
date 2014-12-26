class SystemSetting < ActiveRecord::Base

  acts_as_settings

  def SystemSetting.sound_init_params
    {
      bpm: SystemSetting['bpm']
    }
  end

end
