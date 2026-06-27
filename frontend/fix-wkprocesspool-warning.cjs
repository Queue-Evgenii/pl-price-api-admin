#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Path to the problematic file
const filePath = path.join(__dirname, 'node_modules/@capacitor/ios/CapacitorCordova/CapacitorCordova/Classes/Public/CDVWebViewProcessPoolFactory.h');

if (fs.existsSync(filePath)) {
  let content = fs.readFileSync(filePath, 'utf8');

  // Add availability annotation to suppress deprecation warning
  const updatedContent = content.replace(
    /@property \(nonatomic, retain\) WKProcessPool\* sharedPool;/,
    '@property (nonatomic, retain) WKProcessPool* sharedPool API_DEPRECATED("Creating and using multiple instances of WKProcessPool no longer has any effect", ios(10.0, 15.0));'
  ).replace(
    /-\(WKProcessPool\*\) sharedProcessPool;/,
    '-(WKProcessPool*) sharedProcessPool API_DEPRECATED("Creating and using multiple instances of WKProcessPool no longer has any effect", ios(10.0, 15.0));'
  );

  fs.writeFileSync(filePath, updatedContent);
  console.log('Fixed WKProcessPool deprecation warning in CDVWebViewProcessPoolFactory.h');
} else {
  console.log('File not found:', filePath);
}
