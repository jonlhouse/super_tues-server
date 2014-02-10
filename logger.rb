module SuperTues
  module Server

    class Logger
      include Singleton

      attr_reader :logger

      def initialize
        @logger ||= ::Logger.new(STDOUT)
      end

      def self.log
        instance.logger
      end

    end

  end
end