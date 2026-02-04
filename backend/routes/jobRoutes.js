const express = require('express');
const router = express.Router();
const { getJobs, createJob, seedJobs, updateJob, deleteJob } = require('../controllers/jobController');
const { verifyToken, isAdmin } = require('../middleware/authMiddleware');

router.get('/', getJobs);
router.post('/', verifyToken, isAdmin, createJob);
router.put('/:id', verifyToken, isAdmin, updateJob);
router.delete('/:id', verifyToken, isAdmin, deleteJob);
router.post('/seed', verifyToken, isAdmin, seedJobs);

module.exports = router;
