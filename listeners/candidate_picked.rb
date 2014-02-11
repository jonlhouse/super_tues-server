module SuperTues
  module Server
    module Listeners

      class CandidatePicked < GameListener
        def handle(payload)
          Logger.log.info "Player #{env.player} picked: #{payload['who']}"        
          game.player(player).candidate = payload['who']
          game_schedule { env.dispatcher.dispatch 'game.init' } if game.candidates_picked?
        end
      end

    end
  end
end
