require './test/test_helper'

class PatternsControllerTest < ActionController::TestCase

  def test_index_main_page
    get :index
    assert_response :success
    assert_template :index
    assert_template 'patterns/_patterns_table'
    assert_template 'shared/_js_init'
    assert_template 'shared/_play_controls'
    assert_template 'messages/_console'
  end

  def test_index_json_no_version
    get :index, format: 'json'
    assert_equal PatternStore.hash.to_json, response.body
  end

  def test_index_json_old_version
    get :index, version: SystemSetting['pattern_version'] - 1, format: 'json'
    assert_equal PatternStore.hash.to_json, response.body
  end

  def test_index_json_current_version
    get :index, version: SystemSetting['pattern_version'], format: 'json'
    assert_equal ' ', response.body
  end

end
