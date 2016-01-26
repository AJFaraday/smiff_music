module CommandLine
  module Readline

    attr_writer :options

    def init_readline
      ::Readline.basic_word_break_characters = ''
      ::Readline.completion_append_character = ''
      ::Readline.completion_proc = completion_process
    end

    def completion_process
      proc do |input|
        options = self.options.select { |x| !!x.match(/^#{Regexp.escape(input)}/i) }
        if options.count == 0
          puts "\nno suggestions"
          print "> #{input}"
          input
        elsif options.count == 1
          options[0]
        else
          puts "\n"
          puts options.shuffle[0..10].sort
          result = common_substring(options)
          print "> #{input}"
          result
        end
      end
    end

    def common_substring(options)
      options.inject { |m, s| s[0,(0..m.length).find { |i| m[i] != s[i] }.to_i] }
    end

  end
end