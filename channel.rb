module SuperTues
	module Server
    class Channel < EM::Channel

      # allows a passed "string-based" subscriber name
      def subscribe(*a, &b)
        name = a.shift
        EM.schedule { @subs[name] = EM::Callback(*a, &b) }
        name
      end

      def broadcast(type, payload)
        msg = message(type, payload)        
        self.push msg
      end
      def to(player, type, payload)
        msg = message(type, payload)
        EM.schedule { @subs[player.to_s].call msg }
      end
      def to_each(type, game)
        game.players.each do |player|
          payload = yield player
          EM.schedule { @subs[player.to_s].call message(type, payload) }
        end
      end 

      def to_s
        "Channel with subscribers: [#{@subs.keys.join(', ')}]>"
      end
    private
      def message(type, payload)
        [type, payload].to_json
      end
    end
	end
end