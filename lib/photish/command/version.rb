module Photish
  module Command
    class Version < Base
      def run
        puts "#{Photish::NAME_AND_VERSION}"
        puts ''
        puts "#{RUBY_DESCRIPTION}"
        puts ''
        puts "RubyGems:"
        Gem.loaded_specs.values.each {|x| puts "- #{x.name} #{x.version}" }
      end
    end
  end
end
