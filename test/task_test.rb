require 'test_helper'

class TaskTest < AppTest
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