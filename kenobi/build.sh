#!/bin/bash

echo "Installing dependencies"
yarn install

echo "Stopping PM2 Server"
pm2 stop pm2.config.js

echo "Building Project"
yarn build

echo "Finished copying the build files"

echo "Restart PM2 instace"
pm2 start pm2.config.js
