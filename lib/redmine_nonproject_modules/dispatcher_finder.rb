module RedmineNonprojectModules
  # https://stackoverflow.com/questions/12088025/detect-if-application-was-started-as...
  # https://github.com/newrelic/rpm/blob/master/lib/new_relic/local_environment.rb
  class DispatcherFinder
    WEBSERVER_DISPATCHERS = %w(webrick passenger)
    DISPATCHERS = WEBSERVER_DISPATCHERS

    class << self
      include ::Eac::SimpleCache

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
