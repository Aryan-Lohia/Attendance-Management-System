const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const subjectSchema = new Schema({
	subject_name: { type: String, required: true },
	subject_code: { type: String, required: true },
	semester: { type: String, required: true },
	department: { type: String, required: true },
	section: { type: String, required: true },
	facultyId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: "User",
		required: true,
	},
	classesTaken: {
		type: Number,
		default: 0,
	},
	uid: {
		type: String,
		required: true,
		unique: true,
	},
});

const Subject = mongoose.model("Subject", subjectSchema);
module.exports = Subject;
