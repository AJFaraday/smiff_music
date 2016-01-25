module CommandLine
  module InitReadline

    def init_readline
      Readline.basic_word_break_characters = ''
      Readline.completion_append_character = ''
      Readline.completion_proc = completion_process
    end

    # TODO something better to replace this
    def commands
      [
        'play kick on step 1',
        'play kick on steps 1 to 32',
        'play kick on steps 1 to 32 skipping 3',
        'play c5 on step 1'
      ].sort
    end

    def completion_process
      proc do |input|
        options = commands.select { |x| !!x.match(/^#{Regexp.escape(input)}/) }
        if options.count == 0
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