const dotenv = require('dotenv');
dotenv.config(); // ✅ Load environment variables first

module.exports = {
    PORT: process.env.PORT,
    DB_URL: process.env.DB_URL,
    CLOUDINARY_CLOUD_NAME: process.env.CLOUDINARY_CLOUD_NAME,
    CLOUDINARY_API_KEY: process.env.CLOUDINARY_API_KEY,
    CLOUDINARY_API_SECRET: process.env.CLOUDINARY_API_SECRET
};