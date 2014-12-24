class Messages::FormatBuilder

  def build_messages
    definitions = YAML.load_file(File.join(Rails.root,'lib','messages','definitions.yml'))
    definitions.each do |name, params|
      unless already_created?(params['name'])
        create_format(params)
      end
    end 
  end
 
  def already_created?(name)
    MessageFormat.where(:name => name).any?
  end

  def create_format(params)
    MessageFormat.create!(params)
  end 

end
