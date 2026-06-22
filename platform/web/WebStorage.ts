// Web平台适配器 - 存储

import { IStorage } from '../common/IStorage';

export class WebStorage implements IStorage {
  private prefix: string = 'huarongdao_';
  
  async set(key: string, value: any): Promise<void> {
    try {
      localStorage.setItem(this.prefix + key, JSON.stringify(value));
    } catch (error) {
      console.error('Storage set error:', error);
    }
  }
  
  async get<T>(key: string): Promise<T | null> {
    try {
      const data = localStorage.getItem(this.prefix + key);
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
      localStorage.removeItem(this.prefix + key);
    } catch (error) {
      console.error('Storage remove error:', error);
    }
  }
  
  async clear(): Promise<void> {
    try {
      const keys = Object.keys(localStorage).filter(k => k.startsWith(this.prefix));
      keys.forEach(k => localStorage.removeItem(k));
    } catch (error) {
      console.error('Storage clear error:', error);
    }
  }
}