const express = require("express");
const { uploadFile } = require("../controllers/file.controller");

const uploader = require("../middlewares/multer.middleware");

const router = express.Router();

router.post("/upload", uploader.single("file"), uploadFile);

module.exports = router;