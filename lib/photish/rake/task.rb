module Photish
  module Rake
    class Task
      attr_accessor :options

      def initialize(task_name = "photish", desc = "Run photish")
        @task_name = task_name
        @desc = desc
        yield self if block_given?
        define_task
      end

      def define_task
        desc @desc
        task @task_name do
          Photish::CLI::Interface.new.start(options)
        end
      end
    end
  end
end
