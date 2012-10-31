require 'test_helper'

class QueueTest < AppTest
  def setup
    super
    @task_newest = @task.clone
    @task_newest.finish_time = @finish_time + 1000
    @task_oldest = @task.clone
    @task_oldest.finish_time = @finish_time - 1000
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

  def test_tasks_initialization
    assert_equal([], @queue.send(:tasks))
  end

  def test_private_tasks
    assert_raise(NoMethodError) { @queue.tasks } # private method call
  end

  def test_push_one_task
    @queue.push(@task)
    assert_equal([@task], @queue.send(:tasks))
  end

  def test_push_many_tasks
    fill_queue_with_tasks
    assert_equal([@task_oldest, @task, @task_newest], @queue.send(:tasks))
  end

  def test_pop
    fill_queue_with_tasks
    assert_equal(@task_oldest, @queue.pop)
    assert_equal([@task, @task_newest], @queue.send(:tasks))
  end

  def test_get_task_with_outdating_finish_time
    fill_queue_with_tasks
    assert_nil(@queue.get_task(@task_oldest.finish_time - 1000))
  end

  def test_get_task_with_future_finish_time
    fill_queue_with_tasks
    assert_equal(@task_oldest, @queue.get_task(@task_newest.finish_time + 1000))
  end

  def test_get_task_with_equal_finish_time
    fill_queue_with_tasks
    assert_equal(@task_oldest, @queue.get_task(@task_oldest.finish_time))
  end

  def test_get_task_with_empty_queue
    assert_nil(@queue.get_task(@task_newest.finish_time))
  end

  def test_changes_for_number_of_tasks_on_get_task
    fill_queue_with_tasks

    @queue.get_task(@task_newest.finish_time)
    assert_equal([@task, @task_newest], @queue.send(:tasks))

    @queue.get_task(@task_newest.finish_time)
    assert_equal([@task_newest], @queue.send(:tasks))

    @queue.get_task(@task_newest.finish_time)
    assert_equal([], @queue.send(:tasks))
  end

  def test_thread_safe
    20.times { @queue.push(@task) }
    threads = [].tap do
      10.times { @queue.pop }
    end
    threads.each(&:join)
    assert_equal(10, @queue.send(:tasks).count)
  end

  private
  def fill_queue_with_tasks(tasks = [@task, @task_newest, @task_oldest])
    tasks.each { |t| @queue.push(t) }
  end

end
