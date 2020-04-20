#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra-websocket'
require 'gm1356'

set :port, 7200
set :public_folder, 'public'

device = GM1356::Device.new({ filter: 'a', speed: 'f' })

get "/" do
    if !request.websocket?
        redirect '/index.html'
    else
        request.websocket do |ws|
            ws.onopen do
                device.read do |r|
                    ws.send(r.spl.to_s) 
                end
            end
        end
    end
end

