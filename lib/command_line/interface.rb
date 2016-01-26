module CommandLine
  class Interface

    include CommandLine::Readline
    include CommandLine::Autocomplete


    LOGO = '         _____ __  __ _____ ______ ______
        / ____|  \/  |_   _|  ____|  ____|
       | (___ | \  / | | | | |__  | |__
        \___ \| |\/| | | | |  __| |  __|
        ____) | |  | |_| |_| |    | |
       |_____/|_|  |_|_____|_|    |_|
  '

    def initialize
      @session = YAML.load_file(
        File.join(
          File.dirname(__FILE__),
          '..', '..',
          'config',
          'session_defaults.yml'
        )
      )
      @session = HashWithIndifferentAccess.new(@session)
      init_readline
      $cli_interface = self
    end

    def introduce
      print `clear`
      puts LOGO
      puts I18n.t('cli.introduction')
    end

    def run
      introduce
      while buf = ::Readline.readline("> ", true)
        if buf.include?(';')
          buf.split(';').each { |x| eval_message(x) }
        else
          eval_message(buf)
        end
      end
    end

    def eval_message(text)
      exit if text =~ /exit/
      response = Message.parse(text, @session).run
      update_session(response[:session])
      if response[:javascript]
        puts I18n.t('cli.can_not_run_javascript')
      else
        puts response[:display]
      end
      puts I18n.t('cli.file', file: response[:file]) if response[:file]
    end

    def update_session(hash)
      @session.merge!(hash) if hash
    end

  end
end