const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController");
const authMiddleware = require("../middleware/auth");
router.post("/register", authController.register);
router.post("/login", authController.login);
router.post("/check", authMiddleware.checkToken);
module.exports = router;
