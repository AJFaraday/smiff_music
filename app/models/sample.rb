class Sample < InMemoryBase

  def Sample.sound_init_params
    {
      sample_names: Sample.all.collect{|sample|sample.name}
    }
  end

end
