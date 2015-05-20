class MessageFormat < OpenStruct
 
  cattr_accessor :all

  def initialize(attrs)
    super(attrs)
    MessageFormat.all ||= []
    MessageFormat.all << self
  end 

  def regex
    Regexp.new(super)
  end

  def MessageFormat.build
    seeds = YAML.load_file(File.join(Rails.root, 'config','seeds','message_formats.yml'))
    seeds.each do |label,attributes|
      MessageFormat.new(attributes)
    end
    puts "Initialised #{MessageFormat.all.count} MessageFormat objects"
  end

end
