module SuperTues
  module Server
    module Listeners

      class CandidateDealer < GameListener
        def handle(payload)
          Logger.log.info "Dealing Candidates"
          game.deal_candidates

          channel.to_each('candidates.dealt', game) do |player|
            { candidates: player.candidates_dealt.map(&:to_h) }
          end
        end
      end

    end
  end
end