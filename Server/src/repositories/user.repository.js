const user = require("../schemas/user.schema");

const findUser = async (userName) => {
    try {
        const response = await user.findOne({ userName });
        return response;
    } catch (error) {
        console.error("Database Error:", error);
        throw new Error("Database operation failed");
    }
}

const createUser = async(userDetails) => {
    try {
        return await user.create(userDetails);
    } catch (error) {
        console.error("Database Error:", error);
        throw new Error("Database operation failed");
    }
}

module.exports = { createUser, findUser };