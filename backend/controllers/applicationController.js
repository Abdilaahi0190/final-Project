const Application = require('../models/Application');

/**
 * Handle job application submission
 */
exports.applyToJob = async (req, res) => {
    try {
        const { jobId } = req.body;
        const applicantId = req.userId;

        // Verify if the user has already applied for this job
        const existingApp = await Application.findOne({ job: jobId, applicant: applicantId });
        if (existingApp) {
            return res.status(400).json({ message: 'You have already applied for this job' });
        }

        const application = new Application({
            job: jobId,
            applicant: applicantId
        });

        await application.save();
        res.status(201).json(application);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

/**
 * Fetch all applications for the logged-in seeker
 */
exports.getUserApplications = async (req, res) => {
    try {
        const applications = await Application.find({ applicant: req.userId })
            .populate('job')
            .sort({ appliedAt: -1 });
        res.json(applications);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

/**
 * Fetch all applications for a specific job (Admin only)
 */
exports.getJobApplications = async (req, res) => {
    try {
        const applications = await Application.find({ job: req.params.jobId })
            .populate('applicant', 'email')
            .sort({ appliedAt: -1 });
        res.json(applications);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};
