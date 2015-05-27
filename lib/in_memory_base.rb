class InMemoryBase < OpenStruct

  include ActiveModel::Validations

  class << self
    attr_accessor :all
  end

  def save
    self.modify_pattern_store if self.respond_to?(:modify_pattern_store)
  end

  alias save! save

  def self.create(args)
    obj = self.new(args)
    obj.save
    obj
  end

  class << self
    alias create! create
  end

  def initialize(attrs={})
    super(attrs)
    self.class.all ||= []
    self.class.all << self
  end

  def self.first
    self.all[0]
  end

  def self.last
    self.all[-1]
  end

  def self.find_by_name(name)
    self.all.select { |x| x.name == name }[0]
  end

  def update_attribute(attribute, value)
    self.send("#{attribute}=", value)
    save
  end

  def update_attributes(attrs={})
    attrs.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    save
  end

  def self.build
    source_records_path = File.join(Rails.root, 'config', 'seeds', "#{self.to_s.underscore.pluralize}.yml")
    if File.exist?(source_records_path)
      seeds = YAML.load_file(source_records_path)
      seeds.each do |label, attributes|
        self.new(attributes)
      end
      puts "Initialised #{self.all.count} #{self} objects"
    end
  rescue => er
    puts er.class
    puts er.message
    puts er.backtrace.join("\n")
  end

  def self.rebuild
    self.all = []
    self.build
  end

  def self.where(conditions={})
    unless conditions.is_a?(Hash)
      throw "InMemoryBase.where can only accept hash conditions"
    end
    candidates = Array.new(self.all)
    conditions.each do |attribute, value|
      if value.is_a?(Array)
        candidates.reject! { |candidate| !value.include?(candidate.send(attribute)) }
      else
        candidates.reject! { |candidate| candidate.send(attribute) != value }
      end

    end
    candidates
  end


end
