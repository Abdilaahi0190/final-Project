require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../models/User');

async function seedUser() {
    try {
        await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/JobPortal');

        const userEmail = 'user@jobquest.com';
        const existingUser = await User.findOne({ email: userEmail });

        if (existingUser) {
            console.log('User already exists');
            console.log('Email:', userEmail);
            // We assume password is 'user123' if it exists from this script, 
            // but we can't be 100% sure if changed manually. 
            // For now, we just report it exists.
        } else {
            const user = new User({
                email: userEmail,
                password: 'user123',
                role: 'job_seeker'
            });

            await user.save();
            console.log('Job Seeker user created successfully');
            console.log('Email:', userEmail);
            console.log('Password: user123');
        }
        process.exit(0);
    } catch (err) {
        console.error('Error seeding user:', err);
        process.exit(1);
    }
}

seedUser();
