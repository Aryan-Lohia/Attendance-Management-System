const express = require("express");
const router = express.Router();
const spawn = require("child_process").spawn;
const pythonProcess = spawn("python", ["../scripts/app.py"]);
router.get("/get", (req, res) => {
	try {
		pythonProcess.stdout.on("data", (data) => {
			console.log(data.toString());
			res.send(data.toString());
		});
	} catch (err) {
		console.log(err);
		res.send(err);
	}
});

module.exports = router;
