module App
  class Queue
    attr_reader :tasks
    private :tasks

    def initialize
      @tasks = []
    end

    def push(task)
      tasks << task
      tasks.sort! { |task1, task2| task1.finish_time <=> task2.finish_time }
    end

    def pop
      tasks.shift
    end

    def get_task(finish_time)
      return if tasks.empty?
      return tasks.shift if tasks.first.finish_time <= finish_time
    end

  end
end
