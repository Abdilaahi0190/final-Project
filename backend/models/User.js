const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

/**
 * User Schema - Authenticable accounts with role-based access
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

// Automatically hash password before saving to DB
userSchema.pre('save', async function () {
    if (this.isModified('password')) {
        this.password = await bcrypt.hash(this.password, 10);
    }
});

/**
 * Compare plain text password with hashed DB version
 */
userSchema.methods.comparePassword = async function (password) {
    return await bcrypt.compare(password, this.password);
};

module.exports = mongoose.model('User', userSchema);
