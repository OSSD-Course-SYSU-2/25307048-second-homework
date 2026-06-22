// HarmonyOS平台适配器 - 提示

import { IToast } from '../common/IToast';
import promptAction from '@ohos.promptAction';

export class HarmonyToast implements IToast {
  show(message: string, duration: number = 2000): void {
    promptAction.showToast({
      message: message,
      duration: duration
    });
  }
  
  showSuccess(message: string): void {
    this.show(`✅ ${message}`, 2000);
  }
  
  showError(message: string): void {
    this.show(`❌ ${message}`, 3000);
  }
}