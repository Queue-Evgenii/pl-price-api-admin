#!/usr/bin/env node

// Version management script for automated version bumping
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Configuration files
const PACKAGE_JSON_PATH = path.join(__dirname, 'package.json');
const CAPACITOR_CONFIG_PATH = path.join(__dirname, 'capacitor.config.ts');

// Current version info
let currentVersion = '0.0.0';
let currentVersionCode = 1;

function getCurrentVersion() {
  try {
    const packageJson = JSON.parse(fs.readFileSync(PACKAGE_JSON_PATH, 'utf8'));
    currentVersion = packageJson.version || '0.0.0';
    
    // Extract version code from package.json version or use default
    const versionParts = currentVersion.split('.');
    if (versionParts.length === 3) {
      // Generate version code from version: major.minor.patch -> (major * 100 + minor) * 100 + patch
      currentVersionCode = (parseInt(versionParts[0]) * 100 + parseInt(versionParts[1])) * 100 + parseInt(versionParts[2]);
    }
  } catch (error) {
    console.error('Error reading current version:', error.message);
  }
}

function bumpVersion(type = 'patch') {
  const parts = currentVersion.split('.').map(Number);
  
  switch (type) {
    case 'major':
      parts[0] += 1;
      parts[1] = 0;
      parts[2] = 0;
      break;
    case 'minor':
      parts[1] += 1;
      parts[2] = 0;
      break;
    case 'patch':
    default:
      parts[2] += 1;
      break;
  }
  
  return parts.join('.');
}

function updatePackageJson(newVersion) {
  try {
    const packageJson = JSON.parse(fs.readFileSync(PACKAGE_JSON_PATH, 'utf8'));
    packageJson.version = newVersion;
    fs.writeFileSync(PACKAGE_JSON_PATH, JSON.stringify(packageJson, null, 2));
    console.log(`✓ Updated package.json version to ${newVersion}`);
  } catch (error) {
    console.error('Error updating package.json:', error.message);
    process.exit(1);
  }
}

function calculateVersionCode(version) {
  const parts = version.split('.').map(Number);
  return (parts[0] * 100 + parts[1]) * 100 + parts[2];
}

function setEnvironmentVariables(version) {
  const versionCode = calculateVersionCode(version);
  const envPath = path.join(__dirname, '.env');
  
  // Read existing .env content if file exists
  let existingEnv = {};
  if (fs.existsSync(envPath)) {
    const envContent = fs.readFileSync(envPath, 'utf8');
    envContent.split('\n').forEach(line => {
      const match = line.match(/^([^=]+)=(.*)$/);
      if (match) {
        existingEnv[match[1]] = match[2];
      }
    });
  }
  
  // Update only version variables, preserve all others
  existingEnv['APP_VERSION_NAME'] = version;
  existingEnv['APP_VERSION_CODE'] = versionCode.toString();
  
  // Write back all variables
  const newEnvContent = Object.entries(existingEnv)
    .map(([key, value]) => `${key}=${value}`)
    .join('\n') + '\n';
  
  fs.writeFileSync(envPath, newEnvContent);
  console.log(`✓ Set environment variables: APP_VERSION_NAME=${version}, APP_VERSION_CODE=${versionCode}`);
  
  return { version, versionCode };
}

function printUsage() {
  console.log(`
Usage: node version-manager.js [command] [type]

Commands:
  bump [type]    Bump version (default: patch)
  set <version>  Set specific version
  current        Show current version
  env            Set environment variables for current version

Types:
  major          Bump major version (1.0.0 -> 2.0.0)
  minor          Bump minor version (1.0.0 -> 1.1.0)
  patch          Bump patch version (1.0.0 -> 1.0.1)

Examples:
  node version-manager.js bump patch    # 1.0.0 -> 1.0.1
  node version-manager.js bump minor    # 1.0.0 -> 1.1.0
  node version-manager.js set 1.0.1     # Set to 1.0.1
  node version-manager.js current       # Show current version
  `);
}

// Main execution
const args = process.argv.slice(2);
const command = args[0];

getCurrentVersion();

if (!command || command === 'help') {
  printUsage();
  process.exit(0);
}

switch (command) {
  case 'current':
    console.log(`Current version: ${currentVersion} (code: ${currentVersionCode})`);
    break;
    
  case 'env':
    setEnvironmentVariables(currentVersion);
    break;
    
  case 'set':
    const newVersion = args[1];
    if (!newVersion || !/^\d+\.\d+\.\d+$/.test(newVersion)) {
      console.error('Invalid version format. Use format: X.Y.Z');
      process.exit(1);
    }
    updatePackageJson(newVersion);
    setEnvironmentVariables(newVersion);
    console.log(`✓ Version set to ${newVersion}`);
    break;
    
  case 'bump':
    const bumpType = args[1] || 'patch';
    if (!['major', 'minor', 'patch'].includes(bumpType)) {
      console.error('Invalid bump type. Use: major, minor, or patch');
      process.exit(1);
    }
    
    const bumpedVersion = bumpVersion(bumpType);
    updatePackageJson(bumpedVersion);
    setEnvironmentVariables(bumpedVersion);
    console.log(`✓ Version bumped from ${currentVersion} to ${bumpedVersion}`);
    break;
    
  default:
    console.error(`Unknown command: ${command}`);
    printUsage();
    process.exit(1);
}
