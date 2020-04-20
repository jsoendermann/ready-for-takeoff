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
        set :reading, false
        set :start_reading, lambda {
            if settings.reading then
                return
            end
            settings.reading = true
            settings.device.read do |r|
                puts r.spl.to_s
                puts settings.listeners.to_s
                settings.listeners.each do |ws| ws.send(r.spl.to_s) end
            end
        }
    end

    get "/" do
        settings.start_reading()
        if !request.websocket?
            redirect '/index.html'
        else
            request.websocket do |ws|
                ws.onopen do
                    settings.listeners << ws
                end
    
                ws.onclose do
                    settings.listeners.delete(ws)
                end
            end 
        end
    end
end

run NoiseServer.run!
