class PatternStore

  # version renews on restarting the server
  # updates made while the server is running, when store is updated
  cattr_accessor :version
  cattr_accessor :hash

  def PatternStore.version
    @@version ||= SystemSetting['pattern_version'].to_i
  end

  def PatternStore.version=(value)
    @@version = SystemSetting['pattern_version'] = PatternStore.hash['version'] = value
  end


  def PatternStore.hash
    @@hash ||= PatternStore.build_hash
  end

  def PatternStore.build_hash
    @@hash = Pattern.to_hash
    @@hash['bpm'] = SystemSetting['bpm']
    @@hash['version'] = PatternStore.version
    @@hash
  end

  def PatternStore.modify_hash(changed_entity, value=nil)
    if changed_entity.is_a?(Pattern)
      PatternStore.hash[changed_entity.name] = changed_entity.to_hash
    elsif changed_entity.is_a?(String)
      if value
        case changed_entity
          when 'bpm'
            PatternStore.hash['bpm'] = value
          else
            raise "Changed entity is unknown to PatternStore #{changed_entity.inspect}"
        end
      end
    else
      raise "Changed entity is unknown to PatternStore #{changed_entity.inspect}"
    end
    PatternStore.version += 1
    PatternStore.hash
  end


end
