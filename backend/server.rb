#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra-websocket'
require 'gm1356'

set :port, 7200
set :public_folder, 'public'

device = GM1356::Device.new({ filter: 'a', speed: 'f' })

listeners = []

device.read do |r|
    listeners.each do |l| l(r.spl.to_s)
end

get "/" do
    if !request.websocket?
        redirect '/index.html'
    else
        request.websocket do |ws|
            ws.onopen do
                listeners << ws.send
            end

            ws.onclose do
                listeners.delete(ws.send)
            end
        end 
    end
end

