# Notification Sound Files

This directory contains custom notification sounds for Forava cultural notifications.

## Required Sound Files

The following sound files are required for cultural notifications:

| File Name | Cultural Context | Description |
|-----------|------------------|-------------|
| `temple_bell.caf` | Hindu (Raksha Bandhan, Diwali) | Traditional temple bell sound |
| `wind_chime.caf` | Chinese (Chinese New Year) | Gentle wind chime sound |
| `jingle_bell.caf` | Christian (Christmas) | Festive jingle bell sound |

## Sound File Requirements

- **Format:** CAF (Core Audio Format)
- **Duration:** 1-5 seconds (recommended)
- **Sample Rate:** 44100 Hz or 48000 Hz
- **Channels:** Mono or Stereo
- **Bit Depth:** 16-bit or 24-bit

## Creating CAF Files

### From AIFF/WAV using afconvert (macOS Terminal):

```bash
# Convert from WAV to CAF
afconvert input.wav output.caf -d LEI16 -f caff

# Convert from AIFF to CAF
afconvert input.aiff output.caf -d LEI16 -f caff

# Convert from MP3 to CAF
afconvert input.mp3 output.caf -d LEI16 -f caff
```

### From any format using ffmpeg:

```bash
ffmpeg -i input.mp3 -c:a pcm_s16le output.caf
```

## Adding Sound Files to Project

1. Place the `.caf` files in this directory
2. In Xcode, add the files to the ForavaApp target:
   - Right-click on this folder in Xcode
   - Select "Add Files to Forava..."
   - Ensure "Copy items if needed" is checked
   - Ensure "Add to targets: ForavaApp" is checked

## Sourcing Royalty-Free Sounds

Consider these sources for culturally-appropriate sounds:

- **Freesound.org** - Community-contributed sounds (check license)
- **Pixabay** - Royalty-free sound effects
- **Zapsplat** - Free sound effects library

**Important:** Ensure all sounds are royalty-free or properly licensed for commercial use.

## Testing Sound Files

After adding sound files, test them using:

1. Run the app on a physical device (simulator may have issues)
2. Trigger a test notification
3. Verify the correct sound plays for each cultural context

## Fallback Behavior

If a custom sound file is not found, the system will fall back to `UNNotificationSound.default`.
