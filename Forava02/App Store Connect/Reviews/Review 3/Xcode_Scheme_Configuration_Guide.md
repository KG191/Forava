# Xcode Scheme Configuration Guide - API Keys for TestFlight & Production

## Problem Statement

AI image generation fails in TestFlight builds because API keys (OpenAI, Replicate) are not available in the production environment. The app currently loads API keys from:
1. Environment variables (not set in archived builds)
2. UserDefaults (not persisted in TestFlight)
3. Info.plist (not secure for API keys)
4. .env file (not included in app bundle)

**Solution:** Configure API keys as environment variables in Xcode schemes for both Run (development) and Archive (production/TestFlight) builds.

---

## ⚙️ STEP-BY-STEP CONFIGURATION

### Part 1: Configure Run Scheme (Development & Testing)

This ensures API keys are available when running the app in Xcode simulator or on a connected device.

#### Steps:

1. **Open Forava Project in Xcode**
   ```bash
   cd /Users/kirangokal/Documents/Forava/Forava02
   open Forava.xcodeproj
   ```

2. **Access Scheme Editor**
   - In Xcode menu bar: **Product → Scheme → Edit Scheme...**
   - Or use keyboard shortcut: **⌘ + <** (Command + Less Than)

3. **Select Run Section**
   - In the left sidebar, click **"Run"**
   - Make sure "Build Configuration" is set to **Debug**

4. **Navigate to Arguments Tab**
   - At the top, click the **"Arguments"** tab

5. **Add Environment Variables**
   - Under **"Environment Variables"** section, click the **"+"** button twice
   - Add the following variables:

   | Name | Value |
   |------|-------|
   | `OPENAI_API_KEY` | Your OpenAI API key (starts with sk-...) |
   | `REPLICATE_API_TOKEN` | Your Replicate API token (starts with r8_...) |

6. **Enable for All Schemes**
   - ✅ Check **"Use run scheme's arguments and environment variables"**

7. **Save Changes**
   - Click **"Close"** to save the scheme

---

### Part 2: Configure Archive Scheme (TestFlight & App Store)

**CRITICAL:** This step ensures API keys are available in TestFlight builds and production releases.

#### Steps:

1. **Access Scheme Editor Again**
   - **Product → Scheme → Edit Scheme...** (or **⌘ + <**)

2. **Select Archive Section**
   - In the left sidebar, click **"Archive"**
   - Make sure "Build Configuration" is set to **Release**

3. **Navigate to Arguments Tab**
   - At the top, click the **"Arguments"** tab

4. **Add Environment Variables (Same as Run Scheme)**
   - Under **"Environment Variables"** section, click the **"+"** button twice
   - Add the **exact same variables** as in the Run scheme:

   | Name | Value |
   |------|-------|
   | `OPENAI_API_KEY` | Your OpenAI API key (starts with sk-...) |
   | `REPLICATE_API_TOKEN` | Your Replicate API token (starts with r8_...) |

   ⚠️ **Important:** These MUST match the Run scheme values exactly.

5. **Save Changes**
   - Click **"Close"** to save the scheme

---

### Part 3: Verify Configuration

#### Test in Simulator:

1. **Clean Build Folder**
   - **Product → Clean Build Folder** (or **⌘ + Shift + K**)

2. **Run App in Simulator**
   - Select **ForavaApp** scheme
   - Choose **iPhone 15 Pro** (or any simulator)
   - Click **Run** (or **⌘ + R**)

3. **Test Image Generation**
   - Complete onboarding
   - Select a cultural event and contact
   - Generate an AI gift
   - Verify image appears without errors

#### Check Console for API Key Loading:

Look for log messages like:
```
✅ API Key loaded from: Environment Variable
```

If you see:
```
❌ API Key missing or empty
```
Then the environment variables are not configured correctly.

---

### Part 4: Archive for TestFlight

#### Create Archive with API Keys:

1. **Select Generic iOS Device**
   - In Xcode toolbar, select **"Any iOS Device (arm64)"**

2. **Archive the App**
   - **Product → Archive**
   - Wait for the archive to complete (5-10 minutes)

3. **Verify Archive Settings**
   - Xcode Organizer will open
   - Select your archive
   - Click **"Distribute App"**

4. **Upload to App Store Connect**
   - Choose **"App Store Connect"**
   - Select **"Upload"**
   - Follow the prompts to upload

5. **TestFlight Testing**
   - Wait for processing (30-60 minutes)
   - Install build on physical device via TestFlight
   - Test image generation to verify API keys work

---

## 🔐 SECURITY CONSIDERATIONS

### ⚠️ IMPORTANT: Xcode Scheme Security

**Schemes are saved in:**
```
/Users/kirangokal/Documents/Forava/Forava02/Forava.xcodeproj/xcshareddata/xcschemes/ForavaApp.xcscheme
```

**Security Implications:**

1. **Shared Schemes** (checked into Git):
   - ❌ **DO NOT commit shared schemes with API keys**
   - API keys will be visible in the Git repository
   - Anyone with access to the repo can see your keys

2. **User Schemes** (local only):
   - ✅ **RECOMMENDED:** Use user schemes for API key configuration
   - Stored in: `xcuserdata/<username>.xcuserdatad/`
   - Not checked into Git (in .gitignore by default)

### How to Create a User Scheme:

1. **Edit Scheme → Manage Schemes**
2. **Uncheck "Shared"** for ForavaApp scheme
3. This moves the scheme to `xcuserdata/` (not committed to Git)
4. Add API keys to this user-specific scheme

---

## 🔄 ALTERNATIVE SOLUTIONS (For Future Consideration)

### Option 1: Xcode Cloud Environment Variables

Configure API keys in **App Store Connect → Xcode Cloud → Environment**:
- Advantage: Keys stored securely in Apple's cloud
- Disadvantage: Only works with Xcode Cloud builds

### Option 2: Secure Keychain Storage

Store API keys in iOS Keychain:
- Advantage: Most secure option
- Disadvantage: Requires initial key setup (one-time manual entry)

### Option 3: Backend API Proxy

Create a backend service to proxy AI API calls:
- Advantage: No API keys in the app at all
- Disadvantage: Requires server infrastructure

---

## 📋 CONFIGURATION CHECKLIST

Use this checklist to verify your configuration:

- [ ] Opened Xcode project: `Forava.xcodeproj`
- [ ] Edited ForavaApp scheme (**Product → Scheme → Edit Scheme**)
- [ ] Added `OPENAI_API_KEY` to **Run → Arguments → Environment Variables**
- [ ] Added `REPLICATE_API_TOKEN` to **Run → Arguments → Environment Variables**
- [ ] Checked **"Use run scheme's arguments and environment variables"**
- [ ] Added same variables to **Archive → Arguments → Environment Variables**
- [ ] Saved and closed scheme editor
- [ ] Cleaned build folder (**⌘ + Shift + K**)
- [ ] Tested in simulator - image generation works ✅
- [ ] Created archive with **Product → Archive**
- [ ] Uploaded to TestFlight
- [ ] Tested on physical device via TestFlight ✅

---

## 🐛 TROUBLESHOOTING

### Issue: "API Key Missing" in TestFlight

**Symptoms:**
- Image generation works in Xcode
- Fails in TestFlight with "API Key Missing" error

**Solution:**
1. Verify Archive scheme has environment variables set
2. Clean build folder and create new archive
3. Check console logs in TestFlight for key loading messages

### Issue: "Use run scheme's arguments..." is grayed out

**Cause:** You're in the Archive section, not Run section.

**Solution:**
- Environment variable option is only in **Run** section
- For **Archive**, just add the variables directly (no checkbox)

### Issue: API keys visible in Git history

**Solution:**
1. Remove API keys from shared scheme
2. Revert the commit that exposed keys
3. Rotate your API keys (generate new ones)
4. Use user scheme instead of shared scheme

---

## 📞 NEED HELP?

If you encounter issues:
1. Check Xcode console for specific error messages
2. Verify API keys are valid (test in Postman/curl)
3. Contact OpenAI/Replicate support for API issues
4. Email developer: foravaapp@gmail.com

---

**Document Version:** 1.0
**Created:** November 27, 2025
**Last Updated:** November 27, 2025
