
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

sample_names = %w(kick snare)
sample_names.each do |sample|
  Sample.create(name: sample)
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
