const { uploadToCloudinary } = require("../services/file.service");
const { findUser } = require("../repositories/user.repository");


const uploadFile = async (req, res) => {
    try {
        if (!req.file || !req.body.userName) {
            return res.status(400).json({ error: "Missing file or username" });
        }

        const user = await findUser(req.body.userName);
        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        const fileData = {
            filePath: req.file.path,
            fileName: req.body.fileName,
            directoryStructure: req.body.directoryStructure || "default",
            userId: user._id
        };

        console.log("fileData:   ", fileData);

        const savedFile = await uploadToCloudinary(fileData);

        return res.status(201).json({
            message: "File uploaded successfully",
            success: true,
            data: savedFile
        });
    } catch (error) {
        console.error("Upload error:", error);
        return res.status(error.statusCode || 500).json({
            message: error.reason || "An unexpected error occurred",
            success: false,
            error
        });
    }
};

module.exports = {uploadFile};
