# Build & share beta APK

## Version

Check `pubspec.yaml` — beta track: `0.2.0+2` (bump `+` for each new APK).

## Build

```bash
export PATH="$PATH:$HOME/development/flutter/bin"
cd /path/to/appocrm
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## Share safely

- Upload APK to **Google Drive** or **Firebase App Distribution** (optional)
- Send **only to waitlist** numbers from Phase 0
- Include: install steps, “enable notifications”, link to feedback form

## Install instructions (copy to WhatsApp)

> 1. Download the APK I sent  
> 2. Allow “Install unknown apps” for Chrome/Drive if asked  
> 3. Open Appomatrix → complete 3 intro screens  
> 4. Go to **More → Follow-up reminders → Allow**  
> 5. Add one real customer and try a voice note after a call  
> 6. Fill the feedback form if anything breaks  

## Before public Play (Phase 3)

- Create **upload keystore** (do not commit `key.properties` or `.jks`)
- Switch release `signingConfig` from debug to release in `android/app/build.gradle.kts`
