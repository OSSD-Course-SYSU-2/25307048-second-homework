// Web平台适配器 - 导出

import { PlatformAdapter } from '../common';
import { WebStorage } from './WebStorage';
import { WebDevice } from './WebDevice';
import { WebToast } from './WebToast';

export * from './WebStorage';
export * from './WebDevice';
export * from './WebToast';

// 创建Web平台适配器
export function createWebAdapter(): PlatformAdapter {
  return {
    storage: new WebStorage(),
    device: new WebDevice(),
    share: {
      async shareText(text: string) {
        if (navigator.share) {
          await navigator.share({ text });
        } else {
          console.log('Share not supported, text:', text);
        }
      },
      async shareImage(imageUrl: string) {
        if (navigator.share) {
          await navigator.share({ url: imageUrl });
        } else {
          console.log('Share not supported, image:', imageUrl);
        }
      },
      async shareTo(platform: string, data: any) {
        console.log('Share to:', platform, data);
      }
    },
    toast: new WebToast()
  };
}