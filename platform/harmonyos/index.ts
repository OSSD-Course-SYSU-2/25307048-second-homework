// HarmonyOS平台适配器 - 导出

import { PlatformAdapter } from '../common';
import { HarmonyStorage } from './HarmonyStorage';
import { HarmonyDevice } from './HarmonyDevice';
import { HarmonyToast } from './HarmonyToast';

export * from './HarmonyStorage';
export * from './HarmonyDevice';
export * from './HarmonyToast';

// 创建HarmonyOS平台适配器
export function createHarmonyAdapter(): PlatformAdapter {
  return {
    storage: new HarmonyStorage(),
    device: new HarmonyDevice(),
    share: {
      async shareText(text: string) {
        console.log('Share text:', text);
      },
      async shareImage(imageUrl: string) {
        console.log('Share image:', imageUrl);
      },
      async shareTo(platform: string, data: any) {
        console.log('Share to:', platform, data);
      }
    },
    toast: new HarmonyToast()
  };
}