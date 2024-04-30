const mongoose = require("mongoose");

const studentSchema = new mongoose.Schema({
	studentId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: "User",
		required: true,
	},
	semester: {
		type: String,
		required: true,
	},
	department: {
		type: String,
		required: true,
	},
	section: {
		type: String,
		required: true,
	},
	enrolledSubjects: [
		{
			id: { type: mongoose.Schema.Types.ObjectId, ref: "Subject" },
		},
	],
	enrolled: {
		type: Boolean,
		default: false,
	},
	image: {
		type: String,
		required: true,
	},
});

const Student = mongoose.model("Student", studentSchema);
module.exports = Student;
