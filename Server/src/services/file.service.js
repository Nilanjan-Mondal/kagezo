const { saveFile, updateFileData, deleteFileData, findFileByUserAndNameAndPath } = require("../repositories/file.repository");
const { findUser } = require("../repositories/user.repository");
const cloudinary = require("../configs/cloudinary.config");
const fs = require("fs");
const path = require("path");

const createFile = async (file, body) => {
    const user = await findUser(body.userName);
    if (!user) throw { reason: "User not found", statusCode: 404 };

    const fileData = {
        filePath: file.path,
        fileName: body.fileName,
        directoryStructure: body.directoryStructure || "default",
        userId: user._id
    };

    // Upload file to Cloudinary
    const cloudinaryResponse = await cloudinary.uploader.upload(fileData.filePath, {
        resource_type: path.extname(fileData.filePath).toLowerCase() === ".zip" ? "raw" : "auto"
    });

    // Delete file after upload
    setTimeout(async () => {
        try {
            await fs.promises.unlink(fileData.filePath);
        } catch (unlinkError) {
            console.error(`Failed to delete file: ${fileData.filePath}`, unlinkError);
        }
    }, 2000);

    return saveFile({
        fileUrl: cloudinaryResponse.secure_url,
        fileName: fileData.fileName,
        directoryStructure: fileData.directoryStructure,
        userId: fileData.userId
    });
};

const updateFile = async (newFile, userName, fileName, directoryStructure) => {
    const user = await findUser(userName);
    if (!user) throw { reason: "User not found", statusCode: 404 };

    const existingFile = await findFileByUserAndNameAndPath(user._id, fileName, directoryStructure);
    if (!existingFile) throw { reason: "File not found", statusCode: 404 };

    // Delete the old file from Cloudinary
    const oldFileUrl = existingFile.fileUrl;
    const oldFilePublicId = oldFileUrl.split("/").pop().split(".")[0]; // Extract public ID
    await cloudinary.uploader.destroy(oldFilePublicId);

    // Upload new file to Cloudinary
    const cloudinaryResponse = await cloudinary.uploader.upload(newFile.path, {
        resource_type: path.extname(newFile.path).toLowerCase() === ".zip" ? "raw" : "auto"
    });

    // Delete the local file after upload
    setTimeout(async () => {
        try {
            await fs.promises.unlink(newFile.path);
        } catch (unlinkError) {
            console.error(`Failed to delete file: ${newFile.path}`, unlinkError);
        }
    }, 2000);

    return updateFileData(existingFile._id, { fileUrl: cloudinaryResponse.secure_url });
};

const deleteFile = async (userName, fileName, directoryStructure) => {
    const user = await findUser(userName);
    if (!user) throw { reason: "User not found", statusCode: 404 };

    const file = await findFileByUserAndNameAndPath(user._id, fileName, directoryStructure);
    if (!file) throw { reason: "File not found", statusCode: 404 };

    // Delete file from Cloudinary
    const filePublicId = file.fileUrl.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(filePublicId);

    return deleteFileData(file._id);
};

module.exports = { createFile, updateFile, deleteFile };
