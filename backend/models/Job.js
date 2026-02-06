const mongoose = require('mongoose');

/**
 * Job Schema - Represents a job posting in the system
 */
const jobSchema = new mongoose.Schema({
    title: { type: String, required: true },
    company: { type: String, required: true },
    salary: { type: String, required: true },
    type: { type: String, required: true }, // e.g., Full-time, Remote
    location: { type: String, required: true },
    description: { type: String, required: true },
    logo: { type: String, default: 'work' }, // Icon name used in Flutter
    color: { type: String, default: '0xFF667eea' }, // Branding color
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Job', jobSchema);
