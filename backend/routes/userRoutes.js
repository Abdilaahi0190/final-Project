const express = require('express');
const router = express.Router();
const { getUsers, updateUser, deleteUser, createUser } = require('../controllers/authController');
const { verifyToken, isAdmin } = require('../middleware/authMiddleware');

// All user management routes require Admin privileges
router.use(verifyToken);
router.use(isAdmin);

router.get('/', getUsers);
router.post('/', createUser);
router.put('/:id', updateUser);
router.delete('/:id', deleteUser);

module.exports = router;
