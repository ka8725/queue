require 'redis/mutex'

module App #:nodoc:
  # = App::Queue

  # It is a thread safe queue wich allow to hold *tasks* sorted by +task.finish_time+
  #
  # Example:
  #
  #   q = Queue.new
  #   q.push(Task.new(:description => 'Description', :finish_time => Time.now))
  #   q.pop # => #<App::Task:0x007f836b1d8148 @finish_time=2012-10-31 01:49:26 +0300, @description='Description'>
  #   q.pop # => nil
  #   q.push(Task.new(:description => 'Description', :finish_time => Time.now))
  #   q.get_task(Time.now) # => #<App::Task:0x007f836b1d8148 @finish_time=2012-10-31 01:49:28 +0300, @description='Description'>
  class Queue
    attr_reader :tasks
    private :tasks

    def initialize
      @tasks = []
    end

    # Holds given +task+ and sort all *tasks* by +finish_time+. Task with oldest +finish_time+ takes first place
    def push(task)
      with_lock do
        tasks << task
        tasks.sort! { |task1, task2| task1.finish_time <=> task2.finish_time }
      end
    end

    # Returns the oldest task in the *queue*. If *queue* is empty it returns +nil+
    def pop
      with_lock do
        tasks.shift
      end
    end

    # Returns the oldest task in the *queue* which has attribute value for +finish_time+ less than given parameter +finish_time+.
    # If there are no appropriate task in the queue it returns +nil+
    def get_task(finish_time)
      with_lock do
        return if tasks.empty?
        return tasks.shift if tasks.first.finish_time <= finish_time
      end
    end

    private
    def with_lock
      Redis::Mutex.with_lock(:tasks) { yield }
    end
  end
end
