# generate drum patterns (simple 32-step form)
%w(kick snare hihat crash tom1 tom2 tom3).each do |drum|
  unless Pattern.find_by_name(drum)
    Pattern.create(
      name: drum,
      step_size: 16,
      step_count: 32,
      instrument_name: drum,
      active: true,
      purpose: 'event'
    )
  end
end

Synth.build_seeds
