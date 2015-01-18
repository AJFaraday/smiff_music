class Synth < ActiveRecord::Base


  validate :name, presence: true
  validate :osc_type,
           presence: true,
           inclusion: %w{sine square saw triangle}
  validate :attack_time, numericality: {greater_than: 0, less_than: 2}
  validate :decay_time, numericality: {greater_than: 0, less_than: 2}
  validate :sustain_level, numericality: {greater_than: 0, less_than: 1}
  validate :release_time, numericality: {greater_than: 0, less_than: 5}

  after_create :generate_patterns

  serialize :pitches

  has_many :patterns do

    def note_on
      where(purpose: 'note_on').first
    end

    def note_off
      where(purpose: 'note_off').first
    end

  end

  def pitches
    super || self.pitches = Array.new(self.step_count || 0)
  end

  def pitch_at_step(step)
    pitches[0..step].compact.last
  end

  def active_at_step(step)
    note_on = patterns.note_on.pattern_bits
    note_off = patterns.note_off.pattern_bits
    active = nil
    until active != nil do
      if note_on[step]
        active = true
      elsif note_off[step]
        active = false
      end
      step -= 1
    end
    active
  end

  after_save :modify_pattern_store

  def modify_pattern_store
    PatternStore.modify_hash(self)
  end

  def Synth.build_seeds
    definitions = YAML.load_file(File.join(Rails.root, 'db', 'seed', 'synths.yml'))
    definitions.each do |name, params|
      if Synth.where(name: name).any?
        Synth.where(name: name).first.update_attributes(params)
      else
        Synth.create!(params)
      end
    end
  end

  def generate_patterns
    unless self.patterns.note_on
      self.patterns.create!(
        muted: false,
        active:  true,
        purpose: 'note_on',
        name: "#{self.name}_note_on",
        step_count: step_count,
        step_size: step_size
      )
    end
    unless self.patterns.note_off
      self.patterns.create!(
        muted: false,
        active: true,
        purpose: 'note_off',
        name: "#{self.name}_note_off",
        step_count: step_count,
        step_size: step_size
      )
    end
  end


  def Synth.sound_init_params
    hash = {:synths => {}}
    all.each do |synth|
      hash[:synths][synth.name] = synth.sound_init_params
    end
    hash
  end

  def sound_init_params
    {
      osc_type: osc_type,
      attack_time: attack_time,
      decay_time: decay_time,
      sustain_level: sustain_level,
      release_time: release_time,
      muted: muted,
      note_on_steps: patterns.note_on.bits,
      note_off_steps: patterns.note_off.bits,
      step_count: step_count,
      pitches: pitches
    }
  end

  def Synth.to_hash
    result = {}
    all.each do |synth|
      result[synth.name] = synth.to_hash
    end
    result
  end

  def to_hash
    {
      muted: muted,
      note_on_steps: patterns.note_on.bits,
      note_off_steps: patterns.note_off.bits,
      pitches: pitches
    }
  end

  attr_accessor :chart_data

  def chart_data
    return @chart_data if @chart_data
    @chart_data = []
    envelope_times = [
      (attack_time * 1000).to_i,
      (decay_time * 1000).to_i,
      (release_time * 1000).to_i
    ]
    gcd = envelope_times.reduce(:gcd)

    @chart_data << 0
    (((attack_time * 1000) / gcd) - 1).to_i.times{@chart_data << nil}
    @chart_data << 1
    (((decay_time * 1000) / gcd) - 1).to_i.times{@chart_data << nil}
    @chart_data << sustain_level
    (((attack_time * 1000) + (decay_time * 1000)) / gcd).to_i.times{@chart_data << nil}
    @chart_data << sustain_level
    (((release_time * 1000) / gcd) - 1).to_i.times{@chart_data << nil}
    @chart_data << 0
    @chart_data
  end

  # This uses chart_data above to generate full params for the chart plugin
  def chart_data_full
    {
      labels: Array.new(chart_data.length, ''),
      datasets: [
      {
        fillColor: "rgba(220,220,220,0.2)",
        strokeColor: "rgba(220,220,220,1)",
        data: chart_data
      }
    ]
  }
  end

end
