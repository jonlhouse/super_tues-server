module SuperTues
  module Server
    class Env
      attr_reader :game, :channel, :dispatcher
      attr_accessor :ws, :players, :player
      
      # Simple Hash-type environment.  The environment will [hopefully] be 
      #   request (client) specific, but access common variables such as the 
      #   game, dispatchers and other players websockets.
      #
      # #game -- the current game
      # #channel -- the group channel
      # #dispatcher -- the game dispatcher
      # #ws -- the current websocket
      # #player -- the player the message is received from
      # #players -- a hash of players, their game objects and websockets
      #   players = {
      #     "<name_str>" => { ws: <socket> }
      #   }
      #
      #
      def initialize(game, channel, dispatcher)
        @game = game
        @channel = channel
        @dispatcher = dispatcher
        @ws = {}
        @players = {}
      end

      # Refresh the "current" player and ws based on the websocket based
      def refresh(current_ws)
        self.ws = current_ws
        # find the current player
        self.player, player_hash = players.find( -> { [nil,nil] }) { |name,info| info[:ws] == ws }
        puts "Current player: #{player}, ws: #{ws}"
      end

    end
  end
end