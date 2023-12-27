#!/bin/bash
sudo apt update
sudo apt install -y nodejs
sudo apt install -y npm
sleep 30
mkdir -p /home/ubuntu/project
sleep 10
cd /home/ubuntu/project
echo "const express = require('express');
const app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});" | tee index.js
sleep 10
npm init -y
sudo npm install express
node index.js
