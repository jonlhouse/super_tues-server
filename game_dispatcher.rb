require 'dispatchio'

module SuperTues
  module Server

    class GameDispatcher < Dispatchio::Dispatcher

      attr_accessor :game, :channel

      def load_listeners(env)
        add ServerConnect.new('server.connected', env: env)
        add ServerDisconnect.new('server.disconnected', env: env)
        add GameJoiner.new('game.join', env: env)
        add CandidateDealer.new('deal-candidates', env: env)
        add CandidatePicked.new('candidate.picked', env: env)
        add StartGame.new('start-game', env: env)
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

    # 
    #
    class GameListener < Dispatchio::Listener
      extend Forwardable
      attr_accessor :env

      def_delegators :@env, :game, :channel, :dispatcher, :ws, :player
    end

    class GameJoiner < GameListener
      def handle(payload)        
        name = payload['player']

        # add current player's ws to the list
        env.players[name] = { ws: env.ws }

        # join channel
        ws_closure = ws
        channel.subscribe name do |msg|
          Logger.log.info ">> #{msg}"
          ws_closure.send(msg, type: 'text')
        end

        # notify of join
        game.add_players SuperTues::Board::Player.new(name: name)        
        channel.broadcast 'game.joined', who: name

        # start-game/deal-candidates if full
        EM.next_tick { env.dispatcher.dispatch 'deal-candidates' } if game.full?
      end
    end

    class CandidateDealer < GameListener
      def handle(payload)
        Logger.log.info "Dealing Candidates"
        game.deal_candidates

        channel.to_each('candidates.dealt', game) do |player|
          { candidates: player.candidates_dealt.map(&:to_h) }
        end
      end
    end

    class CandidatePicked < GameListener
      def handle(payload)
        Logger.log.info "Player #{env.player} picked: #{payload['who']}"        
        game.player(player).candidate = payload['who']
        EM.next_tick { env.dispatcher.dispatch 'start-game' } if game.candidates_picked?
      end
    end

    class StartGame < GameListener
      def handle(payload)
        Logger.log.info "Starting Game!!"
      end
    end

  end
end