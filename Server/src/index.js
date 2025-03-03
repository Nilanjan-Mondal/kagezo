const express = require('express');
const ServerConfig = require('./configs/server.config');
const connectDB = require('./configs/db.config');

const app = express();

app.use(express.json());
app.use(express.text());
app.use(express.urlencoded({ extended: true }));

app.post('/ping', (req, res) => {
    console.log(req.body);
    return res.json({message: "pong"});
})


app.listen(ServerConfig.PORT, async () => {
    await connectDB();
    console.log(`Server started at port ${ServerConfig.PORT}...!!`);
});