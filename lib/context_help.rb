module ContextHelp

  extend ContextHelp::Guesser

  cattr_accessor :types

  def ContextHelp.types
    @@types ||= YAML.load_file(File.join(Rails.root, 'lib', 'context_help', 'types.yml'))
  end

  def ContextHelp.type_names
    ContextHelp.types.keys
  end

  def ContextHelp.for(type, object_name=nil)
    if ContextHelp.type_names.include?(type)
      return ContextHelp.for_object(type, object_name) if object_name
      ContextHelp.for_type(type)
    else
      raise "This type of context sensitive help is unknown: #{type}"
    end
  end

  def ContextHelp.for_object(type, object_name)
    source_file = File.join(Rails.root, 'docs', 'context_help', "#{type}.md")
    format = ContextHelp.types[type]
    object = format['class'].constantize.find_by_name(object_name)
    subs = {}
    format['substitutions'].each do |name, method|
      subs[name] = object.send(method)
    end
    ContextHelp.render_file(source_file, subs)
  end

  def ContextHelp.for_type(type)
    plural_type = type.pluralize
    source_file = File.join(Rails.root, 'docs', 'context_help', "#{plural_type}.md")
    if File.exists?(source_file)
      ContextHelp.render_file(source_file)
    else
      source_file = File.join(Rails.root, 'docs', 'context_help', "#{type}.md")
      ContextHelp.render_file(source_file)
    end
  end

  def ContextHelp.render_file(path, substitutions={})
    source = File.read(path)
    ContextHelp.render(source, substitutions)
  end

  def ContextHelp.render(message, substitutions={})
    substitutions.each do |key, value|
      message.gsub!("{#{key}}", value.to_s)
    end
    message
  end

end