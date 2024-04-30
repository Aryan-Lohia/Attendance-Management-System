const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const attendanceSchema = new Schema({
	studentId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: "User",
	},
	subjectId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: "Subject",
	},
	attendance: {
		type: Boolean,
		default: false,
	},
	date: {
		type: Date,
		default: Date.now,
	},
});

const Attendance = mongoose.model("Attendance", attendanceSchema);
module.exports = Attendance;
