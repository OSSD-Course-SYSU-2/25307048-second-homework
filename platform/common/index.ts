// 平台适配接口 - 导出

export * from './IStorage';
export * from './IDevice';
export * from './IShare';
export * from './IToast';

// 平台适配器接口
export interface PlatformAdapter {
  storage: import('./IStorage').IStorage;
  device: import('./IDevice').IDevice;
  share: import('./IShare').IShare;
  toast: import('./IToast').IToast;
}