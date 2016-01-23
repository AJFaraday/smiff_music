class CommandLineInterface

  attr_accessor :session

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
        '..',
        'config',
        'session_defaults.yml'
      )
    )
    @session = HashWithIndifferentAccess.new(@session)
    @messages = []
  end

  def introduce
    print `clear`
    puts LOGO
    puts I18n.t('cli.introduction')
  end

  def prompt
    print '> '
    text = gets
    @messages << text
    eval_message(text)
  end

  def eval_message(text)
    response = Message.parse(text, @session).run
    @session.merge!(response[:session]) if response[:session]
    puts response[:display]
  end

end