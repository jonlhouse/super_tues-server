require 'json'
require 'eventmachine'
require 'websocket-eventmachine-server'
require 'super_tues/board'

require_relative './channel'
require_relative './game_dispatcher'
require_relative './logger'
require_relative './env'

module SuperTues
  module Server

    EM.run do

      game = SuperTues::Board::Game.new(max_players: 2)
      channel = Channel.new
      dispatcher = GameDispatcher.new
      env = Env.new(game, channel, dispatcher)

      dispatcher.load_listeners(env)

      WebSocket::EventMachine::Server.start(host: '0.0.0.0', port: 8080) do |ws|        
       
        ws.onopen do
          env.refresh(ws)
          dispatcher.dispatch 'server.connected'
        end

        ws.onclose do
          env.refresh(ws)
          dispatcher.dispatch 'server.disconnected'
        end

        ws.onmessage do |msg, type|
          env.refresh(ws)

          Logger.log.info "<< #{msg}"
          msg = JSON.parse(msg)          

          event = msg[0]
          payload = msg[1]
          dispatcher.dispatch event, payload
        end

      end
    end # end EM.run
  end
end