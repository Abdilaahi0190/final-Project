const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

/**
 * User Schema - Wana Role based oo admin iyo job-seaker ba lagu kala xadey aya 
 */
const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
        lowercase: true
    },
    password: {
        type: String,
        required: true,
        minlength: 6
    },
    role: {
        type: String,
        enum: ['job_seeker', 'admin'],
        default: 'job_seeker'
    }
});

// in passswordka hashed laga dhigo
userSchema.pre('save', async function () {
    if (this.isModified('password')) {
        this.password = await bcrypt.hash(this.password, 10);
    }
});

/**
 * Check ama la hubiyo hashed password ka 
 */
userSchema.methods.comparePassword = async function (password) {
    return await bcrypt.compare(password, this.password);
};

module.exports = mongoose.model('User', userSchema);
