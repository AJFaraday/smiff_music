
Pattern.create(
  name: 'kick',
  step_size: 16,
  step_count: 16,
  instrument_name: 'kick',
  active: true
)

Pattern.create(
  name: 'snare',
  step_size: 16,
  step_count: 16,
  instrument_name: 'snare',
  active: true
)



sample_names = Pattern.all.collect{|x|x.instrument_name}
sample_names.each do |sample|
  Sample.create(name: sample)
end
