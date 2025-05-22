#!/bin/bash
# This script runs when you click the Share button!

npm run build 
npx --yes @fastly/compute-js-static-publish@latest --root-dir=./build --kv-store-name=website-content 
cd compute-js 
npm run dev:publish 
npm run dev:start
