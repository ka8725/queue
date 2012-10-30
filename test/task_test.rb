require 'test/unit'
require 'app'

class TaskTest < Test::Unit::TestCase
  def setup
    @finish_time = Time.now + 1000
    @description = 'Test description'
    @task = App::Task.new(:finish_time => @finish_time, :description => @description)
  end

  def test_class_for_instance
    assert_instance_of(App::Task, @task)
  end

  def test_description_existance
    assert_equal(@task.description, @description)
  end

  def test_finish_time_existance
    assert_not_nil(@task.finish_time, @finish_time)
  end
end