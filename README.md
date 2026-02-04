# JobQuest - Professional Job Portal

JobQuest is a modern, high-performance job portal application built with Flutter and a Node.js/MongoDB backend. It offers a seamless experience for both employers and job seekers with a premium design and robust functionality.

## 🚀 Key Features

- **User Authentication**: Secure Login and Registration with role-based access (Job Seeker & Admin).
- **Admin Dashboard**: Full CRUD capabilities for managing job listings and user accounts.
- **Job Discovery**: Browse latest jobs with a clean, intuitive interface.
- **Responsive Design**: Premium UI with gradients, smooth transitions, and optimized layouts for all devices.
- **Real-time State Management**: Powered by GetX for a reactive and snappy user experience.
- **Secure Backend**: Built with Node.js, Express, and MongoDB for scalable and reliable data management.

## 🛠️ Technology Stack

- **Frontend**: Flutter, GetX, Google Fonts
- **Backend**: Node.js, Express.js
- **Database**: MongoDB (Mongoose)
- **API**: RESTful API with JWT Authentication

## 📱 Getting Started

### Prerequisites

- Flutter SDK (Latest stable version recommended)
- Node.js & npm
- MongoDB (Running locally or via Atlas)

### Backend Setup

1. Navigate to the `backend` directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure your `.env` file with your MongoDB URI and JWT Secret.
4. Start the server:
   ```bash
   node index.js
   ```

### Flutter App Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

- `lib/screens/`: UI components organized by feature (Auth, Admin, Job Seeker).
- `lib/controllers/`: Business logic and state management using GetX.
- `lib/services/`: API communication layer.
- `lib/models/`: Data models for Jobs and Users.
- `backend/`: Node.js server scripts and API routes.

## 🔒 Admin Controls

Admin users have exclusive access to:
- **Manage Jobs**: Create, update, or delete job postings.
- **Manage Users**: View and edit user roles and permissions.

---
Built with ❤️ for a better job hunting experience.
