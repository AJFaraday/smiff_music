module InMemory
  
  def build
    MessageFormat.build
    Sample.build
    Pattern.build
    Synth.build
    SystemSetting.build
  end

  module_function :build

end