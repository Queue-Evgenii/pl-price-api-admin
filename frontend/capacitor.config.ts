import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.priceapi.admin',
  appName: 'PL Price',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    CapacitorHttp: {
      enabled: true
    }
  },
  ios: {
    scheme: 'PL Price'
  },
  android: {
    webContentsDebuggingEnabled: true
  }
};

export default config;
