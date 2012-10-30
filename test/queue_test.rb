require 'test/unit'
require 'app'

class QueueTest < Test::Unit::TestCase
  def setup
    @queue = App::Queue.new
  end

  def test_class_for_instance
    assert_instance_of(App::Queue, @queue)
  end

  def test_respond_to_push
    assert_respond_to(@queue, :push)
  end

  def test_respond_to_pop
    assert_respond_to(@queue, :pop)
  end

  def test_respond_to_get_task
    assert_respond_to(@queue, :get_task)
  end
end
