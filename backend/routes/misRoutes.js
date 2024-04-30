const express = require("express");
const router = express.Router();

const miscController = require("../controllers/miscController");

router.post("/post", miscController.getAt);
module.exports = router;
