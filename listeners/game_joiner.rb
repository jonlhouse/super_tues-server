module SuperTues
  module Server
    module Listeners

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
          game_schedule { env.dispatcher.dispatch 'deal-candidates' } if game.full?
        end
      end

    end
  end
end