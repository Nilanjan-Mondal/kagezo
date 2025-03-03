const { findFileByUserId } = require("../repositories/file.repository");
const { findUser } = require("../repositories/user.repository");
const { createFile, updateFile, deleteFile } = require("../services/file.service");

const uploadFile = async (req, res) => {
    try {
        if (!req.body.event || !req.body.userName) {
            return res.status(400).json({ error: "Missing event type or username" });
        }

        const event = req.body.event.toLowerCase();

        if (event === "create") {
            if (!req.file) return res.status(400).json({ error: "File is required for creation" });

            const savedFile = await createFile(req.file, req.body);
            return res.status(201).json({
                message: "File uploaded successfully",
                success: true,
                data: savedFile
            });

        } else if (event === "modify") {
            if (!req.file || !req.body.fileName || !req.body.userName || !req.body.directoryStructure) {
                return res.status(400).json({ error: "New file and fileName are required for update" });
            }

            const updatedFile = await updateFile(req.file, req.body.userName, req.body.fileName, req.body.directoryStructure);
            return res.status(200).json({
                message: "File updated successfully",
                success: true,
                data: updatedFile
            });

        } else if (event === "purge") {
            if (!req.body.fileName) {
                return res.status(400).json({ error: "fileName is required for deletion" });
            }

            const deletedFile = await deleteFile(req.body.userName, req.body.fileName, req.body.directoryStructure);
            return res.status(200).json({
                message: "File deleted successfully",
                success: true,
                data: deletedFile
            });

        } else {
            return res.status(400).json({ error: "Invalid event type" });
        }
    } catch (error) {
        console.error("Upload error:", error);
        return res.status(error.statusCode || 500).json({
            message: error.reason || "An unexpected error occurred",
            success: false,
            error
        });
    }
};

const getUserFiles = async (req, res) => {
    try {
        const { userName } = req.body;
        if (!userName) {
            return res.status(400).json({ error: "Username is required" });
        }

        const user = await findUser(userName);
        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        const userFiles = await findFileByUserId(user._id);

        return res.status(200).json({
            message: "User files retrieved successfully",
            success: true,
            data: userFiles
        });
    } catch (error) {
        console.error("Error in getUserFiles:", error);
        return res.status(500).json({
            message: "Failed to retrieve user files",
            success: false,
            error
        });
    }
};

module.exports = { uploadFile, getUserFiles };
