#!/bin/bash

echo "Installing frontent deps"
cd frontend
npm install

cd ../backend

echo "Installing backend deps"
bundle install