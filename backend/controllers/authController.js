const jwt = require('jsonwebtoken');
const User = require('../models/User');

/**
 * Qeybta diwangalinat aama registration ka
 */
const signup = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Qeybt avalidationska 
        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        if (password.length < 6) {
            return res.status(400).json({ message: 'Password must be at least 6 characters long' });
        }

        const existingUser = await User.findOne({ email });
        if (existingUser) return res.status(400).json({ message: 'A user with this email already exists' });

        const user = new User({ email, password });
        await user.save();

        const token = jwt.sign(
            { userId: user._id, role: user.role },
            process.env.JWT_SECRET || 'jobquest_super_secret_key_2026',
            { expiresIn: '7d' }
        );
        res.status(201).json({ token, email: user.email, role: user.role, message: 'Registration successful' });
    } catch (error) {
        console.error('Signup Error:', error);
        res.status(500).json({ message: 'An error occurred during registration. Please try again.' });
    }
};

/**
 * Authenticate users ka iyo tokenba 
 */
const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Please provide both email and password' });
        }

        const user = await User.findOne({ email });
        if (!user || !(await user.comparePassword(password))) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }

        const token = jwt.sign(
            { userId: user._id, role: user.role },
            process.env.JWT_SECRET || 'jobquest_super_secret_key_2026',
            { expiresIn: '7d' }
        );
        res.status(200).json({ token, email: user.email, role: user.role, message: 'Login successful' });
    } catch (error) {
        console.error('Login Error:', error);
        res.status(500).json({ message: 'An error occurred during login. Please try again.' });
    }
};

/**
 * Dhamaan User ka Qeybtaan wa un adminka kaliya arki karo 
 */
const getUsers = async (req, res) => {
    try {
        const users = await User.find().select('-password');
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching users' });
    }
};

/**
 * Update lagu sameyo user ka (Admin only)
 */
const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { email, role } = req.body;

        const updateData = {};
        if (role) {
            if (!['job_seeker', 'admin'].includes(role)) {
                return res.status(400).json({ message: 'Invalid role' });
            }
            updateData.role = role;
        }

        if (email) {
            const existingUser = await User.findOne({ email, _id: { $ne: id } });
            if (existingUser) {
                return res.status(400).json({ message: 'Email is already in use' });
            }
            updateData.email = email;
        }

        if (req.body.password && req.body.password.length >= 6) {
            const userToUpdate = await User.findById(id);
            if (!userToUpdate) return res.status(404).json({ message: 'User not found' });

            if (role) userToUpdate.role = role;
            if (email) userToUpdate.email = email;
            userToUpdate.password = req.body.password;  

            await userToUpdate.save();
            const user = userToUpdate.toObject();
            delete user.password;
            return res.status(200).json(user);
        }

        const user = await User.findByIdAndUpdate(id, updateData, { new: true }).select('-password');
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json(user);
    } catch (error) {
        console.error('Update User Error:', error);
        res.status(500).json({ message: 'Error updating user' });
    }
};

/**
 * Delete ama la tiro usr kaliya admin (Admin only)
 */
const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        await User.findByIdAndDelete(id);
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting user' });
    }
};

/**
 * Create new user ma diwnalgint auser ka aydo frontend lag so xareynyo  (Admin only)
 */
const createUser = async (req, res) => {
    try {
        const { email, password, role } = req.body;
        if (!email || !password) return res.status(400).json({ message: 'Email and password are required' });

        const existingUser = await User.findOne({ email });
        if (existingUser) return res.status(400).json({ message: 'User already exists' });

        const user = new User({ email, password, role: role || 'job_seeker' });
        await user.save();
        res.status(201).json({ message: 'User created successfully', user: { email: user.email, role: user.role } });
    } catch (error) {
        res.status(500).json({ message: 'Error creating user', error: error.message });
    }
};

module.exports = { signup, login, getUsers, updateUser, deleteUser, createUser };
