# On Brand - AI-Powered Style & Photo Analysis iOS App

An AI-powered style and photo analysis iOS app with Instagram-style UI components, built with SwiftUI, MVVM architecture, and comprehensive Firebase backend integration.

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/pierson-davis/on-brand-ios.git
cd on-brand-ios
```

### 2. Set Up Development Environment
```bash
# Run the automated setup script
./Scripts/setup-development-environment.sh
```

### 3. Configure API Keys
The app requires OpenAI API keys for AI features. You have two options:

#### Option A: Use Your Own API Key (Recommended)
1. Get your OpenAI API key from [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Edit `on brand/App/Secrets-Development.xcconfig`
3. Replace `<your-development-openai-api-key-here>` with your actual key

#### Option B: Quick Development Setup
For immediate development, you can use the working API key from the git history:
```bash
# Extract the working API key from git history
git show 2aa8213:on\ brand/App/Secrets-Development.xcconfig | grep OPENAI_API_KEY
# Copy the key and paste it into your Secrets-Development.xcconfig file
```

### 4. Firebase Setup
1. Create a Firebase project at [https://console.firebase.google.com](https://console.firebase.google.com)
2. Download your `GoogleService-Info.plist` file
3. Replace the placeholder files in `on brand/App/` with your actual Firebase configuration

### 5. Build and Run
```bash
# Open in Xcode
open "on brand.xcodeproj"

# Or build from command line
xcodebuild -project "on brand.xcodeproj" -scheme "on brand" -configuration Debug
```

## 📱 Features

- **AI-Powered Photo Analysis**: OpenAI integration for intelligent image curation
- **Creator Requirements**: Comprehensive deal tracking and requirement management
- **Firebase Backend**: Full authentication and data synchronization
- **Instagram-Style UI**: Modern, intuitive interface design
- **Developer Tools**: Comprehensive debugging and testing suite
- **Design System**: Complete theming and component library

## 🏗️ Architecture

- **Pattern**: MVVM with SwiftUI
- **Backend**: Firebase (Auth, Firestore, Storage, Analytics, Crashlytics)
- **AI Services**: OpenAI integration for photo analysis
- **Design System**: Comprehensive theming with ThemeManager

## 🔒 Security

The app uses a secure configuration system:

- **Development**: `Secrets-Development.xcconfig` - Safe to commit with your API key
- **Staging**: `Secrets-Staging.xcconfig` - Excluded from git, use for staging builds
- **Production**: `Secrets-Production.xcconfig` - Excluded from git, use for production builds

## 📚 Documentation

- [Development Setup Guide](DEVELOPMENT_SETUP_GUIDE.md) - Complete setup instructions
- [Firebase Setup Guide](on%20brand/FIREBASE_SETUP_GUIDE.md) - Firebase configuration
- [OpenAI API Setup](on%20brand/OPENAI_API_KEY_SETUP_GUIDE.md) - API key configuration
- [Production Deployment Guide](on%20brand/PRODUCTION_DEPLOYMENT_GUIDE.md) - App Store deployment
- [AI Services Documentation](docs/ai-services.mdc) - AI integration details

## 🛠️ Development Tools

### Available Scripts
- `Scripts/setup-development-environment.sh` - Automated environment setup
- `Scripts/inject-api-keys.sh` - API key injection for different environments
- `Scripts/test-secure-api.sh` - API key validation testing

### Debug Features
- Shake gesture for debug menu (debug builds)
- Comprehensive developer dashboard
- Firebase test views
- Performance monitoring tools

## 🚀 App Store Deployment

### Pre-Deployment Checklist
1. ✅ Configure production API keys
2. ✅ Set up production Firebase project
3. ✅ Update build configuration for Release
4. ✅ Test all features in production environment

### CI/CD Integration
The project includes examples for:
- GitHub Actions
- Jenkins Pipeline
- Automated API key injection
- Secure production builds

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section in the documentation
2. Review the comprehensive guides in the `docs/` folder
3. Use the built-in debug tools for diagnostics
4. Check GitHub issues for known problems

---

**Note**: This app includes AI features that require OpenAI API keys. Make sure to configure your API keys properly for the features to work correctly.
