class InMemoryBase < OpenStruct

  include ActiveModel::Validations

  class << self
    attr_accessor :all
  end 

  def initialize(attrs={})
    super(attrs)
    self.class.all ||= []
    self.class.all << self
  end

  def self.first
    self.all[0]
  end 

  def self.find_by_name(name)
    self.all.select{|x|x.name == name}[0]
  end

  def self.build
    source_records_path = File.join(Rails.root, 'config','seeds',"#{self.to_s.underscore.pluralize}.yml")
    if File.exist?(source_records_path)
      seeds = YAML.load_file(source_records_path)
      seeds.each do |label,attributes|
        self.new(attributes)
      end
      puts "Initialised #{self.all.count} #{self} objects"
    end
  rescue => er
    puts er.class
    puts er.message
    puts er.backtrace.join("\n")
  end

end
