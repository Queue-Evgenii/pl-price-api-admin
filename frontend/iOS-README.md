# iOS Build Guide

This guide provides instructions for building and running the pl-price-api-admin iOS application.

## 🚀 Quick Start

### Automated Deployment (Recommended)

Run the automated deployment script from the `frontend` directory:

```bash
./ios-deploy-clean.sh
```

This script will:
- Auto-bump version and sync environment
- Build the web application
- Apply all iOS fixes (WKProcessPool, Xcode project, icons)
- Sync with Capacitor
- Update iOS pods
- Start/restart iOS simulator
- Build and install the app
- Launch the application automatically

### Build Only (Manual Xcode Launch)

If you prefer to build and run manually from Xcode:

```bash
./ios-common.sh
```

Then:
1. Open `ios/App/App.xcworkspace` in Xcode
2. Select your target device/simulator
3. Press `Cmd+R` to run

## 📋 Script Structure

### iOS Scripts Overview

- **`ios-deploy-clean.sh`** - Main deployment script (analogous to `android-deploy-clean.sh`)
  - Handles version bumping via `version-setup.sh`
  - Builds and deploys to iOS simulator
  - Restarts simulator for clean deployment
  - Auto-launches the application

- **`ios-common.sh`** - Common build functions (analogous to `build-common.sh`)
  - Sets up Xcode environment
  - Applies all iOS fixes (WKProcessPool, Xcode project, icons)
  - Builds frontend assets
  - Syncs with Capacitor
  - Updates CocoaPods

- **`version-setup.sh`** - Version management (shared with Android)
  - Handles version bumping and environment sync
  - Supports patch/minor/major version bumps

### Manual Build Steps

If you prefer to build manually:

### 1. Install Dependencies
```bash
npm install
```

### 2. Apply WKProcessPool Fix
```bash
node fix-wkprocesspool-warning.cjs
```

### 3. Build Web App
```bash
npm run build
```

### 4. Sync with Capacitor
```bash
npx cap sync ios
```

### 5. Update iOS Pods
```bash
cd ios/App
pod install
cd ../..
```

### 6. Open in Xcode
```bash
open ios/App/App.xcworkspace
```

## 🔧 Common Issues and Solutions

### WKProcessPool Deprecation Warning

**Problem:** `'WKProcessPool' is deprecated: first deprecated in iOS 15.0`

**Solution:** The `fix-wkprocesspool-warning.cjs` script automatically applies `API_DEPRECATED` annotations to suppress this warning.

### [CP] Embed Pods Frameworks Warning

**Problem:** "Run script build phase '[CP] Embed Pods Frameworks' will be run during every build because it does not specify any outputs"

**Solution:** The build script automatically adds output dependencies to the Xcode project file.

### App Icon Size Issues

**Problem:** "AppIcon-57@2x.png is 60x60 but should be 114x114"

**Solution:** The build script automatically resizes the icon and updates the Contents.json file.

## 📱 Testing on iOS Simulator

### Available Simulators
Default simulator: **iPhone 15 Pro**

You can specify a different simulator:
```bash
./ios-deploy-clean.sh "iPhone 14 Pro"
./ios-deploy-clean.sh "iPad Pro (12.9-inch)"
./ios-deploy-clean.sh "iPhone SE (3rd generation)"
```

To list all available simulators:
```bash
xcrun simctl list devices | grep -E "iPhone|iPad" | grep -v "unavailable"
```

### Running the App

#### Automated (Recommended)
```bash
./ios-deploy-clean.sh
```

#### Manual
1. Open Xcode project (`ios/App/App.xcworkspace`)
2. Select desired simulator from device dropdown
3. Press `Cmd+R` or click "Run" button

## 🛠 Development Workflow

### Making Changes to Web App
1. Make changes to Vue.js source code
2. Run `npm run build` to compile
3. Run `npx cap sync ios` to copy to iOS project
4. Run the app in Xcode

### Making Changes to Native iOS Code
1. Make changes to Swift/Objective-C files in `ios/App/App/`
2. Build and run directly from Xcode

### Adding New Capacitor Plugins
1. Install plugin: `npm install @capacitor/plugin-name`
2. Sync: `npx cap sync ios`
3. Install pods: `cd ios/App && pod install`

## 📦 Project Structure

```
frontend/
├── ios/
│   └── App/
│       ├── App/                    # Main iOS app source
│       ├── App.xcodeproj/         # Xcode project file
│       ├── App.xcworkspace/       # Xcode workspace (use this)
│       ├── Podfile                # CocoaPods dependencies
│       ├── Pods/                  # Installed pods
│       └── DerivedData/           # Build output (auto-generated)
├── src/                           # Vue.js source code
├── public/                        # Static assets
├── ios-deploy-clean.sh            # Main deployment script
├── ios-common.sh                  # Common build functions
├── ios-build.sh                   # Legacy build script (deprecated)
├── fix-wkprocesspool-warning.cjs  # WKProcessPool fix script
├── version-setup.sh               # Version management (shared with Android)
└── iOS-README.md                  # This file
```

## 🔧 Script Usage Examples

### Quick Deploy with Default Simulator
```bash
./ios-deploy-clean.sh
```

### Deploy to Specific Simulator
```bash
./ios-deploy-clean.sh "iPhone 14 Pro"
./ios-deploy-clean.sh "iPad Pro (12.9-inch)"
```

### Build Only (Manual Xcode Launch)
```bash
./ios-common.sh
```

### Version Management
```bash
# Bump patch version and deploy
./version-setup.sh bump
./ios-deploy-clean.sh

# Bump minor version and deploy
./version-setup.sh bump-minor
./ios-deploy-clean.sh
```

## 🔍 Debugging

### Console Logs
- Web app logs: Safari → Develop → [Simulator Name] → Console
- Native iOS logs: Xcode → Debug Area → Console

### Common Debug Locations
- Capacitor logs: Safari Web Inspector Console
- Native crashes: Xcode → Debug Navigator
- Build issues: Xcode → Report Navigator

## 📱 Deployment

### Building for Device
1. Connect physical iOS device
2. Select device in Xcode
3. Change team signing settings in project settings
4. Build and run

### App Store Distribution
1. Archive the app: `Product → Archive`
2. Upload to App Store Connect
3. Complete App Store submission process

## 🔄 Version Management

### Updating Capacitor
```bash
npm install @capacitor/ios@latest
npm install @capacitor/cli@latest
npx cap sync ios
```

### Updating Dependencies
```bash
npm update
npx cap sync ios
cd ios/App && pod update
```

## 📞 Support

If you encounter issues not covered in this guide:

1. Check Xcode build logs for detailed error messages
2. Verify all dependencies are up to date
3. Try cleaning the build folder (`Cmd+Shift+K` in Xcode)
4. Delete and reinstall pods if needed

---

**Last Updated:** May 2026  
**Compatible with:** Capacitor 6.x, iOS 15.0+
