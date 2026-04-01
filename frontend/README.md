# Vue 3 + TypeScript + Vite

This template should help get you started developing with Vue 3 and TypeScript in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

Learn more about the recommended Project Setup and IDE Support in the [Vue Docs TypeScript Guide](https://vuejs.org/guide/typescript/overview.html#project-setup).

## Android debug deploy (APK + emulator)

For layout testing in Android WebView:

```bash
npm run android:deploy
```

What this script does:
- builds frontend assets
- syncs Capacitor Android project
- builds debug APK
- starts Android emulator (if no connected device)
- installs and launches the app

If you need to inspect/debug layout in the running app, open:

`chrome://inspect/#devices`

## Build APK for Manual Testing

For creating a debug APK file that can be manually installed on an Android device:

```bash
npm run build-apk
```

What this script does:
- builds frontend assets
- syncs Capacitor Android project
- creates debug APK for manual installation
- provides installation instructions
- optionally installs via ADB if device is connected

**APK File Location:** `android/app/build/outputs/apk/debug/pl-price-[version]-[timestamp].apk`

**Installation:**
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Transfer the APK file to your phone and install it
4. Or use ADB: `adb install android/app/build/outputs/apk/debug/*.apk`

## Automated Version Management & Build

For automatic version bumping and APK building in one command:

```bash
npm run build-auto          # Auto-bump patch version + build APK
npm run build-auto patch    # Auto-bump patch version + build APK
npm run build-auto minor    # Auto-bump minor version + build APK
npm run build-auto major    # Auto-bump major version + build APK
npm run build-auto 1.2.3    # Set specific version + build APK
```

**Version Management Commands:**
```bash
npm run version:current     # Show current version
npm run version:bump:patch  # Bump patch version (1.0.1 -> 1.0.2)
npm run version:bump:minor  # Bump minor version (1.0.1 -> 1.1.0)
npm run version:bump:major  # Bump major version (1.0.1 -> 2.0.0)
npm run version:set 1.2.3   # Set specific version
```

**What `build-auto` does automatically:**
1. Bumps version according to specified type
2. Updates package.json and .env files
3. Shows new version information
4. Builds APK with new version
5. Shows APK location and installation info
