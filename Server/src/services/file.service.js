const { saveFile } = require("../repositories/file.repository");
const cloudinary = require("../configs/cloudinary.config");
const fs = require("fs");
const path = require("path");

const uploadToCloudinary = async (fileDetails) => {
    const filePath = fileDetails.filePath;
    let cloudinaryFileUrl = "";

    if (filePath) {
        try { 
            const isZip = path.extname(filePath).toLowerCase() === ".zip";

            const cloudinaryResponse = await cloudinary.uploader.upload(filePath, {
                resource_type: isZip ? "raw" : "auto"
            });

            cloudinaryFileUrl = cloudinaryResponse.secure_url;
            console.log("Cloudinary response:", cloudinaryResponse);

            // Ensure file is deleted after upload
            setTimeout(async () => {
                try {
                    await fs.promises.unlink(filePath);
                    console.log(`File deleted successfully: ${filePath}`);
                } catch (unlinkError) {
                    console.error(`Failed to delete file: ${filePath}`, unlinkError);
                }
            }, 2000); // Delay to ensure Cloudinary has fully processed it

        } catch (error) {
            console.log("Cloudinary upload failed:", error);
            throw {
                reason: "File not uploaded to Cloudinary",
                statusCode: 500
            };
        }
    }

    // Save file with user reference
    const file = await saveFile({
        fileUrl: cloudinaryFileUrl,
        fileName: fileDetails.fileName,
        directoryStructure: fileDetails.directoryStructure,
        userId: fileDetails.userId
    });

    if (!file) {
        throw {
            reason: "File not saved in database",
            statusCode: 500
        };
    }

    return file;
};

module.exports = { uploadToCloudinary };
