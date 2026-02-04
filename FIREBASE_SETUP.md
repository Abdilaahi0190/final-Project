# Firebase Configuration Guide

## Talaabooyinka Firebase-ka Si Loo Diyaariyo

### 1. Samee Firebase Project

1. Tag [Firebase Console](https://console.firebase.google.com/)
2. Guji **"Add project"** ama **"Create a project"**
3. Geli magaca project-kaaga (tusaale: "Job Portal")
4. Raaci talaabooyinka (Google Analytics waa ikhtiyaar)

### 2. Android Configuration

#### A. Ku dar Android App
1. Firebase Console, guji Android icon (🤖)
2. Geli **Android package name**: `com.example.finalapp`
3. Download `google-services.json` file-ka
4. Geli file-ka meeshan: `android/app/google-services.json`

#### B. Update Android Files

**File: `android/build.gradle`**
```gradle
buildscript {
    dependencies {
        // Ku dar linkan
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**File: `android/app/build.gradle`**
```gradle
// Ku dar meesha ugu horaysa
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

// Ku dar meesha ugu dambaysa
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 21  // Hubso in ay tahay 21 ama wax ka weyn
    }
}
```

### 3. iOS Configuration (Ikhtiyaar - haddii aad iOS isticmaalayso)

1. Firebase Console, guji iOS icon (🍎)
2. Geli **iOS bundle ID**: `com.example.finalapp`
3. Download `GoogleService-Info.plist`
4. Xcode-ka ku fur `ios/Runner.xcworkspace`
5. Drag & drop `GoogleService-Info.plist` into `Runner` folder

### 4. Enable Firebase Authentication

1. Firebase Console, tag **Authentication**
2. Guji **"Get Started"**
3. Tag **"Sign-in method"** tab
4. Enable **"Email/Password"**
5. Guji **"Save"**

### 5. Test the App

```bash
flutter run
```

## Troubleshooting

### Haddii aad aragto "No Firebase App"
- Hubso in `google-services.json` uu ku jiro `android/app/`
- Hubso in `apply plugin: 'com.google.gms.google-services'` uu ku jiro `android/app/build.gradle`

### Haddii aad aragto "minSdkVersion" error
- Fur `android/app/build.gradle`
- Beddel `minSdkVersion` to `21` ama wax ka weyn

### Haddii aad aragto "Multidex" error
- Ku dar `multiDexEnabled true` in `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        multiDexEnabled true
    }
}
```

## Macluumaad Dheeraad Ah

- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
