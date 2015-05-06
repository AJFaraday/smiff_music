require './test/test_helper'

class PlayerTest < ActionDispatch::IntegrationTest

  def test_click_play
    visit '/'
    assert page.has_css?('div#play_button')
    find('div#play_button').click
    assert page.has_css?('div#stop_button', visible: true)
    result = page.evaluate_script('Sound.player')
    assert result.is_a?(Integer)
    assert result >= 0
    assert page.evaluate_script('Sound.player_active')
  end

  def test_click_stop
    visit '/'
    assert page.has_css?('div#play_button')
    find('div#play_button').click
    assert page.evaluate_script('Sound.player_active')

    assert page.has_css?('div#stop_button')
    find('div#stop_button').click

    refute page.evaluate_script('Sound.player_active')
    assert page.has_css?('div#play_button', visible: true)
  end



end
