# Firebase Setup Guide for "on brand" App

## Overview
This guide will walk you through setting up Firebase for the "on brand" influencer deals app with separate development, staging, and production environments.

## Prerequisites
- Google account
- Access to Firebase Console
- Xcode project ready for Firebase integration

## Step 1: Create Firebase Projects

### 1.1 Development Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. **Project Name**: `on-brand-app-dev`
4. **Project ID**: `on-brand-app-dev` (or similar if taken)
5. **Analytics**: Enable Google Analytics
6. **Analytics Account**: Create new account or use existing
7. Click "Create project"

### 1.2 Staging Project
1. Click "Add project" or "Create a project"
2. **Project Name**: `on-brand-app-staging`
3. **Project ID**: `on-brand-app-staging`
4. **Analytics**: Enable Google Analytics
5. **Analytics Account**: Use same account as development
6. Click "Create project"

### 1.3 Production Project
1. Click "Add project" or "Create a project"
2. **Project Name**: `on-brand-app-prod`
3. **Project ID**: `on-brand-app-prod`
4. **Analytics**: Enable Google Analytics
5. **Analytics Account**: Use same account as development
6. Click "Create project"

## Step 2: Configure iOS Apps

### 2.1 Development App
1. In `on-brand-app-dev` project:
2. Click "Add app" → iOS
3. **iOS bundle ID**: `com.yourcompany.onbrand.dev`
4. **App nickname**: "on brand Dev"
5. **App Store ID**: Leave blank for now
6. Click "Register app"
7. Download `GoogleService-Info.plist` → Save as `GoogleService-Info-Dev.plist`

### 2.2 Staging App
1. In `on-brand-app-staging` project:
2. Click "Add app" → iOS
3. **iOS bundle ID**: `com.yourcompany.onbrand.staging`
4. **App nickname**: "on brand Staging"
5. **App Store ID**: Leave blank for now
6. Click "Register app"
7. Download `GoogleService-Info.plist` → Save as `GoogleService-Info-Staging.plist`

### 2.3 Production App
1. In `on-brand-app-prod` project:
2. Click "Add app" → iOS
3. **iOS bundle ID**: `com.yourcompany.onbrand`
4. **App nickname**: "on brand"
5. **App Store ID**: Leave blank for now
6. Click "Register app"
7. Download `GoogleService-Info.plist` → Save as `GoogleService-Info-Prod.plist`

## Step 3: Enable Firebase Services

### 3.1 Authentication
For each project (dev, staging, prod):
1. Go to "Authentication" → "Sign-in method"
2. Enable "Apple" provider
3. Configure Apple Sign-In settings
4. Enable "Email/Password" (for admin purposes)

### 3.2 Firestore Database
For each project:
1. Go to "Firestore Database"
2. Click "Create database"
3. **Security rules**: Start in test mode (we'll configure later)
4. **Location**: Choose closest to your users (us-central1 for US)

### 3.3 Firebase Storage
For each project:
1. Go to "Storage"
2. Click "Get started"
3. **Security rules**: Start in test mode (we'll configure later)
4. **Location**: Same as Firestore

### 3.4 Analytics & Crashlytics
For each project:
1. Go to "Analytics" → "Events"
2. Verify analytics is enabled
3. Go to "Crashlytics" → "Get started"
4. Enable Crashlytics

## Step 4: Configure Security Rules

### 4.1 Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Deals are stored under user's collection
      match /deals/{dealId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 4.2 Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can only access their own files
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 5: Configure Push Notifications

### 5.1 APNs Configuration
For each project:
1. Go to "Project Settings" → "Cloud Messaging"
2. Upload your APNs certificate or key
3. Configure APNs settings for development/production

## Step 6: Environment Configuration

### 6.1 Xcode Project Setup
1. Add all three `GoogleService-Info.plist` files to Xcode
2. Configure build schemes for each environment
3. Set up proper bundle identifiers

### 6.2 Build Configuration
- **Development**: Uses `GoogleService-Info-Dev.plist`
- **Staging**: Uses `GoogleService-Info-Staging.plist`
- **Production**: Uses `GoogleService-Info-Prod.plist`

## Next Steps
After completing this setup:
1. Firebase SDK integration in Xcode
2. Authentication service implementation
3. Firestore data models
4. Real-time synchronization
5. Push notifications setup
6. Testing and validation

## Security Considerations
- Never commit `GoogleService-Info.plist` files to version control
- Use environment-specific configurations
- Implement proper security rules
- Regular security audits

## Support
If you encounter any issues during setup, refer to:
- [Firebase iOS Setup Documentation](https://firebase.google.com/docs/ios/setup)
- [Firebase Console Help](https://support.google.com/firebase/)
- This guide's troubleshooting section

