require './test/test_helper'

class ConsoleTest < ActionDispatch::IntegrationTest

  def setup
    InMemory.rebuild
  end

  def send_message(text)
    page.find('#terminal_tab').click
    fill_in('message', :with => text)
    find('div#submit').click
    wait_for_ajax
  end

  def press_key(keyname)
    keycode = case keyname
      when 'up'
        38
      when 'down'
        40
      when 'enter'
        13
    end
    page.evaluate_script(
      "$('input#message').trigger($.Event('keyup', { keyCode: #{keycode} }))"
    )
  end

  def test_send_message_with_click
    visit '/'
    send_message('play kick on step 1')
    readout = find('div#readout')
    assert_includes(readout.text, "> play kick on step 1")
    assert_includes(readout.text, "Now playing kick on step 1")
    page.find('#overview_tab').click
    assert page.has_css?('td#kick_step_0.active')
  end

  def test_send_message_with_enter_key
    visit '/'
    page.find('#terminal_tab').click
    fill_in('message', :with => 'play kick on step 1')
    press_key('enter')
    wait_for_ajax
    readout = find('div#readout')
    assert_includes(readout.text, "> play kick on step 1")
    assert_includes(readout.text, "Now playing kick on step 1")
    page.find('#overview_tab').click
    assert page.has_css?('td#kick_step_0.active')
  end

  def test_message_scrolling
    visit '/'
    send_message('this')
    send_message('that')
    send_message('the other')

    press_key('up')
    assert_equal 'the other', find('#message').value
    press_key('up')
    assert_equal 'that', find('#message').value
    press_key('up')
    assert_equal 'this', find('#message').value
    # at the start of the list, this stays at oldest message
    press_key('up')
    assert_equal 'this', find('#message').value

    press_key('down')
    assert_equal 'that', find('#message').value
    press_key('down')
    assert_equal 'the other', find('#message').value
    # after the list, an empty field
    press_key('down')
    assert_equal '', find('#message').value
    # once you're at the end. down does nothing
    press_key('down')
    assert_equal '', find('#message').value
  end

  def test_sent_button_effect
    page.find('#terminal_tab').click
    refute page.has_css?('div#submit.active')
    page.evaluate_script("$('input#message').trigger($.Event('keydown', { keyCode: 13 }))")
    assert page.has_css?('div#submit.active')
    page.evaluate_script("$('input#message').trigger($.Event('keyup', { keyCode: 13 }))")
    refute page.has_css?('div#submit.active')
  end

end
