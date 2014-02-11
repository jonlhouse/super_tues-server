module SuperTues
  module Server
    module Listeners

      # Base class for easily accessing env data
      #
      class GameListener < Dispatchio::Listener
        extend Forwardable
        attr_accessor :env

        def_delegators :@env, :game, :channel, :dispatcher, :ws, :player

        # Called from Listeners too pish a new event to be dispatched
        #
        # By default this gets pushed to the game (i.e. no 'current player')
        #
        def game_schedule
          EM.next_tick do
            env.refresh(nil)  # remove current player and ws
            yield
          end
        end
        
      end

    end
  end
end