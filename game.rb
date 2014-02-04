require 'json'
require 'goliath'
require 'goliath/websocket'

module SuperTues
  module Server

    # Game Goliath Server
    #
    # A client connects to the goliath server via a websocket request.
    #  
    class Game < Goliath::WebSocket
      use Goliath::Rack::Params

      @@channels = {}
      @@games = {}

      def game_id
        env['game_id']
      end

      def on_open(env)
        env.logger.info("WS Open")
        subscribe_to_game_channel
      end

      def on_message(env, msg)
        env.logger.info "<<--: #{msg}"
        type, payload = parse_message(msg)
        resp = handle_message(env, type, payload)
        # env['channels'][game_id] << resp
      end

      def on_close(env) 
        unsubscribe_to_game_channel
        env.logger.info "Closed connection to websocket."
      end

      def on_error(env, error)
        env.logger.info ("Error: #{error}")
      end

      def handle_message(env, type, payload)
        join_game(payload['player']) if type == 'join'        
      end

      def send_message(type, payload = {})
        msg = message('joined', payload)
        env.logger.info "-->>: #{msg}"
        env['channel'] << msg
      end

      def response(env)
        if env['REQUEST_PATH'] =~ /games\/(\w+)$/i
          env['game_id'] = $1
          super(env)
        else
          [404, {}, "Game not found"]
        end
      end

    private

      def subscribe_to_game_channel
        env['channel'] = channel = @@channels[game_id] || begin
          env.logger.info "Creating new channel"
          @@channels[game_id] = EM::Channel.new
        end
        # need to put env in a closure here.
        env_closure = env
        env['subscription'] = env['channel'].subscribe { |m| env_closure.stream_send m }

        env.logger.info "Subscribed to game channel"
      end

      def unsubscribe_to_game_channel
        env['channel'].unsubscribe(env['subscription'])
      end

      def join_game(name)
        send_message 'joined', who: name
      end

      def message(event, payload = {})
        [ event, payload ].to_json
      end

      def parse_message(msg)
        type, payload = JSON.parse(msg)
        raise ArgumentError, "illegal message: #{msg}" unless type.is_a?(String) && payload.is_a?(Hash)
        [type, payload]
      end

    end

  end
end