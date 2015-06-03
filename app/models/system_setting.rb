class SystemSetting < InMemoryBase

  def SystemSetting.[](name)
    SystemSetting.find_by_name(name).value
  end

  def SystemSetting.[]=(name,value)
    SystemSetting.find_by_name(name).value=value
  end

  def SystemSetting.sound_init_params
    {
      bpm: SystemSetting['bpm']
    }
  end

end
