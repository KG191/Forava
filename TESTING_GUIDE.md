# Universal Links + Apple Pay Testing Guide

## Configuration Status ✅

Your Universal Links and Apple Pay integration is now fully configured:

- **Team ID**: C6MJDCDAUG (updated in all files)
- **Associated Domain**: kg191.github.io 
- **Universal Links File**: https://kg191.github.io/Forava/apple-app-site-association
- **App IDs**: com.forava.app, com.forava.app.watchkitapp
- **Merchant ID**: merchant.C6MJDCDAUG.forava

## Apple Developer Portal Requirements

### 1. App ID Configuration
In Apple Developer Portal, ensure both App IDs have:
- **Associated Domains** capability enabled
- **Apple Pay Payment Processing** capability enabled (for iOS app)
- **In-App Purchase** capability enabled (for Watch app)

### 2. Merchant ID Setup
- Create Merchant ID: `merchant.C6MJDCDAUG.forava`
- Associate with both App IDs
- Upload merchant certificates for production

### 3. Provisioning Profiles
- Generate new provisioning profiles with updated capabilities
- Install on development devices

## Testing Workflow

### Phase 1: Universal Links Validation
1. **URL Structure Test**:
   ```
   https://kg191.github.io/Forava/pay?amount=101&desc=Rakhi%20Blessing%20Gift
   ```

2. **Device Testing**:
   - Open Safari on iOS device
   - Navigate to test URL
   - Should open Forava app (not stay in browser)
   - Watch app should also respond to same URL

### Phase 2: Messages Integration Test
1. **Create Rakhi in App**:
   - Open Forava app → Create new Rakhi
   - Tap "Send to Apple Watch"
   - Should open Messages with Rakhi image + payment link

2. **Recipient Experience**:
   - Receive message with Rakhi image
   - Tap the payment link
   - Should open Forava app with payment screen

### Phase 3: Apple Pay Integration Test
1. **Watch App Payment**:
   - Open payment link on Watch
   - Should trigger Apple Pay interface
   - Test with small amount (₹1 or ₹21)

2. **iOS App Payment**:
   - Open payment link on iPhone
   - Should show Apple Pay sheet
   - Verify merchant name displays as "Forava"

## Expected User Journey

```
Sender (iPhone)          Recipient (Apple Watch)
├── Create Rakhi        
├── "Send to Watch"     
├── Messages opens      
├── Share image + link  ──→  Receive message
                        ├── Tap payment link
                        ├── Apple Pay opens
                        ├── Authorize payment
                        └── Send blessing back
```

## Troubleshooting

### Universal Links Not Working
- Check provisioning profiles include Associated Domains
- Verify apple-app-site-association file accessibility
- Ensure app is installed via App Store/TestFlight (not Xcode)

### Apple Pay Issues
- Confirm Merchant ID exists in Developer Portal
- Verify device has payment method configured
- Check sandbox vs production environment settings

### Watch Connectivity Issues  
- Ensure both apps are installed and paired
- Test WatchConnectivity session is active
- Verify Watch app has Apple Pay capability enabled

## Cultural Context Validation

The app includes cultural elements for Raksha Bandhan:
- **Auspicious amounts**: ₹21, ₹51, ₹101, ₹201, ₹501, ₹1001
- **Cultural messaging**: "Rakhi Blessing Gift" descriptions
- **12-month token validity**: Tokens remain active for one year

## Next Steps

1. **Build and Deploy**: Create App Store Connect builds with updated entitlements
2. **TestFlight**: Invite testers to validate Universal Links end-to-end  
3. **Production Merchant Setup**: Configure production Apple Pay certificates
4. **User Acceptance Testing**: Test complete sender→recipient workflow

Your Universal Links configuration is ready for testing! 🎊