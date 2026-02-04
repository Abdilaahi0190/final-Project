const Job = require('../models/Job');

const getJobs = async (req, res) => {
    try {
        const jobs = await Job.find().sort({ createdAt: -1 });
        res.json(jobs);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching jobs', error: error.message });
    }
};

const createJob = async (req, res) => {
    try {
        const job = new Job(req.body);
        await job.save();
        res.status(201).json(job);
    } catch (error) {
        res.status(500).json({ message: 'Error creating job', error: error.message });
    }
};

const seedJobs = async (req, res) => {
    try {
        const count = await Job.countDocuments();
        if (count > 0) return res.json({ message: 'Jobs already seeded' });

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
        res.status(201).json({ message: 'Jobs seeded successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error seeding jobs', error: error.message });
    }
};

const updateJob = async (req, res) => {
    try {
        const { id } = req.params;
        const job = await Job.findByIdAndUpdate(id, req.body, { new: true });
        if (!job) return res.status(404).json({ message: 'Job not found' });
        res.status(200).json(job);
    } catch (error) {
        res.status(500).json({ message: 'Error updating job', error: error.message });
    }
};

const deleteJob = async (req, res) => {
    try {
        const { id } = req.params;
        const job = await Job.findByIdAndDelete(id);
        if (!job) return res.status(404).json({ message: 'Job not found' });
        res.status(200).json({ message: 'Job deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting job', error: error.message });
    }
};

module.exports = { getJobs, createJob, seedJobs, updateJob, deleteJob };
