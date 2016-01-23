module Messages
  module Actions
    module SetNoteLength

      def set_note_length(args)
        note_steps = args['note_steps'][0].to_i
        errors = errors_for_note_length(note_steps)
        if errors.none?
          return {
            response: 'success',
            display: I18n.t(
              'actions.set_note_length.note_length_set',
              note_length: note_steps
            ),
            session: {note_steps: note_steps}
          }
        else
          return {
            response: 'failure',
            display: I18n.t(
              'actions.set_note_length.length_not_set',
              note_length: note_steps,
              error: errors[0]
            )
          }
        end
      end

      def errors_for_note_length(note_length)
        errors = []
        if note_length < 1
          errors << I18n.t('actions.set_note_length.too_short')
        elsif note_length > 16
          errors << I18n.t('actions.set_note_length.too_long')
        end
        errors
      end

    end
  end
end
