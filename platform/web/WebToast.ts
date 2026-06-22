// Web平台适配器 - 提示

import { IToast } from '../common/IToast';

export class WebToast implements IToast {
  show(message: string, duration: number = 2000): void {
    // 简单实现，实际项目中可以使用更好的UI库
    const toast = document.createElement('div');
    toast.textContent = message;
    toast.style.cssText = `
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: rgba(0, 0, 0, 0.8);
      color: white;
      padding: 12px 24px;
      border-radius: 8px;
      z-index: 9999;
      font-size: 14px;
    `;
    document.body.appendChild(toast);
    
    setTimeout(() => {
      document.body.removeChild(toast);
    }, duration);
  }
  
  showSuccess(message: string): void {
    this.show(`✅ ${message}`, 2000);
  }
  
  showError(message: string): void {
    this.show(`❌ ${message}`, 3000);
  }
}