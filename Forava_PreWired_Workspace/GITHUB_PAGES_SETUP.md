# GitHub Pages Setup for Universal Links

This guide will help you enable GitHub Pages for the Forava Universal Links functionality.

## Files Updated in This Implementation

### Core Implementation Files:
- `Shared/AppConfig.swift` - Universal Links & Apple Pay configuration
- `ForavaApp/App.swift` - Universal Link handling
- `ForavaApp/Views/RakhiDesignStudioView.swift` - Updated "Send to Watch" flow
- `ForavaApp/Forava_iOS.entitlements` - iOS entitlements with Associated Domains

### Apple Watch Files:
- `ForavaWatch/ApplePayManager.swift` - Apple Pay integration
- `ForavaWatch/ApplePayDeepLinkRouter.swift` - Deep link routing
- `ForavaWatch/PayPosterView.swift` - Watch payment interface
- `ForavaWatch/WatchPayApp.swift` - Watch app main file
- `ForavaWatch/PaymentRequestWatchView.swift` - Watch payment UI
- `ForavaWatch/WatchConnectivityManager.swift` - Enhanced connectivity
- `ForavaWatch/Forava_Watch.entitlements` - Watch entitlements

### GitHub Pages Files:
- `.well-known/apple-app-site-association` - Universal Links configuration
- `web/apple-app-site-association` - Alternative location
- `UNIVERSAL_LINKS_DEPLOYMENT.md` - Deployment instructions

## GitHub Pages Setup Steps

1. **Commit and Push All Changes**:
   ```bash
   git add .
   git commit -m "Add Universal Links implementation with Apple Pay integration"
   git push origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your GitHub repository: https://github.com/KG191/Forava
   - Click Settings tab
   - Scroll to "Pages" section
   - Source: "Deploy from a branch"
   - Branch: "main"
   - Folder: "/ (root)"
   - Click "Save"

3. **Test the apple-app-site-association file**:
   - Wait 2-3 minutes after enabling Pages
   - Visit: `https://kg191.github.io/Forava/.well-known/apple-app-site-association`
   - Should show JSON content

4. **Optional: Add Custom Domain**:
   - In Pages settings, add custom domain: `forava.app`
   - Configure DNS at your domain registrar

## Next Steps

1. **Update Team ID**: Replace "TEAMID" in entitlements and apple-app-site-association with your actual Apple Developer Team ID
2. **Apple Developer Portal**: Configure Merchant ID and Associated Domains
3. **Test**: Install app and test Universal Links on device

## URL Format

Universal Links will work with this format:
```
https://forava.app/pay?amount=101&desc=Rakhi%20Gift&sender=John&rakhi_id=12345
```

This will:
- Open the Forava app on iOS
- Open the Watch app and present Apple Pay on Apple Watch