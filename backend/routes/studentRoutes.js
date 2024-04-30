const express = require("express");
const router = express.Router();
const { verifyToken } = require("../middleware/auth");
const studentController = require("../controllers/studentController");

router.get("/subjects", verifyToken, studentController.getSubjects);
router.get(
	"/attendance/:subjectId",
	verifyToken,
	studentController.getAttendance
);
router.get("/profile", verifyToken, studentController.getProfile);

module.exports = router;
