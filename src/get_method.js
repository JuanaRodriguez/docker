const express = require('express')
const app = express()
const os = require('os');
const network = require('ip');
const port = 3000

var d = new Date();

function data() {
    var hour = JSON.stringify(d.getHours());
    var date = JSON.stringify(d.getDate());
    var timezone = JSON.stringify(d.getTimezoneOffset());   
    var hostname = JSON.stringify(os.hostname()); 
    var ip = (network.address()); 
    return [hour, date, timezone, hostname, ip];
  }

app.get('/', function (req, res)  {    
    res.send(data());
  });

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`))
