$:.unshift(File.dirname(__FILE__) + '/../lib')

ENV['RAILS_ENV'] = 'test'

require 'test/unit'
require File.join(File.dirname(File.dirname(__FILE__)), "lib", "mile_marker")
require 'ostruct'

module MockResponse
  def response
    @test_response ||= OpenStruct.new({:body => ""})
  end
end
Test::Unit::TestCase.send :include, MockResponse
Thoughtbot::MileMarkerHelper.send :include, MockResponse
