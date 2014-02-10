require 'dispatchio'

require_relative "./listeners/game_listener"
[:game_joiner, :candidate_dealer, :candidate_picked, :start_game].each do |listener|
  require_relative "./listeners/#{listener}"
end

module SuperTues
  module Server

    class GameDispatcher < Dispatchio::Dispatcher

      attr_accessor :game, :channel

      def load_listeners(env)
        add ServerConnect.new('server.connected', env: env)
        add ServerDisconnect.new('server.disconnected', env: env)
        add Listeners::GameJoiner.new('game.join', env: env)
        add Listeners::CandidateDealer.new('deal-candidates', env: env)
        add Listeners::CandidatePicked.new('candidate.picked', env: env)
        add Listeners::StartGame.new('start-game', env: env)
      end

    end

    class ServerConnect < Dispatchio::Listener
      attr_accessor :env
      def handle(payload)
      end
    end

    class ServerDisconnect < Dispatchio::Listener
      attr_accessor :env
      def handle(payload)
      end
    end

  end
end