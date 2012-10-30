require 'test/unit'
require 'app'

class AppTest < Test::Unit::TestCase
  def setup
    @finish_time = Time.now + 1000
    @description = 'Test description'
    @task = App::Task.new(:finish_time => @finish_time, :description => @description)
    @queue = App::Queue.new
  end
end