require 'redis/mutex'

module App
  class Queue
    attr_reader :tasks
    private :tasks

    def initialize
      @tasks = []
    end

    def push(task)
      with_lock do
        tasks << task
        tasks.sort! { |task1, task2| task1.finish_time <=> task2.finish_time }
      end
    end

    def pop
      with_lock do
        tasks.shift
      end
    end

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
