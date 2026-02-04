const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/JobPortal';
        console.log(`Connecting to MongoDB at: ${MONGODB_URI}`);
        await mongoose.connect(MONGODB_URI);
        console.log('Connected to MongoDB successfully');
    } catch (err) {
        console.error('MongoDB connection error details:', err.message);
        console.error('Make sure your local MongoDB server is running or check your MONGODB_URI in .env');
        process.exit(1);
    }
};

module.exports = connectDB;
