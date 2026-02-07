const Application = require('../models/Application');

/**
Qeybt aSahqoyinka laso codsay lagu handle gareynyo */
exports.applyToJob = async (req, res) => {
    try {
        const { jobId } = req.body;
        const applicantId = req.userId;

        // hubi hadi user kan uu shaqo horay u dalbay
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
 * dhamaan Job Seakers ka 
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
 * Dhamaan Codsiyada lasoo dirsday
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
