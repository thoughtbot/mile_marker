require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class MileMarkerTest < Test::Unit::TestCase
  include Thoughtbot::MileMarkerHelper

  def test_todo_helper_should_return_nothing_if_no_enabled
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="test_environment"
    output = todo("Milestone 1")
    assert_nil output
  end

  def test_todo_helper_should_include_detail_when_supplied_detail
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    output = todo("Milestone 1")
    assert_equal "todo=\"Milestone 1\"", output
  end
  
  def test_todo_helper_should_include_no_detail_when_supplied_no_detail
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    output = todo
    assert_equal "todo=\"\"", output
  end
  
  def test_initialize_todo_should_return_nothing_if_not_enabled
    ENV['RAILS_ENV']="test_environment"
    output = initialize_mile_marker
    assert_nil output
  end

  def test_initialize_todo_should_return_javascript_if_enabled
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    output = initialize_mile_marker
    assert_match /function init_todo/, output
  end
  
  def test_javascript_should_be_added_to_head_if_enabled
    Thoughtbot::MileMarker.environments = ['development']
    ENV['RAILS_ENV']="development"
    response.body = "<head></head>"
    add_initialize_mile_marker
    assert_match /script/, response.body
  end
end