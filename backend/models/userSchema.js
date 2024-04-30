const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const userSchema = new mongoose.Schema({
	user_type: {
		type: String,
		enum: ["admin", "faculty", "student"],
		required: true,
	},
	name: { type: String, required: true },
	password: { type: String, required: true, select: false },
	uid: { type: String, required: true, unique: true },
	// ... other user-specific fields
});
userSchema.pre("save", async function (next) {
	if (!this.isModified("password")) return next();
	const salt = await bcrypt.genSalt();
	this.password = await bcrypt.hash(this.password, salt);
	this.passwordConfirm = undefined;
	next();
});

userSchema.methods.correctPassword = async function (
	candidatePassword,
	userPassword
) {
	return await bcrypt.compare(candidatePassword, userPassword);
};

const User = mongoose.model("User", userSchema);
module.exports = User;
