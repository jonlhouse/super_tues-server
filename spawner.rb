require 'goliath'

module SuperTues
  module Server

    # Game Goliath Server
    #
    # A client connects to the goliath server via a websocket request.
    #  
    class Spawner < Goliath::API

      attr_accessor :games

      use Goliath::Rack::Formatters::JSON

      def games
        games ||= [{name: "John's Game", players: 2, max_players: 4}]    # TOOD: DB backend
      end

      def response(env)
        if env['REQUEST_PATH'] == '/games'
          [200, {'Content-Type' => 'application/json'}, games]
        else
        end
      end
    end

  end
end
