require 'photish/cli/interface'

module Photish
  module Rake
    class Task
      include ::Rake::DSL if defined?(::Rake::DSL)

      attr_accessor :options
      def options=(opts)
        @options = String === opts ? opts.split(' ') : opts
      end

      def initialize(task_name = "photish", desc = "Run photish")
        @task_name = task_name
        @desc = desc
        yield self if block_given?
        define_task
      end

      def define_task
        desc @desc
        task @task_name do
          Photish::CLI::Interface.start(options)
        end
      end
    end
  end
end
