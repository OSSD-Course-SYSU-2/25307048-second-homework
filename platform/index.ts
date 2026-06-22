// 平台适配层 - 导出

export * from './common';

// 根据平台自动选择适配器
export function getPlatformAdapter(): import('./common').PlatformAdapter {
  // 检测平台
  const isHarmonyOS = typeof AppStorage !== 'undefined';
  
  if (isHarmonyOS) {
    // 动态导入HarmonyOS适配器
    return require('./harmonyos').createHarmonyAdapter();
  } else {
    // 动态导入Web适配器
    return require('./web').createWebAdapter();
  }
}