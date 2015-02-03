module Messages::Actions::ClearSteps

  attr_accessor :pattern
  attr_accessor :synth
  attr_accessor :steps

  def clear_steps(args)
    self.pattern = Pattern.find_by_name(args['pattern_name'])
    self.synth = Synth.find_by_name(args['pattern_name'])

    if self.pattern
      if args.keys.include?('steps')
        remove_steps(munge_list(args['steps']))
      elsif args.keys.include?('start_step') and args.keys.include?('end_step')
        if args.keys.include?('block_size')
          clear_block_skipping(args)
        else
          clear_block(args)
        end
      end
    elsif self.synth
      if args.keys.include?('steps')
        remove_steps_from_synth(munge_list(args['steps']))
      elsif args.keys.include?('start_step') and args.keys.include?('end_step')
        if args.keys.include?('block_size')
          clear_block_from_synth_skipping(args)
        else
          clear_block_from_synth(args)
        end
      end
    else
      pattern_not_found([args['pattern_name']])
    end
  end

  def remove_steps_from_synth(steps)
    modified_steps = steps.collect { |x| x.to_i - 1 }
    out_of_range_steps = steps.select { |x| x.to_i < 1 or x.to_i > self.synth.step_count }
    return out_of_range_warning if out_of_range_steps.any?
    steps_removed = modified_steps.select{ |step| self.synth.remove_note(step) }
    if steps_removed.any?
      return {
        response: 'success',
        display: I18n.t(
          "actions.clear_steps.success.#{steps.count > 1 ? 'other' : 'one'}",
          name: self.synth.name,
          steps: steps.to_sentence(last_word_connector: ' or ')
        )
      }
    else
      {
        response: 'failure',
        display: I18n.t(
          "actions.clear_steps.no_steps_to_remove.#{steps.count > 1 ? 'other' : 'one'}",
          steps: steps.to_sentence(
            last_word_connector: ' and '
          )
        )
      }
    end
  end

  def clear_block_from_synth_skipping(args)
    edges = [args['start_step'].to_i, args['end_step'].to_i]
    steps = (edges.min..edges.max).to_a
    steps.reject! { |x| (x - edges.min + 1) % (args['block_size'].to_i + 1) != 1 }
    steps.each{|step| self.synth.clear_range(step - 1,step - 1)}
    self.synth.save!
    return {
      response: 'success',
      display: I18n.t(
        "actions.clear_steps.success.other",
        name: self.synth.name,
        steps: steps.to_sentence(
          last_word_connector: ' and '
        )
      )
    }
  end

  def clear_block_from_synth(args)
    steps = (args['start_step']..args['end_step']).to_a
    self.synth.clear_range(
      (args['start_step'].to_i - 1),
      (args['end_step'].to_i - 1)
    )
    self.synth.save!
    return {
      response: 'success',
      display: I18n.t(
        "actions.clear_steps.success.other",
        name: self.synth.name,
        steps: steps.to_sentence(
          last_word_connector: ' and '
        )
      )
    }
  end


  # this sets the array, steps, indexes to true
  def remove_steps(steps)
    modified_steps = steps.collect { |x| x.to_i - 1 }
    out_of_range_steps = steps.select { |x| x.to_i < 1 or x.to_i > self.pattern.step_count }
    return out_of_range_warning if out_of_range_steps.any?
    self.pattern.pattern_indexes -= modified_steps
    self.pattern.save!
    return {
      response: 'success',
      display: I18n.t(
        "actions.clear_steps.success.#{steps.count > 1 ? 'other' : 'one'}",
        name: self.pattern.name,
        steps: steps.to_sentence(
          last_word_connector: ' and '
        )
      )
    }
  end

  def out_of_range_warning
    {
      response: 'failure',
      display: I18n.t(
        'actions.clear_steps.out_of_range',
        max: self.pattern.step_count
      )
    }
  end

  def clear_block(args)
    steps = (args['start_step']..args['end_step']).to_a
    remove_steps(steps)
  end

  def clear_block_skipping(args)
    edges = [args['start_step'].to_i, args['end_step'].to_i]
    steps = (edges.min..edges.max).to_a
    steps.reject! { |x| (x - edges.min + 1) % (args['block_size'].to_i + 1) != 1 }
    remove_steps(steps)
  end


end
