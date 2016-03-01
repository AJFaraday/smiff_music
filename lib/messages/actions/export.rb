module Messages
  module Actions
    module Export

      COMPILERS = {
        'sonic-pi' => ::Export::SonicPi::Exporter,
        'sonic pi' => ::Export::SonicPi::Exporter,
        'sonic_pi' => ::Export::SonicPi::Exporter
      }

      def export(args)
        system = args['system'][0]
        exporter_class = COMPILERS[system.downcase]
        if exporter_class
          exporter = exporter_class.new(PatternStore.hash)

          file = exporter.write_file

          return {
            response: 'success',
            display: I18n.t(
              'actions.export.success',
              system: system.titlecase
            ),
            file: file
          }
        else
          return {
            response: 'failure',
            display: I18n.t(
              'actions.export.unknown_exporter',
              system: system
            )
          }
        end
      end

    end
  end
end