module Messages::Actions::ClearSteps

  attr_accessor :pattern
  attr_accessor :steps

  def clear_steps(args)
    self.pattern = Pattern.find_by_name(args['pattern_name'])
    return pattern_not_found([args['pattern_name']]) unless self.pattern

    if args.keys.include?('steps')
      remove_steps(munge_list(args['steps']))
    elsif args.keys.include?('start_step') and args.keys.include?('end_step')
      if args.keys.include?('block_size')
        puts 'skipping'
        clear_block_skipping(args)
      else
        puts "not skipping #{args.inspect}"
        clear_block(args)
      end
    end
  end

  # this sets the array, steps, indexes to true
  def remove_steps(steps)
    modified_steps = steps.collect{|x| x.to_i - 1}
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

  def clear_block(args)
    steps = (args['start_step']..args['end_step']).to_a
    remove_steps(steps)
  end

  def clear_block_skipping(args)
    edges = [args['start_step'].to_i, args['end_step'].to_i]
    steps = (edges.min..edges.max).to_a
    steps.reject!{|x| (x - edges.min + 1) % (args['block_size'].to_i + 1) != 1}
    remove_steps(steps)
  end


end
