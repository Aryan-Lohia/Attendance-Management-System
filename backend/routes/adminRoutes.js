const express = require("express");
const fileUpload = require("express-fileupload");
const router = express.Router();
const authController = require("../controllers/authController");
const studentController = require("../controllers/studentController");
const facultyController = require("../controllers/facultyController");
const { verifyToken } = require("../middleware/auth");

router.post("/create", verifyToken, authController.register);
router.post(
	"/student",
	verifyToken,
	fileUpload({ createParentPath: true }),
	studentController.createStudent
);
router.post("/faculty", verifyToken, facultyController.createFaculty);
module.exports = router;
