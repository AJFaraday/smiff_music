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


  def test_index_json_old_version
    synth1 = Synth.first
    PatternStore.increment_version(synth1)
    version = PatternStore.version
    synth2 = Synth.last
    PatternStore.increment_version(synth2)
    get :index, version: version - 1, format: 'json'
    assert_equal(
      {
        :version => version + 1,
        :synths => {
          synth1.name => synth1.to_hash,
          synth2.name => synth2.to_hash
        }
      }.to_json,
      response.body
    )
  end

  def test_index_json_current_version
    synth = Synth.first
    PatternStore.increment_version(synth)
    get :index, version: PatternStore.hash['version'] - 1, format: 'json'
    assert_equal(
      { 
        :version => PatternStore.version,
        :synths => {synth.name => synth.to_hash}
      }.to_json, 
      response.body
    )
  end

end
