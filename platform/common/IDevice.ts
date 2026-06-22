// 平台适配接口 - 设备信息接口

export interface IDevice {
  // 获取屏幕宽度
  getScreenWidth(): number;
  
  // 获取屏幕高度
  getScreenHeight(): number;
  
  // 获取设备像素比
  getDevicePixelRatio(): number;
  
  // 获取平台类型
  getPlatform(): 'harmonyos' | 'web' | 'android' | 'ios' | 'unknown';
  
  // 监听屏幕尺寸变化
  onScreenChange(callback: (width: number, height: number) => void): void;
  
  // 移除监听
  offScreenChange(callback: (width: number, height: number) => void): void;
}