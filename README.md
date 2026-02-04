# Job Portal App - Quick Start Guide

## ✅ App-ka Hadda Waa Diyaar!

Waxaan sameeyay **simple version** oo aan u baahnayn Firebase, si aad si degdeg ah u aragto app-ka.

## 🚀 Sida Loo Bilaabo

### Option 1: Run on Android/iOS Emulator (RECOMMENDED)

```bash
# 1. Fur Android Emulator ama iOS Simulator
# 2. Run app-ka
flutter run
```

### Option 2: Run on Windows (Requires Developer Mode)

Windows waxay u baahan tahay **Developer Mode** si ay u shaqayso Flutter apps.

**Enable Developer Mode:**
1. Fur **Settings**
2. Tag **Privacy & Security** → **For developers**
3. Daar **Developer Mode** ON
4. Restart computer-kaaga

Kadibna:
```bash
flutter run -d windows
```

### Option 3: Run on Chrome (Web - Easiest!)

```bash
flutter run -d chrome
```

## 📱 Screens

1. **Login Screen** - Geli email iyo password (wax walba waa la aqbali doonaa)
2. **Register Screen** - Samee akoon cusub
3. **Home Screen** - Arag 5 shaqo oo Somali ah

## 🎨 Features

- ✅ Premium design oo qurux badan
- ✅ Gradient backgrounds
- ✅ Job listings oo leh faahfaahin
- ✅ Search bar (UI ready)
- ✅ Job details bottom sheet
- ✅ Apply button

## 🔥 Firebase Version (Optional)

Haddii aad rabto Firebase Authentication:
1. Eeg `FIREBASE_SETUP.md`
2. Beddel `main.dart` to use Firebase version
3. Use `login_screen.dart` instead of `login_screen_simple.dart`

## 📝 Files Structure

```
lib/
├── main.dart                          # Simple version (NO Firebase)
├── screens/
│   ├── login_screen_simple.dart       # Login (NO Firebase)
│   ├── register_screen_simple.dart    # Register (NO Firebase)
│   ├── home_screen_simple.dart        # Home (NO Firebase)
│   ├── login_screen.dart              # Login (WITH Firebase)
│   ├── register_screen.dart           # Register (WITH Firebase)
│   └── home_screen.dart               # Home (WITH Firebase)
├── services/
│   └── auth_service.dart              # Firebase Auth
├── models/
│   └── job_model.dart                 # Job model
└── data/
    └── sample_jobs.dart               # Sample jobs
```

## ⚠️ Troubleshooting

### "Building with plugins requires symlink"
- Enable Developer Mode on Windows (see above)
- Or run on Chrome/Android instead

### "No devices found"
- Run `flutter devices` to see available devices
- Start an emulator or enable web

### Analysis issues
- Ignore them for now - they're just warnings
- App will still run fine

## 🎯 Test Credentials

Wax walba waa la aqbali doonaa! Just geli:
- **Email**: test@example.com
- **Password**: 123456

## 📞 Need Help?

Haddii app-ku uusan shaqaynin, ii sheeg:
1. What command did you run?
2. What error message did you see?
3. What device/platform are you using?
