# Environment Setup Guide

## 🔑 API Keys Configuration

### Method 1: .env File (Recommended)

1. **Copy the template**:
   ```bash
   cp .env.example .env
   ```

2. **Edit .env file** and replace `your_replicate_api_token_here` with your actual Replicate API token:
   ```
   REPLICATE_API_TOKEN=r8_your_actual_token_here
   APPLE_TEAM_ID=YOUR_TEAM_ID_HERE
   ```

3. **Add .env to Xcode project**:
   - Drag `.env` file into Xcode project
   - Make sure it's added to the target bundle
   - ⚠️ **DO NOT commit .env file to Git** (it's in .gitignore)

### Method 2: Xcode Environment Variables

1. **Edit Scheme in Xcode**:
   - Product → Scheme → Edit Scheme
   - Select "Run" → "Arguments" → "Environment Variables"
   - Add: `REPLICATE_API_TOKEN` = `your_token_here`

### Method 3: System Environment Variables

```bash
export REPLICATE_API_TOKEN=your_token_here
```

## 🛡️ Security Best Practices

✅ **Do**:
- Use .env files for local development
- Add .env to .gitignore
- Use environment variables for production
- Regenerate API keys if exposed

❌ **Don't**:
- Hardcode API keys in source code
- Commit .env files to Git
- Share API keys in chat/email
- Use production keys for development

## 📁 File Structure

```
Forava/
├── .env.example          # Template file (safe to commit)
├── .env                  # Your actual keys (never commit)
├── .gitignore           # Excludes .env files
└── ForavaApp/
    └── Services/
        └── AIRakhiService.swift  # Reads from .env
```

## 🔍 Troubleshooting

**"No API key found" error**:
1. Check .env file exists and has correct format
2. Verify .env is added to Xcode project target
3. Try Method 2 (Xcode environment variables)
4. Check console for detailed error messages

**API calls failing**:
1. Verify your Replicate API token is valid
2. Check Replicate account has sufficient credits
3. Test token at https://replicate.com/account/api-tokens

## 🚀 Production Deployment

For App Store builds:
1. Use Xcode environment variables (Method 2)
2. Or configure CI/CD to inject environment variables
3. Never include .env files in production builds