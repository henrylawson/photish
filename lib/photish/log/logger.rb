require 'logging'

module Photish
  module Log
    module Logger
      def self.setup_logging
        Logging.color_scheme('bright',
          :levels => {
            :info  => :green,
            :warn  => :yellow,
            :error => :red,
            :fatal => [:white, :on_red]
          },
          :date => :blue,
          :logger => :cyan,
          :message => :magenta
        )

        Logging.appenders.stdout(
          'stdout',
          :layout => Logging.layouts.pattern(
            :pattern => '[%d] %-5l %c: %m\n',
            :color_scheme => 'bright'
          )
        )
        Logging.logger.root.appenders = 'stdout'
        Logging.logger.root.level = :info
      end
    end
  end
end
