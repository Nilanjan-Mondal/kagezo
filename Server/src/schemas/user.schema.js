const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema({
    userName: { 
        type: String,
        required: [true, "Username is required"],
        unique: [true, "Username is already taken"],
        trim: true,
        lowercase: true,
        minlength: [3, "Username must be at least 3 characters long"],
        maxlength: [20, "Username must be at most 20 characters long"]
    },
    password: { 
        type: String, 
        required: [true, "Password is required"],
        minlength: [8, "Password must be at least 8 characters long"],
        trim: true
    }
});


const user = mongoose.model("User", userSchema) 

module.exports = user;
