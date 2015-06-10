module ContextHelp::Guesser

  cattr_accessor :record_names

  def guess(text)
    text.downcase!
    self.types.each do |name, type|
      # check if any of the named records are mentioned
      if type['class']
        model = type['class'].constantize
        model.all.each do |record|
          if text.include?(record.name)
            return self.for(name, record.name)
          end
        end
      end
      # look to see if any synonyms are mentioned
      return self.for(name) if type['synonyms'].any? { |syn| text.include?(syn) }
    end
  end

end