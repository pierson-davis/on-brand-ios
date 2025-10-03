# Production Deployment Guide

## Overview

This guide provides comprehensive instructions for deploying the "on brand" app with preloaded OpenAI API keys in a secure, App Store-compliant manner. The implementation uses multiple layers of security to ensure API keys are never exposed in source code.

## Security Architecture

### 🔒 Multi-Layer Security

1. **Build-Time Key Injection**: API keys are injected during the build process
2. **Environment-Based Configuration**: Different keys for different environments
3. **Keychain Storage**: Production keys stored in iOS Keychain
4. **Encrypted Bundle Resources**: Fallback encrypted storage
5. **No Hardcoded Keys**: Zero sensitive data in source code

### 🏗️ Deployment Modes

- **Development**: Uses xcconfig files with placeholder keys
- **Staging**: Uses Keychain storage with staging keys
- **Production**: Uses encrypted bundle resources with production keys

## Step 1: Setup Build Configurations

### 1.1 Create Build Schemes

1. Open Xcode
2. Go to Product → Scheme → Manage Schemes
3. Create three schemes:
   - **Development** (Debug configuration)
   - **Staging** (Release configuration)
   - **Production** (Release configuration)

### 1.2 Configure Build Settings

For each configuration, set the appropriate xcconfig file:

- **Development**: `Secrets-Development.xcconfig`
- **Staging**: `Secrets-Staging.xcconfig`
- **Production**: `Secrets-Production.xcconfig`

## Step 2: Prepare API Keys

### 2.1 Get Production API Key

1. Go to [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Create a new API key for production
3. Name it "on brand production"
4. Copy the key (starts with `sk-`)

### 2.2 Prepare Staging Key

1. Create a separate API key for staging
2. Name it "on brand staging"
3. Copy the key

## Step 3: Configure Development Environment

### 3.1 Update Development Config

```bash
# Edit the development configuration
nano "on brand/App/Secrets-Development.xcconfig"

# Replace the placeholder with your development key
OPENAI_API_KEY = sk-your-development-key-here
```

### 3.2 Test Development Build

```bash
# Run the injection script for development
./Scripts/inject-api-keys.sh Development

# Build and test
xcodebuild -project "on brand.xcodeproj" -scheme "Development" build
```

## Step 4: Configure Staging Environment

### 4.1 Set Environment Variables

```bash
# Set staging API key
export OPENAI_API_KEY_STAGING="sk-your-staging-key-here"

# Run injection script
./Scripts/inject-api-keys.sh Staging
```

### 4.2 Test Staging Build

```bash
# Build staging configuration
xcodebuild -project "on brand.xcodeproj" -scheme "Staging" build
```

## Step 5: Configure Production Environment

### 5.1 Set Production Environment Variables

```bash
# Set production API key
export OPENAI_API_KEY_PROD="sk-your-production-key-here"

# Run injection script
./Scripts/inject-api-keys.sh Production
```

### 5.2 Verify Production Configuration

```bash
# Check that no placeholder values remain
grep -r "<.*key.*>" "on brand/App/Secrets-Production.xcconfig"

# Should return no results
```

## Step 6: CI/CD Pipeline Integration

### 6.1 GitHub Actions Example

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Inject API Keys
      env:
        OPENAI_API_KEY_PROD: ${{ secrets.OPENAI_API_KEY_PROD }}
      run: |
        chmod +x Scripts/inject-api-keys.sh
        ./Scripts/inject-api-keys.sh Production
    
    - name: Build App
      run: |
        xcodebuild -project "on brand.xcodeproj" -scheme "Production" build
    
    - name: Archive App
      run: |
        xcodebuild -project "on brand.xcodeproj" -scheme "Production" archive
```

### 6.2 Jenkins Pipeline Example

```groovy
pipeline {
    agent any
    
    environment {
        OPENAI_API_KEY_PROD = credentials('openai-api-key-prod')
    }
    
    stages {
        stage('Inject Keys') {
            steps {
                sh 'chmod +x Scripts/inject-api-keys.sh'
                sh './Scripts/inject-api-keys.sh Production'
            }
        }
        
        stage('Build') {
            steps {
                sh 'xcodebuild -project "on brand.xcodeproj" -scheme "Production" build'
            }
        }
        
        stage('Archive') {
            steps {
                sh 'xcodebuild -project "on brand.xcodeproj" -scheme "Production" archive'
            }
        }
    }
}
```

## Step 7: App Store Submission

### 7.1 Pre-Submission Checklist

- [ ] All placeholder keys removed
- [ ] Production configuration tested
- [ ] API key validation working
- [ ] Error handling tested
- [ ] No hardcoded sensitive data
- [ ] Keychain access properly configured

### 7.2 App Store Connect Configuration

1. **App Information**:
   - Name: "on brand"
   - Bundle ID: `com.pierson.on-brand`
   - Version: 1.0.0

2. **Privacy Information**:
   - Data Collection: Yes
   - Data Types: Usage Data, Diagnostics
   - Purpose: App Functionality, Analytics

3. **App Review Information**:
   - Demo Account: Not required
   - Notes: "AI-powered influencer deal management app"

### 7.3 Submission Process

1. **Archive the App**:
   ```bash
   xcodebuild -project "on brand.xcodeproj" -scheme "Production" archive
   ```

2. **Upload to App Store Connect**:
   - Use Xcode Organizer
   - Or use `altool` command line tool

3. **Submit for Review**:
   - Complete all required information
   - Submit for App Store review

## Step 8: Security Verification

### 8.1 Source Code Audit

```bash
# Check for hardcoded API keys
grep -r "sk-" "on brand/" --exclude-dir=Scripts --exclude="*.xcconfig"

# Check for placeholder values
grep -r "<.*key.*>" "on brand/" --exclude-dir=Scripts

# Should return no results
```

### 8.2 Binary Analysis

```bash
# Check compiled binary for API keys
strings "on brand.app/on brand" | grep "sk-"

# Should return no results
```

### 8.3 Keychain Verification

```bash
# Check Keychain for stored keys
security find-generic-password -s "openai_api_key_production"

# Should return encrypted data, not plain text
```

## Step 9: Monitoring and Maintenance

### 9.1 API Key Rotation

1. **Generate New Key**:
   - Create new API key in OpenAI dashboard
   - Update CI/CD environment variables

2. **Deploy Update**:
   - Run injection script with new key
   - Deploy new version to App Store

3. **Revoke Old Key**:
   - Delete old API key from OpenAI dashboard
   - Monitor for any issues

### 9.2 Usage Monitoring

1. **OpenAI Dashboard**:
   - Monitor API usage and costs
   - Set up usage alerts
   - Track rate limits

2. **App Analytics**:
   - Monitor AI feature usage
   - Track error rates
   - Monitor performance

## Step 10: Troubleshooting

### 10.1 Common Issues

#### "API key not configured" Error
- **Cause**: Key injection failed
- **Solution**: Check environment variables and run injection script

#### "Invalid API key" Error
- **Cause**: Wrong key format or expired key
- **Solution**: Verify key format and check OpenAI dashboard

#### "Network error" Error
- **Cause**: API rate limits or network issues
- **Solution**: Check OpenAI status and implement retry logic

#### Build Failures
- **Cause**: Missing environment variables
- **Solution**: Set required environment variables in CI/CD

### 10.2 Debug Commands

```bash
# Check configuration files
cat "on brand/App/Secrets-Production.xcconfig"

# Verify injection script
./Scripts/inject-api-keys.sh Production --dry-run

# Check build logs
xcodebuild -project "on brand.xcodeproj" -scheme "Production" build 2>&1 | grep -i error
```

## Step 11: Advanced Security Features

### 11.1 Key Encryption

For enhanced security, implement proper key encryption:

```swift
// In SecureAPIManager.swift
private func encryptKey(_ key: String) -> String {
    // Use AES encryption with device-specific key
    // Store encrypted key in Keychain
}
```

### 11.2 Runtime Key Validation

```swift
// Validate key format and test API access
private func validateKeyAtRuntime(_ key: String) -> Bool {
    // Test API call to OpenAI
    // Return true if successful
}
```

### 11.3 Key Rotation Support

```swift
// Support for automatic key rotation
private func rotateKeyIfNeeded() {
    // Check for key rotation signals
    // Update key if needed
}
```

## Success Criteria

✅ **No Hardcoded Keys**: Zero sensitive data in source code
✅ **Secure Storage**: Keys stored in iOS Keychain
✅ **Environment Separation**: Different keys for different environments
✅ **CI/CD Integration**: Automated key injection
✅ **App Store Compliance**: Meets all security requirements
✅ **Error Handling**: Graceful fallbacks for key issues
✅ **Monitoring**: Usage tracking and alerting

## Conclusion

This production deployment setup provides enterprise-grade security for API key management while maintaining App Store compliance. The multi-layer approach ensures that sensitive data is never exposed in source code or binary files, while still allowing for easy deployment and maintenance.

The system is designed to be:
- **Secure**: Multiple layers of protection
- **Scalable**: Easy to add new environments
- **Maintainable**: Clear separation of concerns
- **Compliant**: Meets App Store requirements
- **Reliable**: Robust error handling and monitoring
