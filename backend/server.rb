#!/usr/bin/env ruby

require 'sinatra/base'
require 'sinatra-websocket'
require 'gm1356'

class NoiseServer < Sinatra::Base
    configure do
        set :port, 7200
        set :public_folder, 'public'
        set :listeners, []
        set :device, GM1356::Device.new({ filter: 'a', speed: 'f' })

        settings.device.read do |r|
            puts 'Read ' + r.spl.to_s
            settings.listeners.each do |l| l(r.spl.to_s) end
        end
    end

    get "/" do
        if !request.websocket?
            redirect '/index.html'
        else
            request.websocket do |ws|
                ws.onopen do
                    settings.listeners << ws.send
                end
    
                ws.onclose do
                    settings.listeners.delete(ws.send)
                end
            end 
        end
    end
end

run NoiseServer.run!
