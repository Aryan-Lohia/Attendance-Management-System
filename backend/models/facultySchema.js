const mongoose = require("mongoose");
const User = mongoose.model("User");

const facultySchema = new mongoose.Schema({
	facultyId: {
		type: mongoose.Schema.Types.ObjectId,
		ref: "User",
		required: true,
	},
	subjects: [
		{
			type: mongoose.Schema.Types.ObjectId,
			ref: "Subject",
		},
	],
});

const Faculty = mongoose.model("Faculty", facultySchema);
module.exports = Faculty;
