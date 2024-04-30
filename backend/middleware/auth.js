const jwt = require("jsonwebtoken");
const User = require("../models/userSchema");
const Student = require("../models/studentSchema");

require("dotenv").config();
exports.verifyToken = async (req, res, next) => {
	try {
		let token = req.headers["authorization"];

		if (!token) {
			return res.status(401).json({ error: "Authentication Failed" });
		}

		if (token.startsWith("Bearer")) {
			token = token.slice(7, token.length).trimLeft();
		}

		const verified = jwt.verify(token, process.env.JWT_SECRET);

		req.user = await User.findById(verified.id);

		next();
	} catch (err) {
		return res.status(401).json({ error: err });
	}
};

exports.checkToken = async (req, res) => {
	try {
		let token = req.headers["authorization"];

		if (!token) {
			return res
				.status(401)
				.json({ error: "Authentication Failed", data: false });
		}

		if (token.startsWith("Bearer")) {
			token = token.slice(7, token.length).trimLeft();
		}

		jwt.verify(token, process.env.JWT_SECRET, (err, res) => {
			if (err) {
				return res
					.status(401)
					.json({ error: "Authentication Failed", data: false });
			}
		});
		res.status(200).json({ data: true });
	} catch (err) {
		return res.status(401).json({ error: err, data: false });
	}
};
