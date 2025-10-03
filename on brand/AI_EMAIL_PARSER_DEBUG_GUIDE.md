# AI Email Parser Debug Guide

## Issue: "Failed to parse email"

This guide will help you debug and fix the AI Email Parser issue step by step.

## Step 1: Verify API Key Configuration

### ✅ API Key Status
- **Development**: ✅ Configured (`sk-proj-ae8Ct4t...`)
- **Staging**: ✅ Configured (`sk-proj-ae8Ct4t...`)
- **Production**: ✅ Configured (`sk-proj-ae8Ct4t...`)

### ✅ Configuration Files
- `Secrets-Development.xcconfig` ✅
- `Secrets-Staging.xcconfig` ✅
- `Secrets-Production.xcconfig` ✅

## Step 2: Test API Key Loading

### In Xcode Console:
1. Build and run the app
2. Go to "Deals" tab
3. Tap the 💰 button
4. Choose "📧 Parse Email with AI"
5. Check the console for these logs:

**Expected Logs:**
```
SecureAPIManager: Loaded API key from Secrets-Development.xcconfig
AI Parser: API Key found: sk-proj-ae8Ct4t...
AI Parser: Starting AI email parsing...
AI Parser: Making API request to: https://api.openai.com/v1/chat/completions
AI Parser: API Response Status: 200
AI Parser: API Response received, parsing JSON...
AI Parser: Successfully parsed deal data
```

**If you see errors:**
- `AI Configuration Error: AI services not configured` → API key not loading
- `API Key Error: API key not available` → SecureAPIManager issue
- `API Error 401: Unauthorized` → Invalid API key
- `API Error 429: Rate limited` → Rate limit exceeded
- `JSON parsing failed` → AI response format issue

## Step 3: Test with Sample Image

### Create Test Image:
1. Take a screenshot of any email
2. Save it to Photos
3. Use it in the AI parser

### Expected Behavior:
1. Image picker opens
2. You select an image
3. Loading indicator appears
4. Form gets populated with parsed data
5. You can edit and save the deal

## Step 4: Debug Common Issues

### Issue 1: "AI services not configured"
**Cause**: API key not loading from xcconfig files
**Fix**: 
- Check that xcconfig files are in the app bundle
- Verify file names match SecureAPIManager expectations
- Check console for "SecureAPIManager: Loaded API key" message

### Issue 2: "API key not available"
**Cause**: SecureAPIManager not finding the key
**Fix**:
- Check that the app is running in DEBUG mode
- Verify the xcconfig files are properly formatted
- Check for typos in the API key

### Issue 3: "API Error 401: Unauthorized"
**Cause**: Invalid or expired API key
**Fix**:
- Verify the API key is correct
- Check if the key has expired
- Ensure the key has proper permissions

### Issue 4: "API Error 429: Rate limited"
**Cause**: Too many API requests
**Fix**:
- Wait a few minutes before trying again
- Check your OpenAI usage dashboard
- Consider upgrading your plan

### Issue 5: "JSON parsing failed"
**Cause**: AI response format issue
**Fix**:
- Check the raw API response in console
- Verify the AI is returning valid JSON
- Check if the prompt needs adjustment

## Step 5: Test the Complete Flow

### Test Steps:
1. **Build and Run**: Ensure app builds without errors
2. **Navigate to Deals**: Go to the "Deals" tab
3. **Add Deal**: Tap the 💰 button
4. **Choose AI Option**: Select "📧 Parse Email with AI"
5. **Select Image**: Choose an email screenshot
6. **Wait for Processing**: Watch for loading indicator
7. **Check Results**: Verify form is populated
8. **Save Deal**: Complete the deal creation

### Expected Results:
- ✅ Form fields populated with parsed data
- ✅ No error messages
- ✅ Deal saved successfully
- ✅ Deal appears in the deals list

## Step 6: Advanced Debugging

### Enable Verbose Logging:
The AI Email Parser now includes comprehensive logging. Check the console for:

```
AI Parser: Starting AI email parsing...
AI Parser: API Key found: sk-proj-ae8Ct4t...
AI Parser: Making API request to: https://api.openai.com/v1/chat/completions
AI Parser: API Response Status: 200
AI Parser: Raw API response: {"title": "Brand Partnership", ...}
AI Parser: Cleaned response: {"title": "Brand Partnership", ...}
AI Parser: Successfully parsed deal data
```

### Check Network Requests:
1. Open Xcode
2. Go to Debug → View Debugging → View Memory Graph
3. Look for network requests in the console
4. Check if the request is being made

### Verify Image Processing:
1. Check if the image is being converted to base64
2. Verify the image size is reasonable
3. Ensure the image format is supported

## Step 7: Troubleshooting Checklist

### ✅ Pre-flight Checks:
- [ ] App builds successfully
- [ ] API key is configured in all environments
- [ ] xcconfig files are in the app bundle
- [ ] SecureAPIManager is loading the key
- [ ] AI Configuration shows "configured" status

### ✅ Runtime Checks:
- [ ] Console shows API key loading
- [ ] No error messages in console
- [ ] Network request is made
- [ ] API returns 200 status
- [ ] JSON parsing succeeds
- [ ] Form gets populated

### ✅ User Experience Checks:
- [ ] Image picker opens
- [ ] Loading indicator appears
- [ ] No crashes or freezes
- [ ] Form fields are populated
- [ ] Deal can be saved

## Step 8: If All Else Fails

### Reset and Retry:
1. Clean build folder (Cmd+Shift+K)
2. Delete derived data
3. Restart Xcode
4. Build and run again

### Check OpenAI Dashboard:
1. Go to https://platform.openai.com/usage
2. Check if your API key is active
3. Verify you have remaining credits
4. Check for any rate limits

### Contact Support:
If the issue persists, provide:
- Console logs from the AI parser
- Screenshot of the error message
- Steps to reproduce the issue
- Device and iOS version

## Success Indicators

### ✅ Working Correctly:
- Console shows successful API key loading
- API request returns 200 status
- Form gets populated with parsed data
- No error messages
- Deal saves successfully

### ❌ Still Not Working:
- Check console for specific error messages
- Verify API key is correct and active
- Ensure network connectivity
- Check OpenAI service status

---

**Remember**: The AI Email Parser is now fully configured with your API key and should work immediately. If you're still seeing "failed to parse email", check the console logs for the specific error message and follow the troubleshooting steps above.
