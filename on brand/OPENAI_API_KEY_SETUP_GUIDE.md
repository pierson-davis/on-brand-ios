# OpenAI API Key Setup Guide

## Overview

This guide will walk you through setting up your OpenAI API key to test the AI Email Parser feature in the "on brand" app. We'll take this extremely slow and methodical to ensure everything works perfectly.

## Prerequisites

- ✅ Xcode 15.0 or later
- ✅ iOS 17.2 or later  
- ✅ Valid OpenAI API key
- ✅ Test deal email images

## Step 1: Get Your OpenAI API Key

### 1.1 Create OpenAI Account
1. Go to [https://openai.com](https://openai.com)
2. Click "Sign Up" or "Log In"
3. Complete the account setup process

### 1.2 Generate API Key
1. Go to [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Click "Create new secret key"
3. Give it a name like "on brand app"
4. Copy the API key (it starts with `sk-`)
5. **Important**: Save it somewhere safe - you won't be able to see it again!

### 1.3 Add Payment Method
1. Go to [https://platform.openai.com/account/billing](https://platform.openai.com/account/billing)
2. Add a payment method (required for API usage)
3. Add some credits ($5-10 should be enough for testing)

## Step 2: Configure the App

### 2.1 Launch the App
1. Open Xcode
2. Build and run the app on iPhone 15 Simulator
3. Wait for the app to fully load

### 2.2 Access Developer Tools
1. **Shake your device** (or use the simulator's Device > Shake gesture)
2. The developer console should appear
3. If it doesn't appear, try shaking again

### 2.3 Open AI Settings
1. In the developer dashboard, look for the "AI Settings" button
2. It should have a brain icon and say "Configure OpenAI API"
3. Tap on it to open the AI Settings screen

## Step 3: Enter Your API Key

### 3.1 Enter the API Key
1. In the "OpenAI API Key" field, paste your API key
2. The field should show dots (••••••••••••••••) for security
3. Make sure the key starts with `sk-` and is longer than 20 characters

### 3.2 Save the Key
1. Tap "Save API Key"
2. You should see a success message: "API key saved successfully!"
3. The status should change to "API Key Configured"

### 3.3 Test the Connection
1. Tap "Test API Connection"
2. Wait for the test to complete (about 2-3 seconds)
3. You should see "Success: API connection working!"

## Step 4: Test the AI Email Parser

### 4.1 Navigate to Deals
1. Close the developer dashboard
2. Tap the "Deals" tab at the bottom
3. You should see the "My Deals" screen

### 4.2 Add a New Deal
1. Tap the 💰 button (dollar sign) in the header
2. You should see two options:
   - "📧 Parse Email with AI" (with camera icon)
   - "✏️ Enter Manually"

### 4.3 Test AI Parsing
1. Tap "📧 Parse Email with AI"
2. Choose an image from your photo library
3. Wait for AI processing (you'll see a loading indicator)
4. The form should populate with parsed data

## Step 5: Verify Everything Works

### 5.1 Check Form Population
- ✅ Title should be extracted
- ✅ Description should be filled
- ✅ Due date should be recognized
- ✅ Brand name should be identified
- ✅ Campaign details should be parsed

### 5.2 Test Different Email Types
Try with different types of deal emails:
- Simple post deals
- Complex multi-platform campaigns
- Emails with different layouts
- Various date formats

### 5.3 Test Error Handling
- Try with a blurry image
- Try with an image containing no text
- Test with no internet connection

## Step 6: Troubleshooting

### 6.1 Common Issues

#### "API key not configured" Error
- **Cause**: API key wasn't saved properly
- **Solution**: Go back to AI Settings and re-enter the key

#### "Failed to parse email" Error
- **Cause**: Image quality or API issues
- **Solution**: Try with a clearer image or check your internet connection

#### "Network error" Error
- **Cause**: No internet connection or API issues
- **Solution**: Check your internet connection and try again

#### App Crashes
- **Cause**: Memory issues or API problems
- **Solution**: Restart the app and try again

### 6.2 Debug Information
- Check the Xcode console for error messages
- Look for "AI Parser:" logs in the console
- Verify the API key format (should start with `sk-`)

## Step 7: Production Considerations

### 7.1 Security
- ✅ API key is stored securely in iOS Keychain
- ✅ No hardcoded keys in source code
- ✅ HTTPS only for API calls

### 7.2 Privacy
- Images are processed locally before sending to OpenAI
- No personal data is stored on OpenAI's servers
- API key is only stored on your device

### 7.3 Cost Management
- Monitor your OpenAI usage at [https://platform.openai.com/usage](https://platform.openai.com/usage)
- Set up usage alerts if needed
- Each image analysis costs approximately $0.01-0.05

## Step 8: Advanced Testing

### 8.1 Test with Real Deal Emails
1. Take screenshots of actual influencer deal emails
2. Test with different brands and campaign types
3. Verify accuracy of parsed information

### 8.2 Performance Testing
1. Test with large images
2. Test with multiple rapid requests
3. Monitor memory usage

### 8.3 Edge Cases
1. Test with non-English text
2. Test with complex email layouts
3. Test with multiple columns

## Success Criteria

✅ **API Key Configured**: Status shows "API Key Configured"
✅ **Connection Test Passes**: "Success: API connection working!"
✅ **AI Parsing Works**: Form populates with parsed data
✅ **Error Handling Works**: Graceful fallback to manual entry
✅ **UI/UX Smooth**: Loading states and transitions work properly

## Next Steps

Once everything is working:

1. **Test Thoroughly**: Try different types of deal emails
2. **Monitor Performance**: Check for any memory leaks or crashes
3. **User Experience**: Ensure the flow is intuitive for influencers
4. **Documentation**: Update any user-facing documentation

## Support

If you encounter any issues:

1. Check the Xcode console for error messages
2. Verify your OpenAI account has sufficient credits
3. Ensure your API key is valid and active
4. Test with a simple, clear image first

## Conclusion

The AI Email Parser feature is now ready to use! This revolutionary feature will save influencers significant time by automatically extracting deal information from email screenshots. The implementation is secure, privacy-focused, and ready for production use.

Remember to monitor your OpenAI usage and costs as you test the feature extensively.
