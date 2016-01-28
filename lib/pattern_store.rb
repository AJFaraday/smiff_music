class PatternStore

  # version renews on restarting the server
  # updates made while the server is running, when store is updated
  cattr_accessor :version
  cattr_accessor :hash

  # An array of entities changed at a given version
  cattr_accessor :changed_entities

  def PatternStore.version
    $pattern_store_version ||= SystemSetting['pattern_version'].to_i
  end

  def PatternStore.version=(value)
    $pattern_store_version = SystemSetting['pattern_version'] = PatternStore.hash['version'] = value
  end

  def PatternStore.increment_version(entity=nil,value=nil)
    PatternStore.version += 1
    if entity
      PatternStore.changed_entities ||= []
      PatternStore.changed_entities[PatternStore.version] = entity
    end 
  end 

  #
  # Only return the hash for entities changed more recently than that version
  #
  def PatternStore.hash_for_version(version)
    PatternStore.changed_entities ||= []
    entities = PatternStore.changed_entities[version.to_i..PatternStore.version].to_a.uniq.compact
    return {} if entities.none?
    result = {'version' => PatternStore.version}
    entities.each do |entity|
      if entity.is_a?(Pattern)
        result['patterns'] ||= {}
        result['patterns'][entity.name] = entity.to_hash
      elsif entity.is_a?(Synth)
        result['synths'] ||= {}
        result['synths'][entity.name] = entity.to_hash
      elsif entity == Pattern
        result['patterns'] = Pattern.to_hash
      elsif entity == Synth
        result['synths'] = Synth.to_hash
      elsif entity == 'bpm'
        result['bpm'] = SystemSetting['bpm']
      end
    end
    result
  end 

  def PatternStore.hash
    $pattern_store_hash ||= PatternStore.build_hash
  end

  def PatternStore.build_hash
    $pattern_store_hash = {}
    $pattern_store_hash['patterns'] = Pattern.to_hash
    $pattern_store_hash['synths'] = Synth.to_hash
    $pattern_store_hash['bpm'] = SystemSetting['bpm']
    $pattern_store_hash['version'] = PatternStore.version
    $pattern_store_hash
  end

  def PatternStore.modify_hash(changed_entity, value=nil)
    if changed_entity.is_a?(Pattern)
      PatternStore.hash['patterns'][changed_entity.name] = changed_entity.to_hash
    elsif changed_entity.is_a?(Synth)
      PatternStore.hash['synths'][changed_entity.name] = changed_entity.to_hash
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
    PatternStore.increment_version(changed_entity,value)
    PatternStore.hash
  end


end
