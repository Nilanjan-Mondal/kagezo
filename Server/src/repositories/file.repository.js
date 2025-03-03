const File = require("../schemas/file.schema");

const saveFile = async (fileDetails) => {
    try {
        return await File.create(fileDetails);
    } catch (error) {
        console.error("Database Error:", error);
        throw new Error("Database operation failed");
    }
};

module.exports = { saveFile };