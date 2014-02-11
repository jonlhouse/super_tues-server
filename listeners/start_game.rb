module SuperTues
  module Server
    module Listeners

      class StartGame < GameListener
        def handle(payload)
          Logger.log.info "Starting Game..."
          game.start
        end
      end

    end
  end
end