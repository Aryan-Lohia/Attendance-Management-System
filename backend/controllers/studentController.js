const Student = require("../models/studentSchema");
const Subject = require("../models/subjectSchema");
const User = require("../models/userSchema");
const Attendance = require("../models/attendanceSchema");
exports.getProfile = async (req, res) => {
	try {
		const student = await Student.findOne({ studentId: req.user._id });
		if (!student) {
			return res.status(400).json({ error: "Student not found" });
		}
		const subjects = await Subject.find({
			department: student.department,
			semester: student.semester,
			section: student.section,
		});
		let attendance = [];
		for (let i = 0; i < subjects.length; i++) {
			const subjectAttendance = await Attendance.find({
				studentId: req.user._id,
				subjectId: subjects[i]._id,
				attendance: true,
			});
			attendance.push(subjectAttendance.length);
		}
		res.status(200).json({
			user: req.user,
			student: student,
			subjects: subjects,
			attendance: attendance,
		});
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};
exports.createStudent = async (req, res) => {
	try {
		const user = await User.findOne({ uid: req.body.uid });
		if (!user) {
			return res.status(400).json({ error: "User does not exist" });
		}

		const file = req.files;
		if (!file)
			return res.status(400).json({ error: "No files were uploaded." });
		const filePath = `${__dirname}/../assets/students/${file.file.name}`;
		file.file.mv(filePath, (err) => {
			if (err) {
				return res.status(500).send(err);
			}
		});
		console.log(file);
		const student = await Student.create({
			studentId: user._id,
			semester: req.body.semester,
			department: req.body.department,
			section: req.body.section,
			image: `assets/students/${file.file.name}`,
		});
		res.status(201).json({ status: "success" });
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};

exports.getAttendance = async (req, res) => {
	try {
		const student = await Student.findOne({ studentId: req.user._id });

		if (!student) {
			return res.status(400).json({ error: "Student not found" });
		}

		const subjectId = req.params.subjectId;

		const subject = await Subject.findById(subjectId);

		if (!subject) {
			return res.status(400).json({ error: "Subject not found" });
		}

		if (!student.enrolledSubjects.includes(subjectId)) {
			return res
				.status(400)
				.json({ error: "Student not enrolled in this subject" });
		}

		const attendance = await Attendance.find({
			studentId: req.user._id,
			subjectId: subjectId,
			attendance: true,
		});
		const notAttendance = await Attendance.find({
			studentId: req.user._id,
			subjectId: subjectId,
			attendance: false,
		});
		res.status(200).json({
			message: "Attendance fetched successfully",
			attended: attendance.length,
			notAttended: notAttendance,
			classTaken: subject.classesTaken,
		});
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};
exports.getSubjects = async (req, res) => {
	try {
		const student = await Student.findOne({ studentId: req.user._id });
		if (!student) {
			return res.status(400).json({ error: "Student not found" });
		}
		const subjects = await Subject.find({
			_id: { $in: student.enrolledSubjects },
		});

		res.status(200).json({
			message: "Subjects fetched successfully",
			subjects,
		});
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};
