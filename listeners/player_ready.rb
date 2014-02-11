module SuperTues
  module Server
    module Listeners

      class PlayerReady < GameListener
        def handle(payload)
          game.player(player).is_ready
          game_schedule { env.dispatcher.dispatch "game.start" } if game.ready_to_start?
        end
      end

    end
  end
end