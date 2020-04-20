#!/bin/bash

cd ./frontend

echo "Building frontend"
npm run build

cd ../backend
rm -rf ./public

echo "Copying files"
mv ../frontend/build public

echo "Running server"
bundle exec server.rb