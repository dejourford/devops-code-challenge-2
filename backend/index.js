const express = require('express')
const { v4: uuidv4 } = require('uuid');
const { CORS_ORIGIN } = require('./config')
console.log(require('./config'))
console.log(CORS_ORIGIN)

const ID = uuidv4()
const PORT = 3000

const app = express()
app.use(express.json())

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', CORS_ORIGIN)
    res.setHeader('Access-Control-Allow-Methods', 'GET')
    res.setHeader('Access-Control-Allow-Headers', '*')
    next();
})
app.get(/.*/, (req, res) => {
    console.log(`${new Date().toISOString()} GET`)
    res.json({id: ID, deployedVia: "jenkins-v3-docker-works"})
})

app.listen(PORT, () => {
    console.log(`Backend started on ${PORT}. ctrl+c to exit`)
})
