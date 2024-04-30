const express = require("express");
const router = express.Router();
const facultyController = require("../controllers/facultyController");
const { verifyToken } = require("../middleware/auth");
router.get("/subjects/:id", verifyToken, facultyController.getSubjects);
router.post("/create", verifyToken, facultyController.addSubject);
router.get("/students/:uid", verifyToken, facultyController.getStudents);
module.exports = router;
