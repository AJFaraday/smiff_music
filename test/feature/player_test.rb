require './test/test_helper'

class PlayerTest < ActionDispatch::IntegrationTest

  def test_click_play
    visit '/'
    find('div#play_button').click
    assert page.has_css?('div#stop_button', visible: true)
    result = page.evaluate_script('Sound.player')
    assert result.is_a?(Integer)
    assert result > 0
  end

end