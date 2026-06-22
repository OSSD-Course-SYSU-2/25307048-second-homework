// Web平台适配器 - 设备

import { IDevice } from '../common/IDevice';

export class WebDevice implements IDevice {
  private listeners: Array<(width: number, height: number) => void> = [];
  
  getScreenWidth(): number {
    return window.innerWidth;
  }
  
  getScreenHeight(): number {
    return window.innerHeight;
  }
  
  getDevicePixelRatio(): number {
    return window.devicePixelRatio;
  }
  
  getPlatform(): 'harmonyos' | 'web' | 'android' | 'ios' | 'unknown' {
    const ua = navigator.userAgent;
    if (ua.includes('HarmonyOS')) {
      return 'harmonyos';
    }
    if (ua.includes('Android')) {
      return 'android';
    }
    if (ua.includes('iPhone') || ua.includes('iPad')) {
      return 'ios';
    }
    return 'web';
  }
  
  onScreenChange(callback: (width: number, height: number) => void): void {
    this.listeners.push(callback);
    
    window.addEventListener('resize', () => {
      this.listeners.forEach(cb => {
        cb(window.innerWidth, window.innerHeight);
      });
    });
  }
  
  offScreenChange(callback: (width: number, height: number) => void): void {
    const index = this.listeners.indexOf(callback);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }
}