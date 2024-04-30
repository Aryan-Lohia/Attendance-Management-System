const User = require("../models/userSchema");
const jwt = require("jsonwebtoken");

exports.register = async (req, res) => {
	try {
		const { userType, name, password, uid } = req.body;
		const user = await User.findOne({ uid: uid });
		if (user) {
			return res.status(400).json({ error: "User already exists" });
		}
		const newUser = await User.create({
			user_type: userType,
			name: name,
			password: password,
			uid: uid,
		});
		res.status(201).json({ status: "success" });
	} catch (err) {
		console.log(err);
		res.status(400).json({ error: err.message });
	}
};

exports.login = async (req, res) => {
	try {
		const { uid, password } = req.body;

		const user = await User.findOne({ uid: uid }).select("+password");

		if (!user) {
			return res.status(400).json({ error: "User does not exist" });
		}
		const isMatch = await user.correctPassword(password, user.password);

		if (!isMatch) {
			return res.status(400).json({ error: "Incorrect Credentials" });
		}
		const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
			expiresIn: "90d",
		});
		const userObject = user.toObject();
		delete userObject.password;

		res.status(200).json({
			status: "success",
			data: { user: userObject, token: token },
		});
	} catch (err) {
		res.status(400).json({ error: err.message });
	}
};
