// HarmonyOS平台适配器 - 设备

import { IDevice } from '../common/IDevice';
import display from '@ohos.display';

export class HarmonyDevice implements IDevice {
  private listeners: Array<(width: number, height: number) => void> = [];
  
  getScreenWidth(): number {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      return defaultDisplay.width;
    } catch (error) {
      return 360;
    }
  }
  
  getScreenHeight(): number {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      return defaultDisplay.height;
    } catch (error) {
      return 640;
    }
  }
  
  getDevicePixelRatio(): number {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      return defaultDisplay.densityDPI / 160;
    } catch (error) {
      return 2;
    }
  }
  
  getPlatform(): 'harmonyos' | 'web' | 'android' | 'ios' | 'unknown' {
    return 'harmonyos';
  }
  
  onScreenChange(callback: (width: number, height: number) => void): void {
    this.listeners.push(callback);
    
    try {
      display.on('change', (displayId: number) => {
        const defaultDisplay = display.getDefaultDisplaySync();
        this.listeners.forEach(cb => {
          cb(defaultDisplay.width, defaultDisplay.height);
        });
      });
    } catch (error) {
      console.error('Screen change listener error:', error);
    }
  }
  
  offScreenChange(callback: (width: number, height: number) => void): void {
    const index = this.listeners.indexOf(callback);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }
}