require 'dispatchio'

require_relative "./listeners/game_listener"
[
  :game_joiner, :candidate_dealer, :candidate_picked, 
  :init_game, :player_ready, :start_game
].each { |listener| require_relative "./listeners/#{listener}" }

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
        add Listeners::InitGame.new('game.init', env: env)
        add Listeners::PlayerReady.new('player.ready', env: env)
        add Listeners::StartGame.new('game.start', env: env)
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