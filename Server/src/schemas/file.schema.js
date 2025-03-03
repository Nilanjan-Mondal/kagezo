const mongoose = require("mongoose");

const fileSchema = new mongoose.Schema({
    userId: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "User",
        required: true 
    },
    fileUrl: { 
        type: String,
         required: true
     },
    fileName: { 
        type: String,
         required: true
     },
    directoryStructure: { 
        type: String,
         required: true
    }
});

const file = mongoose.model("File", fileSchema);

module.exports = file;
