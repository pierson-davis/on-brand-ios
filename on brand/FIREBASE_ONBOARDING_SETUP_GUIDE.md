# 🔥 Firebase Onboarding Data Persistence Setup Guide

## Overview
This guide will help you complete the Firebase onboarding data persistence feature, allowing users to skip onboarding on subsequent logins.

## ✅ What's Been Implemented

### 1. **FirebaseOnboardingData Model** (`Features/Onboarding/Models/FirebaseOnboardingData.swift`)
Complete data model for storing onboarding quiz answers and archetype results in Firestore:
- User ID, name, gender
- Quiz answers dictionary (`[String: String]`)
- Primary and secondary archetypes
- Timestamps for creation, update, and completion
- Conversion methods to/from `VibeResult` and `UserProfile`
- Firestore-compatible with Timestamp support

### 2. **FirebaseOnboardingService** (`Features/Onboarding/Services/FirebaseOnboardingService.swift`)
Complete service for managing onboarding data in Firebase:
- Real-time synchronization with Firestore
- Automatic data loading when user signs in
- CRUD operations (save, load, delete)
- Automatic conversion from `OnboardingViewModel` data
- User-specific data isolation (`users/{userId}/onboarding/data`)
- Observable state for UI updates

### 3. **Integration Updates**
Updated integration points (currently commented out with TODOs):
- `OnboardingViewModel`: Firebase save on completion
- `ContentView`: Check Firebase for existing onboarding data
- `ContentView`: Load user profile from Firebase onboarding data

## 📋 Manual Setup Required

### Step 1: Add Files to Xcode Project

The Firebase onboarding files exist in your project directory but need to be added to the Xcode project target.

**Method 1: Using Xcode (Recommended)**
1. Open Xcode
2. In the Project Navigator, navigate to **on brand** > **Features** > **Onboarding** > **Models**
3. Right-click on the **Models** folder
4. Select **"Add Files to 'on brand'..."**
5. Navigate to: `/Users/piersondavis/Documents/on brand/on brand/Features/Onboarding/Models/`
6. Select **FirebaseOnboardingData.swift**
7. **Important Options**:
   - ✅ **Add to targets**: Check "on brand"
   - ❌ **Copy items if needed**: Uncheck this (files are already in correct location)
   - ✅ **Create groups**: Select this option
8. Click **"Add"**

9. Repeat for **FirebaseOnboardingService.swift**:
   - Navigate to **on brand** > **Features** > **Onboarding** > **Services**
   - Right-click on the **Services** folder
   - Select **"Add Files to 'on brand'..."**
   - Navigate to: `/Users/piersondavis/Documents/on brand/on brand/Features/Onboarding/Services/`
   - Select **FirebaseOnboardingService.swift**
   - Same options as above
   - Click **"Add"**

**Method 2: Using Finder**
1. Open Finder and navigate to:
   - `/Users/piersondavis/Documents/on brand/on brand/Features/Onboarding/Models/`
2. Drag `FirebaseOnboardingData.swift` into Xcode's Project Navigator
3. Drop it into the **Models** folder
4. In the dialog:
   - ✅ Check "on brand" target
   - ❌ Uncheck "Copy items if needed"
5. Click "Finish"
6. Repeat for `FirebaseOnboardingService.swift` in the **Services** folder

### Step 2: Enable Firebase Onboarding Service

Once the files are added to Xcode, enable the Firebase onboarding service by making the following changes:

#### 2.1. OnboardingViewModel.swift

**Line 21-22: Enable Firebase Service**
```swift
// BEFORE:
    @Published var userName: String = ""
    
    // Theme manager for dynamic theming

// AFTER:
    @Published var userName: String = ""
    
    // Firebase onboarding service
    private let firebaseOnboardingService = FirebaseOnboardingService()
    
    // Theme manager for dynamic theming
```

**Line 169-175: Enable Firebase Save**
```swift
// BEFORE:
    func completeOnboarding() {
        calculateResults()
        
        // TODO: Save onboarding data to Firebase
        // This will be implemented after adding FirebaseOnboardingService to Xcode project
        
        finished = true
    }

// AFTER:
    func completeOnboarding() {
        calculateResults()
        
        // Save onboarding data to Firebase
        if let firebaseUser = Auth.auth().currentUser {
            let onboardingData = firebaseOnboardingService.createOnboardingData(from: self, userId: firebaseUser.uid)
            firebaseOnboardingService.saveOnboardingData(onboardingData)
            print("🔥 Onboarding data saved to Firebase for user: \(firebaseUser.uid)")
        } else {
            print("❌ No Firebase user found, cannot save onboarding data")
        }
        
        finished = true
    }
```

#### 2.2. ContentView.swift

**Line 17-19: Enable Onboarding Service**
```swift
// BEFORE:
    @StateObject private var authService = FirebaseAuthService()
    // @StateObject private var onboardingService = FirebaseOnboardingService() // TODO: Enable after adding to Xcode project
    @StateObject private var vm = OnboardingViewModel()

// AFTER:
    @StateObject private var authService = FirebaseAuthService()
    @StateObject private var onboardingService = FirebaseOnboardingService()
    @StateObject private var vm = OnboardingViewModel()
```

**Line 73-79: Enable Firebase Onboarding Check**
```swift
// BEFORE:
                } else if authService.isAuthenticated {
                    // Check if user has completed onboarding in Firebase OR has a local profile
                    if let firebaseUser = authService.currentUser,
                       (profileService.hasProfile(for: firebaseUser.id) || hasCompletedOnboarding) {
                        // User has completed onboarding in Firebase or locally - show home screen
                        HomeView(onLogout: logout)
                            // TODO: Load user profile from Firebase onboarding data if it exists
                    } else {

// AFTER:
                } else if authService.isAuthenticated {
                    // Check if user has completed onboarding in Firebase OR has a local profile
                    if let firebaseUser = authService.currentUser,
                       (onboardingService.hasCompletedOnboarding() || profileService.hasProfile(for: firebaseUser.id) || hasCompletedOnboarding) {
                        // User has completed onboarding in Firebase or locally - show home screen
                        HomeView(onLogout: logout)
                            .onAppear {
                                // Load user profile from Firebase onboarding data if it exists
                                if let onboardingData = onboardingService.onboardingData,
                                   let profile = onboardingData.toUserProfile() {
                                    profileService.saveProfile(profile)
                                    print("✅ User profile loaded from Firebase onboarding data")
                                }
                            }
                    } else {
```

**Line 414-420: Enable Onboarding Data Loading**
```swift
// BEFORE:
                    if self.authService.isAuthenticated {
                        print("✅ Firebase authentication successful")
                        // Refresh user name from Firebase and rebuild onboarding flow
                        self.vm.refreshUserNameFromFirebase()
                        // TODO: Load onboarding data from Firebase
                        // self.onboardingService.loadOnboardingData()
                    } else {

// AFTER:
                    if self.authService.isAuthenticated {
                        print("✅ Firebase authentication successful")
                        // Refresh user name from Firebase and rebuild onboarding flow
                        self.vm.refreshUserNameFromFirebase()
                        // Load onboarding data from Firebase
                        self.onboardingService.loadOnboardingData()
                    } else {
```

### Step 3: Build and Verify

1. **Clean Build Folder**: 
   - In Xcode: Product > Clean Build Folder (⌘+Shift+K)

2. **Build the Project**:
   - In Xcode: Product > Build (⌘+B)
   - Verify no compilation errors

3. **Run the App**:
   - In Xcode: Product > Run (⌘+R)
   - Or use the command line:
     ```bash
     cd "/Users/piersondavis/Documents/on brand"
     xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -destination "platform=iOS Simulator,name=iPhone 15" -sdk iphonesimulator build
     ```

## 🧪 Testing the Integration

### Test 1: New User Onboarding
1. **Clean Install**: Delete the app from simulator
2. **Sign In**: Tap Apple Sign-In with a new account
3. **Complete Onboarding**: Go through all 18 onboarding screens
4. **Check Console**: Look for: `🔥 Onboarding data saved to Firebase for user: {userId}`
5. **Verify Firestore**: Open Firebase Console > Firestore
   - Navigate to: `users/{userId}/onboarding/data`
   - Verify document exists with quiz answers and archetype data

### Test 2: Returning User (Skip Onboarding)
1. **Logout**: Tap logout in the app
2. **Sign In Again**: Use the same Apple ID
3. **Verify**: App should skip onboarding and go directly to HomeView
4. **Check Console**: Look for: `✅ User profile loaded from Firebase onboarding data`

### Test 3: Different User
1. **Logout**: Tap logout in the app
2. **Sign In**: Use a different Apple ID (or simulator)
3. **Verify**: App should show onboarding for this new user
4. **Complete**: Go through onboarding again
5. **Verify**: Firebase should have separate onboarding data for each user

## 🔍 Troubleshooting

### Issue: "Cannot find 'FirebaseOnboardingService' in scope"
**Solution**: Files not added to Xcode target
- Follow Step 1 to add files to Xcode project
- Clean build folder and rebuild

### Issue: "Build input files cannot be found"
**Solution**: File paths are incorrect in Xcode project
- Remove the files from Xcode (select and delete, choose "Remove Reference")
- Re-add using Step 1, ensuring "Copy items if needed" is UNCHECKED

### Issue: Onboarding data not saving to Firebase
**Solution**: Check Firebase configuration
- Verify `GoogleService-Info-Dev.plist` is present
- Check console for Firebase errors
- Ensure user is authenticated before onboarding completion

### Issue: Onboarding data not loading on login
**Solution**: Check real-time listener
- Verify `loadOnboardingData()` is called after authentication
- Check Firestore security rules allow user to read their own data
- Check console for Firebase errors

## 📊 Firebase Data Structure

### Firestore Collection Path
```
users/{userId}/onboarding/data
```

### Document Structure
```json
{
  "id": "UUID-STRING",
  "userId": "firebase-user-id",
  "userName": "John Doe",
  "selectedGender": "male",
  "answers": {
    "question_1": "2",
    "question_2": "1",
    "question_3": "3"
  },
  "primaryArchetype": "minimalist",
  "secondaryArchetype": "classic",
  "vibeResultDescription": "A minimalist with classic influences",
  "completedAt": Timestamp,
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

### Security Rules (Already Configured)
```javascript
// users/{userId}/onboarding/{document}
match /users/{userId}/onboarding/{document} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

## ✅ Success Criteria

Once setup is complete, you should see:
1. ✅ No compilation errors when building
2. ✅ Onboarding data saves to Firebase on completion
3. ✅ Returning users skip onboarding automatically
4. ✅ User profile loads from Firebase onboarding data
5. ✅ Each user has their own isolated onboarding data

## 🎉 Next Steps

After successful setup:
1. Test with multiple user accounts
2. Verify data persistence across app restarts
3. Test logout/login flow thoroughly
4. Consider adding analytics for onboarding completion rates
5. Consider adding ability to retake onboarding (reset feature)

---

**Need Help?** Check the console logs for detailed Firebase operation status. All Firebase operations include emoji-prefixed logs (🔥, ✅, ❌) for easy debugging.
