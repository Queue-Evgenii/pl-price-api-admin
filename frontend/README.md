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
