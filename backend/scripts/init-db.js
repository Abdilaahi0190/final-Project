require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../models/User');
const Job = require('../models/Job');

async function initialize() {
    const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/JobPortal';
    console.log(`Connecting to: ${MONGODB_URI}`);

    try {
        await mongoose.connect(MONGODB_URI);
        console.log('Connected to MongoDB!');

        // Create a dummy user to ensure 'users' collection exists
        const dummyEmail = `test_${Date.now()}@example.com`;
        await User.create({ email: dummyEmail, password: 'password123' });
        console.log(`User collection created with: ${dummyEmail}`);

        // Create a sample job
        await Job.create({
            title: 'Initial Database Setup Job',
            company: 'System',
            salary: 'N/A',
            type: 'System',
            location: 'Local',
            description: 'This job was created to initialize the database.',
            logo: 'work',
            color: '0xFF667eea'
        });
        console.log('Job collection created with sample job.');

        console.log('\nSUCCESS: Your database "JobPortal" should now be visible in MongoDB Compass!');
        process.exit(0);
    } catch (err) {
        console.error('Initialization failed:', err);
        process.exit(1);
    }
}

initialize();
