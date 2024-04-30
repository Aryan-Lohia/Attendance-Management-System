const Attendance = require("../models/attendanceSchema");
const User = require("../models/userSchema");
const Student = require("../models/studentSchema");
const Subject = require("../models/subjectSchema");
exports.getAt = async (req, res) => {
	const { reg_no, uid } = req.body;
	try {
		const user = await User.findOne({ uid: reg_no[i] });
		const student = await Student.findOne({ studentId: user._id });

		for (let i = 0; i < reg_no.length; i++) {
			const attendance = await Attendance.create({
				studentId: user._id,
				subjectId: uid,
				attendance: true,
			});
			const subject = await Subject.findOne(uid);
			const classTaken = subject.classTaken;
			classTaken += 1;

			await Subject.findOneAndUpdate(uid, { classTaken: classTaken });
			res.status(201).json({ status: "success" });
		}
	} catch (err) {
		res.status(200).json({success:"Success"})
	}
};
