const express = require('express');
const os = require('os');
const fs = require('fs');
const path = require('path');
const app = express()
const port = 3000


// Read the contents of the package.json file
const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));

// Access the version number
const appVersion = packageJson.version;

// console.log('App Version:', appVersion);

// Set EJS as the view engine
app.use('/public',express.static(path.join(__dirname,'static')))

app.set('view engine', 'ejs');

app.get('/', (req, res) => {
    res.render('index', { hostname: os.hostname(), 
        appVersion: appVersion });
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})