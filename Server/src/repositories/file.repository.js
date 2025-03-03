const File = require("../schemas/file.schema");

const saveFile = async (fileDetails) => {
    try {
        return await File.create(fileDetails);
    } catch (error) {
        console.error("Database Error:", error);
        throw new Error("Database operation failed");
    }
};

const updateFileData = async (fileId, updateData) => {
    try {
        const updatedFile = await File.findByIdAndUpdate(fileId, updateData, { new: true });
        if (!updatedFile) throw new Error("File not found");
        return updatedFile;
    } catch (error) {
        console.error("Database Error:", error);
        throw new Error("Database operation failed");
    }
};

const deleteFileData = async (fileId) => {
    try {
        const deletedFile = await File.findByIdAndDelete(fileId);
        if (!deletedFile) throw new Error("File not found");
        return deletedFile;
    } catch (error) {
        console.error("Database Error:", error);
        throw new Error("Database operation failed");
    }
};

const findFileByUserId = async (userId) => {
    try {
        return await File.find({ userId });
    } catch (error) {
        console.error("Database Error:", error);
        throw new Error("Database operation failed");
    }
};

const findFileByUserAndNameAndPath = async (userId, fileName, directoryStructure) => {
    try {
        return await File.findOne({ userId, fileName, directoryStructure });
    } catch (error) {
        console.error("Database Error:", error);
        throw {
            statusCode: 404,
            message: "File not found"
        }
    }
};

module.exports = { saveFile, updateFileData, deleteFileData, findFileByUserAndNameAndPath, findFileByUserId };
