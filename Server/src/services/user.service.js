const { createUser, findUser } = require("../repositories/user.repository");

const registerUser = async (userDetails) => {
    user = await findUser(userDetails.userName);
        if (user) {
            throw {
                reason: "User already exists with this username",
                statusCode: 400
            };
        }
        const newUser = await createUser({
            userName: userDetails.userName,
            password: userDetails.password
        });
        if (!newUser) {
            throw {
                reason: "User registration failed",
                statusCode: 500
            };
        }
        return newUser;
}

module.exports = { registerUser };