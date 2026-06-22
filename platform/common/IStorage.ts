// 平台适配接口 - 存储接口

export interface IStorage {
  // 保存数据
  set(key: string, value: any): Promise<void>;
  
  // 读取数据
  get<T>(key: string): Promise<T | null>;
  
  // 删除数据
  remove(key: string): Promise<void>;
  
  // 清空所有数据
  clear(): Promise<void>;
}