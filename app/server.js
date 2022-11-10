const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
require("dotenv").config();

app.get('/',function(req, res) {
    const ipAddresses = req.header('x-forwarded-for');
    res.send("Your IP Address: " + ipAddresses);
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}.`);
});
