require 'test_helper'

class CommandLine::ReadlineTest < ActiveSupport::TestCase
  include CommandLine::Readline
  attr_accessor :options # so we don't need to refer to CommandLine::Autocomplete here

  def test_common_substring
    strings = ['test x', 'test y']
    common_string = common_substring(strings)
    assert_equal('test ', common_string)
  end

  def test_completion_process
    process = completion_process
    assert_kind_of(Proc, process)

    self.options = [
      'test a b c',
      'test b c d'
    ]
    # start doesn't match any
    assert_equal('yyy', process.call('yyy'))
    #start matches both - return common substring
    assert_equal('test ', process.call('t'))
    # only one option - return the full string
    assert_equal('test a b c', process.call('test a'))
  end

end
