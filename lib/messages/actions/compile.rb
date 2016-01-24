module Messages
  module Actions
    module Compile

      COMPILERS = {
        'sonic-pi' => ::Compile::SonicPi::Compiler
      }

      def compile(args)
        system = args['system'][0]
        compiler_class = COMPILERS[system.downcase]
        if compiler_class
          compiler = compiler_class.new(PatternStore.hash)

          file = compiler.write_file

          return {
            response: 'success',
            display: I18n.t(
              'actions.compile.success',
              system: system,
              file: file
            )
          }
        else
          return {
            response: 'failure',
            display: I18n.t(
              'actions.compile.unknown_compiler',
              system: system
            )
          }
        end
      end

    end
  end
end