# AI Email Parser Testing Guide

## Overview

This guide provides comprehensive instructions for testing the AI Email Parser feature in the "on brand" app, including local development testing and App Store upload procedures.

## Table of Contents

1. [Local Development Testing](#local-development-testing)
2. [API Key Configuration](#api-key-configuration)
3. [Feature Testing](#feature-testing)
4. [App Store Upload Preparation](#app-store-upload-preparation)
5. [Security Considerations](#security-considerations)
6. [Troubleshooting](#troubleshooting)

## Local Development Testing

### Prerequisites

- Xcode 15.0 or later
- iOS 17.2 or later
- Valid OpenAI API key
- Test deal email images

### Setup Steps

1. **Clone and Build the Project**
   ```bash
   cd "/Users/piersondavis/Documents/on brand"
   xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -destination "platform=iOS Simulator,name=iPhone 15" build
   ```

2. **Configure API Key**
   - Open the app in Xcode
   - Navigate to Developer Tools → Settings
   - Enter your OpenAI API key in the secure configuration
   - The key will be stored securely using iOS Keychain

3. **Launch the App**
   ```bash
   xcrun simctl launch "iPhone 15" com.pierson.on-brand
   ```

### Testing the AI Email Parser

1. **Navigate to Deals Tab**
   - Open the app
   - Tap the "Deals" tab in the bottom navigation
   - Tap the "Add Deal" button (💰 icon)

2. **Test AI Parsing Flow**
   - Select "📧 Parse Email with AI"
   - Choose an image from your photo library
   - Wait for AI processing (loading indicator will show)
   - Verify parsed data is populated in the form

3. **Test Manual Entry Flow**
   - Select "✏️ Enter Manually"
   - Fill in deal details manually
   - Verify form validation works correctly

## API Key Configuration

### Secure Storage Implementation

The app uses iOS Keychain for secure API key storage:

```swift
// AIConfiguration.swift
func saveAPIKey(_ key: String) {
    let data = key.data(using: .utf8)!
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "openai_api_key",
        kSecValueData as String: data
    ]
    
    // Delete existing key
    SecItemDelete(query as CFDictionary)
    
    // Add new key
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
        print("Failed to save API key: \(status)")
        return
    }
}
```

### Testing API Key Storage

1. **Set API Key**
   - Open Developer Tools → Settings
   - Enter a test API key
   - Verify it's saved to Keychain

2. **Verify Key Retrieval**
   - Restart the app
   - Check that the API key is still available
   - Test AI parsing functionality

## Feature Testing

### Test Cases

#### 1. AI Email Parsing
- [ ] **Valid Email Image**: Upload a clear image of a deal email
- [ ] **Blurry Image**: Test with low-quality image
- [ ] **No Text Image**: Test with image containing no text
- [ ] **Multiple Languages**: Test with non-English text
- [ ] **Complex Layout**: Test with multi-column email layouts

#### 2. Form Population
- [ ] **Title Extraction**: Verify deal title is correctly extracted
- [ ] **Description Parsing**: Check description accuracy
- [ ] **Due Date Recognition**: Test various date formats
- [ ] **Brand Name**: Verify brand name extraction
- [ ] **Campaign Name**: Check campaign name parsing

#### 3. Error Handling
- [ ] **Network Errors**: Test with no internet connection
- [ ] **API Errors**: Test with invalid API key
- [ ] **Timeout Handling**: Test with slow network
- [ ] **Invalid Image**: Test with corrupted image file

#### 4. UI/UX Testing
- [ ] **Loading States**: Verify loading indicators work
- [ ] **Error Messages**: Check error message display
- [ ] **Form Validation**: Test required field validation
- [ ] **Navigation Flow**: Test step-by-step form progression

### Test Data

#### Sample Deal Emails

1. **Simple Post Deal**
   ```
   Subject: Brand Partnership - Instagram Post
   
   Hi [Creator Name],
   
   We'd love to work with you on a brand partnership!
   
   Requirements:
   - 1 Instagram post
   - Tag @brandname and @brandlocation
   - Use hashtags #brand #partnership
   - Due: March 15, 2025
   
   Payment: $500
   ```

2. **Complex Campaign**
   ```
   Subject: Multi-Platform Campaign Agreement
   
   Dear [Creator],
   
   We're excited to partner with you on our Spring 2025 campaign.
   
   Content Requirements:
   - 3 Instagram posts
   - 5 Instagram stories
   - 1 Instagram reel
   - Tag @brandname in all content
   - Use #Spring2025 #BrandName
   - Include link in bio: brand.com/spring
   
   Timeline:
   - Content due: March 20, 2025
   - Payment: $2,000
   ```

## App Store Upload Preparation

### Security Checklist

- [ ] **API Key Security**: Ensure API keys are not hardcoded
- [ ] **Keychain Storage**: Verify secure key storage implementation
- [ ] **Error Handling**: No sensitive information in error messages
- [ ] **Network Security**: HTTPS only for API calls
- [ ] **Data Privacy**: No user data sent to external services without consent

### Build Configuration

1. **Release Build**
   ```bash
   xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -configuration Release -destination "generic/platform=iOS" build
   ```

2. **Archive for App Store**
   ```bash
   xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -configuration Release -destination "generic/platform=iOS" archive -archivePath "on_brand.xcarchive"
   ```

### App Store Review Considerations

1. **AI Feature Description**
   - Clearly describe the AI email parsing feature
   - Explain data usage and privacy implications
   - Mention OpenAI integration

2. **Privacy Policy Updates**
   - Add section about AI processing
   - Explain data sharing with OpenAI
   - Include user consent mechanisms

3. **App Store Metadata**
   - Update app description to mention AI features
   - Add relevant keywords: "AI", "email parsing", "influencer tools"
   - Include screenshots of AI parsing flow

## Security Considerations

### Data Protection

1. **API Key Management**
   - Keys stored in iOS Keychain
   - No hardcoded keys in source code
   - Secure key retrieval and storage

2. **Image Processing**
   - Images processed locally before API call
   - Base64 encoding for secure transmission
   - No image storage on device

3. **Network Security**
   - HTTPS only for API calls
   - Certificate pinning (recommended)
   - Request timeout handling

### Privacy Compliance

1. **User Consent**
   - Clear explanation of AI processing
   - Opt-in for AI features
   - Easy way to disable AI parsing

2. **Data Minimization**
   - Only necessary data sent to API
   - No personal information in API calls
   - Automatic data cleanup

## Troubleshooting

### Common Issues

#### 1. API Key Not Working
**Symptoms**: "API key not configured" error
**Solution**: 
- Check Keychain access
- Verify API key format
- Test with OpenAI API directly

#### 2. Parsing Failures
**Symptoms**: "Failed to parse email" error
**Solution**:
- Check image quality
- Verify text is readable
- Test with different image formats

#### 3. Network Errors
**Symptoms**: "Network error" or timeout
**Solution**:
- Check internet connection
- Verify API endpoint accessibility
- Test with different network conditions

#### 4. Form Not Populating
**Symptoms**: AI parsing succeeds but form remains empty
**Solution**:
- Check data model mapping
- Verify JSON parsing logic
- Test with different email formats

### Debug Tools

1. **Console Logging**
   - Enable debug logging in AIConfiguration
   - Check Xcode console for error messages
   - Monitor API request/response data

2. **Network Monitoring**
   - Use Xcode Network Inspector
   - Monitor API call timing
   - Check response status codes

3. **Memory Profiling**
   - Monitor memory usage during parsing
   - Check for memory leaks
   - Optimize image processing

### Performance Testing

1. **Response Time**
   - Measure API call duration
   - Test with different image sizes
   - Optimize for slow networks

2. **Memory Usage**
   - Monitor peak memory usage
   - Test with large images
   - Implement memory cleanup

3. **Battery Impact**
   - Test background processing
   - Monitor CPU usage
   - Optimize for battery life

## Conclusion

This testing guide ensures the AI Email Parser feature is thoroughly tested and ready for App Store submission. Follow all security guidelines and test thoroughly before release.

For additional support, refer to the OpenAI API documentation and iOS Keychain documentation.
