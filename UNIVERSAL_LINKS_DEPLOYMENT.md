# Universal Links Deployment Guide

## 1. Apple Developer Portal Setup

### Apple Pay Configuration
1. Create Merchant ID: `merchant.com.forava.app`
2. Generate Merchant Identity Certificate
3. Create Payment Processing Certificate

### App IDs Configuration
1. **iOS App ID**: `com.forava.app`
   - Enable: Associated Domains, Apple Pay
   - Set Merchant IDs: `merchant.com.forava.app`

2. **watchOS App ID**: `com.forava.app.watchkitapp`  
   - Enable: Associated Domains, Apple Pay
   - Set Merchant IDs: `merchant.com.forava.app`

### Provisioning Profiles
- Create App Store/Development profiles for both iOS and watchOS targets
- Include the Associated Domains and Apple Pay entitlements

## 2. Web Server Setup

### Deploy apple-app-site-association
1. Upload `web/apple-app-site-association` to your web server
2. Host at: `https://forava.app/.well-known/apple-app-site-association`
3. **Important**: Serve with `Content-Type: application/json`
4. **Important**: No file extension required
5. Replace `TEAMID` with your actual Team ID from Apple Developer Portal

### DNS Configuration
- Ensure `forava.app` and `www.forava.app` both resolve correctly
- SSL certificate required (HTTPS only)

### Server Requirements
```nginx
# Nginx configuration example
location /.well-known/apple-app-site-association {
    add_header Content-Type application/json;
    return 200 '{"applinks":{"apps":[],"details":[{"appID":"TEAMID.com.forava.app","paths":["/pay/*","/pay","/rakhi/*","/gift/*"]},{"appID":"TEAMID.com.forava.app.watchkitapp","paths":["/pay/*","/pay"]}]},"webcredentials":{"apps":["TEAMID.com.forava.app"]}}';
}
```

## 3. Xcode Project Configuration

### Update Team ID
1. Replace `TEAMID` in entitlements files with your actual Team ID
2. Update Bundle IDs to match your Apple Developer account

### Build Settings
1. **iOS Target**:
   - Associated Domains: `applinks:forava.app applinks:www.forava.app`
   - Apple Pay: `merchant.com.forava.app`

2. **watchOS Target**:
   - Associated Domains: `applinks:forava.app applinks:www.forava.app`
   - Apple Pay: `merchant.com.forava.app`

### Code Signing
- Select correct Provisioning Profiles with Associated Domains enabled
- Ensure Apple Pay capability is enabled in both targets

## 4. Testing Universal Links

### Validation Tools
1. **Apple's Validator**: Use Apple's Associated Domains Debug tool
2. **Manual Testing**: 
   ```bash
   curl -v https://forava.app/.well-known/apple-app-site-association
   ```

### Device Testing
1. Install app on iOS device and paired Apple Watch
2. Send test URL via Messages: `https://forava.app/pay?amount=101&desc=Test`
3. Tap link - should open Watch app and present Apple Pay

### Debug Tips
- Check Console.app for Universal Link debug messages
- Links must be tapped, not pasted into browsers
- Clear app data if links stop working during development

## 5. Production Checklist

- [ ] Apple Pay merchant account configured and verified
- [ ] SSL certificate installed on forava.app
- [ ] apple-app-site-association file accessible via HTTPS
- [ ] Team ID updated in all configuration files
- [ ] App Store provisioning profiles created
- [ ] Both iOS and watchOS apps signed with production certificates
- [ ] Universal Links tested on physical devices
- [ ] Payment flow tested with real Apple Pay cards

## 6. Monitoring & Analytics

### Track Universal Link Performance
- Monitor link click rates vs app opens
- Track Apple Pay conversion rates
- Log Universal Link routing for debugging

### Error Handling
- Graceful fallback if Apple Pay unavailable
- Clear error messages for payment failures
- Retry mechanism for network issues

## Security Notes

- Universal Links are secured by HTTPS and domain ownership
- Apple Pay tokens are encrypted and processed securely
- No sensitive data should be passed in URL parameters
- Always validate payment amounts server-side