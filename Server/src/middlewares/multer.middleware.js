const multer = require('multer');
const path = require('path');

const storageConfig = multer.diskStorage({
    destination: (req, file, next) => {
        next(null, 'uploads/'); // Store files in 'uploads/' folder
    },
    filename: (req, file, next) => {
        console.log(file);
        next(null, `${Date.now()}${path.extname(file.originalname)}`); 
    }
});

const fileFilter = (req, file, next) => {
    const allowedTypes = ["image/jpeg", "image/png", "image/gif", "application/zip"];

    if (allowedTypes.includes(file.mimetype)) {
        next(null, true);
    } else {
        next(new Error("Only images and ZIP files are allowed"), false);
    }
};

const uploader = multer({ 
    storage: storageConfig,
    fileFilter: fileFilter
});

module.exports = uploader;
