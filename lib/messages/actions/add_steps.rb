module Messages
  module Actions
    module AddSteps

      attr_accessor :pattern
      attr_accessor :steps

      def add_steps(args)
        self.pattern = Pattern.find_by_name(args['pattern_name'])
        return pattern_not_found([args['pattern_name']]) unless self.pattern

        if args.keys.include?('steps')
          set_steps(munge_list(args['steps']))
        elsif args.keys.include?('start_step') and args.keys.include?('end_step')
          if args.keys.include?('block_size')
            set_block_skipping(args)
          else
            set_block(args)
          end
        end
      end

      # this sets the array, steps, indexes to true
      def set_steps(steps)
        modified_steps = steps.collect { |x| x.to_i - 1 }
        out_of_range_steps = steps.select { |x| x.to_i < 1 or x.to_i > self.pattern.step_count }
        if out_of_range_steps.any?
          {
            response: 'failure',
            display: I18n.t(
              'actions.add_steps.out_of_range',
              max: pattern.step_count
            )
          }
        else
          self.pattern.pattern_indexes += modified_steps
          self.pattern.save!
          {
            response: 'success',
            display: I18n.t(
              "actions.add_steps.success.#{steps.count > 1 ? 'other' : 'one'}",
              name: self.pattern.name,
              steps: steps.to_sentence(
                last_word_connector: ' and '
              )
            )
          }
        end
      end

      def set_block(args)
        steps = (args['start_step']..args['end_step']).to_a
        set_steps(steps)
      end

      def set_block_skipping(args)
        edges = [args['start_step'].to_i, args['end_step'].to_i]
        steps = (edges.min..edges.max).to_a
        steps.reject! { |x| (x - edges.min + 1) % (args['block_size'].to_i + 1) != 1 }
        set_steps(steps)
      end


    end
  end
end
