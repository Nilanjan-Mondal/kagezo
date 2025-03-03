const fs = require("fs").promises;
const path = require("path");
const os = require("os");
const { registerUser } = require("../services/user.service");

const USER_DATA_FILE = path.join(os.homedir(), ".local/share/kagezo/credential.txt");

const createUser = async (req, res) => {
    try {
        
        const fileContent = await fs.readFile(USER_DATA_FILE, "utf-8");
        
        // Split content by lines (assuming first line = username, second line = password)
        const lines = fileContent.split("\n").map(line => line.trim());
        
        // Ensure the file has at least 2 lines
        if (lines.length < 2) {
            throw new Error("Invalid file format: Must contain at least 2 lines (username, password)");
        }

        const userData = {
            userName: lines[0],
            password: lines[1]  
        };

        const response = await registerUser(userData);

        return res.status(201).json({
            message: "User created successfully",
            success: true,
            data: response,
            error: {}
        });
    } catch (error) {
        console.error("Error in createUser:", error);
        return res.status(error.statusCode || 500).json({
            message: error.message || "An unexpected error occurred",
            success: false,
            data: {},
            error
        });
    }
};

module.exports = { createUser };
