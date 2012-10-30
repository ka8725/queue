module App
  class Task
    attr_accessor :finish_time
    attr_accessor :description

    def initialize(options = {})
      @finish_time = options[:finish_time]
      @description = options[:description]
    end
  end
end