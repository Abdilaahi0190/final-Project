require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const jobRoutes = require('./routes/jobRoutes');
const userRoutes = require('./routes/userRoutes');
const applicationRoutes = require('./routes/applicationRoutes');
const Job = require('./models/Job');

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// Connect to Database and Seed Initial Data
connectDB().then(async () => {
    try {
        const count = await Job.countDocuments();
        if (count === 0) {
            const initialJobs = [
                {
                    title: 'Flutter Developer',
                    company: 'Tech Solutions',
                    salary: '$4,000 - $6,000',
                    type: 'Full-time',
                    location: 'Remote',
                    description: 'We are looking for an experienced Flutter developer to join our mobile team.',
                    logo: 'code',
                    color: '0xFF2196F3'
                },
                {
                    title: 'Backend Engineer',
                    company: 'Data Flows',
                    salary: '$5,000 - $8,000',
                    type: 'Full-time',
                    location: 'New York, US',
                    description: 'Join our backend team to build scalable APIs using Node.js and MongoDB.',
                    logo: 'storage',
                    color: '0xFF4CAF50'
                },
                {
                    title: 'UI/UX Designer',
                    company: 'Creative Studio',
                    salary: '$3,500 - $5,000',
                    type: 'Contract',
                    location: 'London, UK',
                    description: 'Design beautiful interfaces for our various clients around the world.',
                    logo: 'brush',
                    color: '0xFFE91E63'
                }
            ];
            await Job.insertMany(initialJobs);
            console.log('Initial jobs seeded successfully');
        }
    } catch (err) {
        console.error(' Error seeding jobs:', err);
    }
});

// API Routes
app.get('/api/ping', (req, res) => res.json({ message: 'Server is running!', db: 'JobPortal' }));
app.use('/api', authRoutes);
app.use('/api/jobs', jobRoutes);
app.use('/api/users', userRoutes);
app.use('/api/applications', applicationRoutes);

// Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(` Server running on port ${PORT}`);
});
