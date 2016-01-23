class CommandLineInterface

  attr_accessor :session

  def initialize
    @session = YAML.load_file(
      File.join(
        File.dirname(__FILE__),
        '..',
        'config',
        'session_defaults.yml'
      )
    )
  end

  def prompt
    print '> '
    text = gets
    eval_message(text)
  end

  def eval_message(text)
    response = Message.parse(text, @session).run
    puts response[:display]
  end

end