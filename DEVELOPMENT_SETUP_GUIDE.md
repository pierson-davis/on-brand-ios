# Development Setup Guide

This guide will help you set up the "on brand" iOS app for development and App Store deployment.

## 🚀 Quick Start for Development

### 1. Clone and Setup
```bash
git clone https://github.com/pierson-davis/on-brand-ios.git
cd on-brand-ios
```

### 2. API Key Configuration
The development API key is already configured in `on brand/App/Secrets-Development.xcconfig`. This file is safe to commit and contains a working OpenAI API key for development.

**For your own development:**
1. Get your OpenAI API key from [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Replace the key in `on brand/App/Secrets-Development.xcconfig`

### 3. Firebase Setup
1. Create a Firebase project at [https://console.firebase.google.com](https://console.firebase.google.com)
2. Download your `GoogleService-Info.plist` file
3. Replace the placeholder files in `on brand/App/` with your actual Firebase configuration

### 4. Build and Run
```bash
# Open in Xcode
open "on brand.xcodeproj"

# Or build from command line
xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -configuration Debug
```

## 🔒 Security Configuration

### Development Environment
- ✅ `Secrets-Development.xcconfig` - Safe to commit, contains development API key
- ❌ `Secrets-Staging.xcconfig` - Excluded from git, use for staging builds
- ❌ `Secrets-Production.xcconfig` - Excluded from git, use for production builds

### Environment-Specific API Keys
The app supports multiple environments:

1. **Development**: Uses `Secrets-Development.xcconfig`
2. **Staging**: Uses `Secrets-Staging.xcconfig` (not in git)
3. **Production**: Uses `Secrets-Production.xcconfig` (not in git)

## 📱 App Store Deployment

### Pre-Deployment Checklist

#### 1. API Key Management
```bash
# Create production API key file (not committed to git)
cp "on brand/App/Secrets-Development.xcconfig" "on brand/App/Secrets-Production.xcconfig"

# Edit the production file with your production API key
nano "on brand/App/Secrets-Production.xcconfig"
```

#### 2. Firebase Configuration
- Ensure you have production Firebase configuration
- Update `GoogleService-Info-Prod.plist` with production settings
- Test Firebase connectivity in production environment

#### 3. Build Configuration
- Set build scheme to "Release"
- Ensure production API key is configured
- Verify all environment variables are set correctly

### CI/CD Setup (Recommended)

#### GitHub Actions Example
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
      
      - name: Setup API Keys
        env:
          OPENAI_API_KEY_PROD: ${{ secrets.OPENAI_API_KEY_PROD }}
        run: |
          echo "OPENAI_API_KEY = $OPENAI_API_KEY_PROD" > "on brand/App/Secrets-Production.xcconfig"
      
      - name: Build
        run: |
          xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -configuration Release
```

#### Jenkins Pipeline Example
```groovy
pipeline {
    agent any
    environment {
        OPENAI_API_KEY_PROD = credentials('openai-api-key-prod')
    }
    stages {
        stage('Setup') {
            steps {
                sh 'echo "OPENAI_API_KEY = $OPENAI_API_KEY_PROD" > "on brand/App/Secrets-Production.xcconfig"'
            }
        }
        stage('Build') {
            steps {
                sh 'xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -configuration Release'
            }
        }
    }
}
```

## 🛠 Development Tools

### Available Scripts
- `Scripts/inject-api-keys.sh` - Automated API key injection
- `Scripts/test-secure-api.sh` - API key validation testing

### Usage Examples
```bash
# Inject API keys for different environments
./Scripts/inject-api-keys.sh Development
./Scripts/inject-api-keys.sh Staging
./Scripts/inject-api-keys.sh Production

# Test API key configuration
./Scripts/test-secure-api.sh
```

## 🔧 Troubleshooting

### Common Issues

#### 1. API Key Not Working
- Verify the key is correctly formatted
- Check that the key has proper permissions
- Ensure the environment configuration is correct

#### 2. Firebase Connection Issues
- Verify `GoogleService-Info.plist` is in the app bundle
- Check Firebase project configuration
- Ensure proper Firebase rules are set

#### 3. Build Configuration Issues
- Verify Xcode project settings
- Check that configuration files are properly referenced
- Ensure all required frameworks are linked

### Debug Tools
The app includes comprehensive debug tools accessible via:
- Shake gesture (in debug builds)
- Developer menu in debug builds
- Firebase test views for backend validation

## 📚 Additional Resources

- [Firebase Setup Guide](on%20brand/FIREBASE_SETUP_GUIDE.md)
- [OpenAI API Setup](on%20brand/OPENAI_API_KEY_SETUP_GUIDE.md)
- [Production Deployment Guide](on%20brand/PRODUCTION_DEPLOYMENT_GUIDE.md)
- [AI Services Documentation](docs/ai-services.mdc)

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review the comprehensive documentation in the `docs/` folder
3. Use the built-in debug tools for diagnostics
4. Check the GitHub issues for known problems

---

**Note**: This setup allows for secure development while maintaining the flexibility needed for App Store deployment. The development API key is included for convenience, but production keys should always be managed through secure CI/CD pipelines.
