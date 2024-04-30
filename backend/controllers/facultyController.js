const Subject = require("../models/subjectSchema");
const Student = require("../models/studentSchema");
const Attendance = require("../models/attendanceSchema");
const Faculty = require("../models/facultySchema");
const User = require("../models/userSchema");

exports.createFaculty = async (req, res) => {
	try {
		const user = await User.findOne({ uid: req.body.uid });
		if (!user) {
			return res.status(400).json({ error: "User does not exist" });
		}
		const faculty = await Faculty.create({
			facultyId: user._id,
		});
		res.status(201).json({ status: "success" });
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};

exports.addSubject = async (req, res) => {
	try {
		const {
			subject_name,
			subject_code,
			semester,
			department,
			section,
			facultyId,
			uid,
		} = req.body;
		const newSubject = await Subject.create({
			subject_code,
			subject_name,
			semester,
			department,
			section,
			facultyId,
			uid,
		});
		const faculty = await Faculty.findOne({ facultyId: facultyId });
		if (!faculty) {
			return res.status(400).json({ error: "Faculty not found" });
		}
		const subjects = faculty.subjects;
		subjects.push(newSubject._id);
		const updatedFaculty = await Faculty.findOneAndUpdate(
			{ facultyId: facultyId },
			{ subjects: subjects }
		);
		const students = await Student.find({ semester, department, section });
		for (let i = 0; i < students.length; i++) {
			enrolledSubjects = students[i].enrolledSubjects;
			enrolledSubjects.push({ id: newSubject._id });
			await Student.findByIdAndUpdate(students[i]._id, {
				enrolledSubjects: enrolledSubjects,
			});
		}
		res.status(201).json({ status: "success" });
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};
exports.getStudents = async (req, res) => {
	try {
		const subject = await Subject.findOne({ uid: req.params.uid });
		const students = await Student.find({
			department: subject.department,
			semester: subject.semester,
			section: subject.section,
		});
		let studentList = [];
		for (let i = 0; i < students.length; i++) {
			const attendance = await Attendance.find({
				studentId: students[i].studentId,
				subjectId: subject._id,
			});
			studentList.push({
				student: students[i],
				attended: attendance.length,
			});
		}

		for (let i = 0; i < students.length; i++) {
			const user = await User.findById(students[i].studentId);
			studentList.push({ name: user.name, uid: user.uid });
		}
		res.status(200).json({ status: "success", studentList });
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};

exports.getAttendance = async (req, res) => {
	try {
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};

exports.takeAttendance = async (req, res) => {
	try {
		const subjectId = req.params.subjectId;
		const file = req.file;

		file.file.mv(`../assets/attendance/${file.file.name}`, async (err) => {
			if (err) {
				return res.status(400).json({ error: err.message });
			}
		});

		return res.status(200).json({ status: "success" });
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};

exports.getSubjects = async (req, res) => {
	try {
		const subjects = await Subject.find({ facultyId: req.params.id });
		res.status(200).json({ status: "success", subjects });
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};
