# Firebase Integration Guide for "on brand" App

## Overview
This guide provides step-by-step instructions for integrating Firebase with the "on brand" influencer deals app, including real-time synchronization, cloud storage, and authentication.

## Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Firebase project created (see FIREBASE_SETUP_GUIDE.md)
- GoogleService-Info.plist files for each environment

## Step 1: Add Firebase SDK to Xcode Project

### 1.1 Add Firebase Dependencies
1. Open your Xcode project
2. Go to File → Add Package Dependencies
3. Add the following Firebase packages:
   - `https://github.com/firebase/firebase-ios-sdk`
4. Select the following products:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseStorage
   - FirebaseAnalytics
   - FirebaseCrashlytics
   - FirebaseCore

### 1.2 Add GoogleService-Info.plist Files
1. Drag the three `GoogleService-Info.plist` files into your Xcode project
2. Make sure they're added to the main app target
3. Verify the files are in the project bundle

### 1.3 Configure Build Schemes
1. Go to Product → Scheme → Edit Scheme
2. Create three schemes:
   - **Development**: Uses `GoogleService-Info-Dev.plist`
   - **Staging**: Uses `GoogleService-Info-Staging.plist`
   - **Production**: Uses `GoogleService-Info-Prod.plist`

## Step 2: Configure Bundle Identifiers

### 2.1 Update Bundle Identifiers
1. Go to Project Settings → Targets → on brand
2. Update bundle identifiers for each configuration:
   - **Development**: `com.pierson.on-brand.dev`
   - **Staging**: `com.pierson.on-brand.staging`
   - **Production**: `com.pierson.on-brand`

### 2.2 Update Info.plist
1. Open `Info.plist`
2. Add Firebase configuration keys if needed
3. Ensure proper bundle identifier is set

## Step 3: Firebase Configuration

### 3.1 Environment Detection
The app automatically detects the environment based on bundle identifier:
- `.dev` suffix → Development
- `.staging` suffix → Staging
- No suffix → Production

### 3.2 Firebase Services
The following services are configured:
- **Authentication**: Apple Sign-In integration
- **Firestore**: Real-time database for deals
- **Storage**: Image storage for deals
- **Analytics**: User behavior tracking
- **Crashlytics**: Crash reporting

## Step 4: Data Models

### 4.1 FirebaseDeal Model
- Converts between `CreatorRequirement` and Firestore format
- Handles JSON serialization for complex properties
- Includes proper timestamp handling

### 4.2 Data Structure
```
users/{userId}/deals/{dealId}
├── Basic Info (title, description, brand, etc.)
├── Timing (createdAt, dueDate, completedAt, updatedAt)
├── Status (status, priority, isMandatory, isVerified)
├── Requirements (content, tagging, links, hashtags, assets)
├── Verification (verifiedAt, verifiedBy, verificationMethod)
└── Comments (notes, comments array)
```

## Step 5: Real-time Synchronization

### 5.1 FirebaseDealService
- Real-time listeners for deal updates
- Automatic synchronization across devices
- Offline support (when needed)

### 5.2 Authentication Integration
- Seamless Apple Sign-In to Firebase Auth
- User profile management
- Secure data isolation per user

## Step 6: Testing

### 6.1 Local Testing
1. Run the app in development mode
2. Test Apple Sign-In flow
3. Create, update, and delete deals
4. Verify real-time synchronization

### 6.2 Environment Testing
1. Test all three environments (dev, staging, prod)
2. Verify proper configuration loading
3. Test data isolation between environments

## Step 7: Security Rules

### 7.1 Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /deals/{dealId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 7.2 Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 8: Deployment

### 8.1 Development Deployment
1. Use development Firebase project
2. Test with development bundle identifier
3. Verify all features work correctly

### 8.2 Production Deployment
1. Use production Firebase project
2. Update bundle identifier to production
3. Deploy to App Store

## Troubleshooting

### Common Issues

#### 1. Firebase Configuration Error
**Problem**: "Missing Firebase configuration file"
**Solution**: Ensure `GoogleService-Info.plist` files are properly added to the project

#### 2. Authentication Failed
**Problem**: Apple Sign-In not working
**Solution**: Check Apple Sign-In configuration in Firebase Console

#### 3. Real-time Sync Not Working
**Problem**: Deals not syncing in real-time
**Solution**: Check Firestore security rules and authentication state

#### 4. Image Upload Failed
**Problem**: Images not uploading to Storage
**Solution**: Check Storage security rules and file permissions

### Debug Tools

#### 1. Firebase Console
- Monitor authentication events
- View Firestore data
- Check Storage files
- Review Analytics data

#### 2. Xcode Console
- Check for Firebase errors
- Monitor network requests
- Debug authentication flow

#### 3. Firebase Debug View
- Real-time database monitoring
- Authentication state tracking
- Performance monitoring

## Performance Optimization

### 1. Firestore Queries
- Use indexes for complex queries
- Limit query results when possible
- Cache frequently accessed data

### 2. Storage Optimization
- Compress images before upload
- Use appropriate image formats
- Implement lazy loading

### 3. Real-time Listeners
- Remove listeners when not needed
- Use efficient query patterns
- Monitor listener performance

## Security Best Practices

### 1. Data Protection
- All data is user-specific
- No cross-user data access
- Secure authentication required

### 2. API Keys
- Never commit API keys to version control
- Use environment-specific configurations
- Rotate keys regularly

### 3. User Privacy
- Minimal data collection
- User consent for analytics
- GDPR compliance ready

## Monitoring and Analytics

### 1. Firebase Analytics
- User engagement tracking
- Feature usage analytics
- Performance metrics

### 2. Crashlytics
- Crash reporting
- Error tracking
- Performance monitoring

### 3. Custom Events
- Deal creation/update events
- User authentication events
- Error tracking events

## Next Steps

1. **Complete Firebase Setup**: Follow the setup guide
2. **Test Integration**: Verify all features work
3. **Deploy to Staging**: Test with staging environment
4. **Production Deployment**: Deploy to production
5. **Monitor Performance**: Use Firebase monitoring tools

## Support

For issues or questions:
1. Check this guide first
2. Review Firebase documentation
3. Check Xcode console for errors
4. Contact development team

---

**Note**: This integration provides a solid foundation for real-time deal management with Firebase. All features are designed to be scalable and secure for production use.

