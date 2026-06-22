// 平台适配接口 - 分享接口

export interface IShare {
  // 分享文本
  shareText(text: string): Promise<void>;
  
  // 分享图片
  shareImage(imageUrl: string): Promise<void>;
  
  // 分享到指定平台
  shareTo(platform: string, data: any): Promise<void>;
}