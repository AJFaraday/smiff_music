class Messages::Parser

  cattr_accessor :weight_regexes
  cattr_accessor :used_weights

  attr_accessor :match_data
  attr_accessor :parsed
  attr_accessor :message_format
  attr_accessor :parameters

  def weight_regexes
    return @@weight_regexes if @@weight_regexes
    @@weight_regexes = {}
    @@used_weights = MessageFormat.all.collect{|x|x.weight}.uniq
    @@used_weights.each do |weight|
      regexes = MessageFormat.where(weight: weight).collect{|x|x.regex}
      @@weight_regexes[weight] = Regexp.union(regexes)
    end
    @@weight_regexes
  end 

  def parse(text)
    weights = weight_regexes.keys.sort.reverse
    weights.each do |weight|
      if weight_regexes[weight] =~ text and !self.parsed
        message_formats = MessageFormat.where(weight: weight)
        self.match_data = nil
        message_formats.each do |message_format|
          if self.match_data.nil?
            self.match_data = message_format.regex.match(text)
            if self.match_data
              self.message_format = message_format
              build_parameters
            end
          end
        end
        self.parsed = true
      end
    end     
  end

  def build_parameters
    self.parameters = {}
    if self.match_data and self.message_format and self.message_format.variables
      matches = self.match_data.to_a
      matches.shift # remove source text
      self.message_format.variables.each do |param|
        if self.message_format.variables.count == 1
          self.parameters[self.message_format.variables.first] = matches
        else
          if matches.count > 1 and param == self.message_format.variables[-1]
            self.parameters[param] = matches
          else
            self.parameters[param] = matches.shift
          end
        end
      end
    end
    self.parameters
  end

end
