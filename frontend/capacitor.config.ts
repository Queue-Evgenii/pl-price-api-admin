import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.priceapi.admin',
  appName: 'Poland Group Materials',
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
    scheme: 'Poland Group Materials'
  },
  android: {
    webContentsDebuggingEnabled: false
  }
};

export default config;
