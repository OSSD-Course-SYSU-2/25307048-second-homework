// HarmonyOS平台适配器 - 存储

import { IStorage } from '../common/IStorage';

export class HarmonyStorage implements IStorage {
  async set(key: string, value: any): Promise<void> {
    try {
      // HarmonyOS使用AppStorage
      AppStorage.Set<string>(key, JSON.stringify(value));
    } catch (error) {
      console.error('Storage set error:', error);
    }
  }
  
  async get<T>(key: string): Promise<T | null> {
    try {
      const data = AppStorage.Get<string>(key);
      if (data) {
        return JSON.parse(data) as T;
      }
      return null;
    } catch (error) {
      console.error('Storage get error:', error);
      return null;
    }
  }
  
  async remove(key: string): Promise<void> {
    try {
      AppStorage.Delete(key);
    } catch (error) {
      console.error('Storage remove error:', error);
    }
  }
  
  async clear(): Promise<void> {
    // HarmonyOS暂不支持清空所有
    console.warn('Clear all storage not implemented');
  }
}