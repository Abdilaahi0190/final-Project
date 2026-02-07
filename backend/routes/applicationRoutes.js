const express = require('express');
const router = express.Router();
const { applyToJob, getUserApplications, getJobApplications } = require('../controllers/applicationController');
const { verifyToken, isAdmin } = require('../middleware/authMiddleware');

// Seeker Routes ama Qofka shaqda codsanaya routeds kiisa waye
router.post('/apply', verifyToken, applyToJob);
router.get('/my-applications', verifyToken, getUserApplications);

// Admin Routes 
router.get('/job/:jobId', verifyToken, isAdmin, getJobApplications);

module.exports = router;
