
# generate drum patterns (simple 32-step form)
%w(kick snare hihat crash tom1 tom2 tom3).each do |drum|
  Pattern.create(
    name: drum,
    step_size: 16,
    step_count: 32,
    instrument_name: drum,
    active: true,
    purpose: 'event'
  )
end

sample_names = Pattern.where(purpose: 'event').collect{|x|x.instrument_name}
sample_names.each do |sample|
  Sample.create(name: sample)
end



Messages::FormatBuilder.new.build_messages

Synth.build_seeds