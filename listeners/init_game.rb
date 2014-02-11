module SuperTues
  module Server
    module Listeners

      class InitGame < GameListener
        def handle(payload)
          Logger.log.info "Init Game"
          Logger.log.info env.inspect
          
          game.init_game

          channel.to_each('game.initialized', game) do |player|
            {
              color: player.color,
              cash: player.cash.to_i,
              clout: player.clout.to_i,
              cards: player.cards.map(&:to_h),
              seat: player.seat,
              state: player.candidate.state,
              known_picks: { 'IN' => { player.to_s => 3} } #player.visible_picks
            }
          end

          # expect all players to return 'ready'
        end
      end

    end
  end
end