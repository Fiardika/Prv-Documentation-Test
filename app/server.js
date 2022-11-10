const express = require("express");
require("dotenv").config();

const app = express();
const port = process.env.PORT || 3000;

app.get("/", function (req, res) {
    console.log(req.socket.remoteAddress);
    console.log(req.ip);
    res.send("IP: " + req.ip);
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}.`);
});
