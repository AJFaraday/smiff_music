class Messages::FormatBuilder

  def build_messages
    definitions = YAML.load_file(File.join(Rails.root,'db','seed','message_definitions.yml'))
    definitions.each do |name, params|
      if already_created?(params['name'])
        update_format(params)
      else
        create_format(params)
      end
    end 
  end
 
  def already_created?(name)
    MessageFormat.where(:name => name).any?
  end

  def update_format(params)
    message_format = MessageFormat.where(:name => params['name']).first
    message_format.update_attributes!(params)
  end

  def create_format(params)
    MessageFormat.create!(params)
  end 

end
