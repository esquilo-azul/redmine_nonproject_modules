# frozen_string_literal: true

require 'eac_ruby_utils/simple_cache'

module RedmineNonprojectModules
  # https://stackoverflow.com/questions/12088025/detect-if-application-was-started-as...
  # https://github.com/newrelic/rpm/blob/master/lib/new_relic/local_environment.rb
  class DispatcherFinder
    WEBSERVER_DISPATCHERS = %w[webrick passenger].freeze
    DISPATCHERS = WEBSERVER_DISPATCHERS

    class << self
      include ::EacRubyUtils::SimpleCache

      def webserver?
        WEBSERVER_DISPATCHERS.include?(dispatcher)
      end

      def webrick?
        defined?(::WEBrick) && defined?(::WEBrick::VERSION)
      end

      def passenger?
        defined?(::PhusionPassenger)
      end

      private

      def dispatcher_uncached
        DISPATCHERS.find { |d| send("#{d}?") }
      end
    end
  end
end
