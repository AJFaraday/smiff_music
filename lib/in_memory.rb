module InMemory
  
  def build
    MessageFormat.build
    Sample.build
    Pattern.build
    Synth.build
    SystemSetting.build
  end

  def rebuild
    MessageFormat.rebuild
    Sample.rebuild
    Pattern.rebuild
    Synth.rebuild
    SystemSetting.rebuild
  end

  module_function :build
  module_function :rebuild

end