// 平台适配接口 - 提示接口

export interface IToast {
  // 显示提示
  show(message: string, duration?: number): void;
  
  // 显示成功提示
  showSuccess(message: string): void;
  
  // 显示错误提示
  showError(message: string): void;
}