const express = require("express");
const { uploadFile, getUserFiles } = require("../controllers/file.controller");

const uploader = require("../middlewares/multer.middleware");

const router = express.Router();

router.post("/upload", uploader.single("file"), uploadFile);
router.get("/get-files", getUserFiles);

module.exports = router;