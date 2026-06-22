// 游戏记录存储管理器

import { GameRecord, BestScore, GameStatistics, generateRecordId, formatDuration, formatDate } from '../models/GameRecord';
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

// 存储键名接口
interface StorageKeys {
  RECORDS: string;
  BEST_SCORES: string;
  GAME_STATE: string;
}

// 存储键名
const STORAGE_KEYS: StorageKeys = {
  RECORDS: 'huarongdao_records',
  BEST_SCORES: 'huarongdao_best_scores',
  GAME_STATE: 'huarongdao_game_state'
};

// Preferences 文件名
const PREFERENCES_NAME = 'huarongdao_game_data';

// 游戏记录管理器
export class RecordManager {
  private static instance: RecordManager;
  private records: GameRecord[] = [];
  private bestScores: Map<number, BestScore> = new Map();
  private dataPreferences: preferences.Preferences | null = null;
  private isInitialized: boolean = false;
  
  // 私有构造函数（单例模式）
  private constructor() {
  }
  
  // 获取单例实例
  static getInstance(): RecordManager {
    if (!RecordManager.instance) {
      RecordManager.instance = new RecordManager();
    }
    return RecordManager.instance;
  }
  
  // 初始化 Preferences（需要传入 context）
  async init(context: common.UIAbilityContext): Promise<void> {
    if (this.isInitialized) {
      return;
    }
    
    try {
      // 获取 Preferences 实例
      this.dataPreferences = await preferences.getPreferences(context, PREFERENCES_NAME);
      
      // 加载数据
      await this.loadFromStorage();
      
      this.isInitialized = true;
      console.info('RecordManager 初始化成功');
    } catch (error) {
      console.error('RecordManager 初始化失败:', error);
      this.records = [];
      this.bestScores = new Map();
    }
  }
  
  // 从本地存储加载数据
  private async loadFromStorage(): Promise<void> {
    if (!this.dataPreferences) {
      return;
    }
    
    try {
      // 加载通关记录
      const recordsData = await this.dataPreferences.get(STORAGE_KEYS.RECORDS, '') as string;
      if (recordsData) {
        this.records = JSON.parse(recordsData) as GameRecord[];
      }
      
      // 加载最佳成绩
      const bestScoresData = await this.dataPreferences.get(STORAGE_KEYS.BEST_SCORES, '') as string;
      if (bestScoresData) {
        const bestScoresArray: BestScore[] = JSON.parse(bestScoresData) as BestScore[];
        bestScoresArray.forEach(score => {
          this.bestScores.set(score.levelId, score);
        });
      }
      
      console.info('数据加载成功，记录数:', this.records.length);
    } catch (error) {
      console.error('加载存储数据失败:', error);
      this.records = [];
      this.bestScores = new Map();
    }
  }
  
  // 保存到本地存储
  private async saveToStorage(): Promise<void> {
    if (!this.dataPreferences) {
      console.error('Preferences 未初始化');
      return;
    }
    
    try {
      // 保存通关记录
      await this.dataPreferences.put(STORAGE_KEYS.RECORDS, JSON.stringify(this.records));
      
      // 保存最佳成绩
      const bestScoresArray: BestScore[] = [];
      this.bestScores.forEach((score) => {
        bestScoresArray.push(score);
      });
      await this.dataPreferences.put(STORAGE_KEYS.BEST_SCORES, JSON.stringify(bestScoresArray));
      
      // 刷新到磁盘
      await this.dataPreferences.flush();
      
      console.info('数据保存成功');
    } catch (error) {
      console.error('保存存储数据失败:', error);
    }
  }
  
  // 添加通关记录
  async addRecord(levelId: number, levelName: string, steps: number, duration: number): Promise<GameRecord> {
    const now = Date.now();
    
    // 检查是否刷新最佳成绩
    const isBest = this.checkAndUpdateBestScore(levelId, levelName, steps, duration, now);
    
    // 创建新记录
    const record: GameRecord = {
      id: generateRecordId(),
      levelId: levelId,
      levelName: levelName,
      steps: steps,
      duration: duration,
      durationText: formatDuration(duration),
      date: formatDate(now),
      timestamp: now,
      isBest: isBest
    };
    
    // 添加到记录列表（插入到最前面）
    this.records.unshift(record);
    
    // 保存到存储
    await this.saveToStorage();
    
    return record;
  }
  
  // 检查并更新最佳成绩
  private checkAndUpdateBestScore(levelId: number, levelName: string, steps: number, duration: number, timestamp: number): boolean {
    const existing = this.bestScores.get(levelId);
    
    if (!existing) {
      // 首次通关
      this.bestScores.set(levelId, {
        levelId: levelId,
        levelName: levelName,
        bestSteps: steps,
        bestDuration: duration,
        bestDate: formatDate(timestamp),
        recordCount: 1
      });
      return true;
    }
    
    // 更新通关次数
    existing.recordCount += 1;
    
    // 检查是否刷新最佳步数
    if (steps < existing.bestSteps) {
      existing.bestSteps = steps;
      existing.bestDate = formatDate(timestamp);
      return true;
    }
    
    // 检查是否刷新最快用时
    if (duration < existing.bestDuration) {
      existing.bestDuration = duration;
    }
    
    return false;
  }
  
  // 获取所有通关记录
  getAllRecords(): GameRecord[] {
    return [...this.records];
  }
  
  // 获取指定关卡的通关记录
  getRecordsByLevel(levelId: number): GameRecord[] {
    return this.records.filter(record => record.levelId === levelId);
  }
  
  // 获取最佳成绩
  getBestScore(levelId: number): BestScore | undefined {
    return this.bestScores.get(levelId);
  }
  
  // 获取所有最佳成绩
  getAllBestScores(): BestScore[] {
    const result: BestScore[] = [];
    this.bestScores.forEach((score) => {
      result.push(score);
    });
    return result;
  }
  
  // 获取成绩统计
  getStatistics(): GameStatistics {
    if (this.records.length === 0) {
      return {
        totalRecords: 0,
        totalLevels: 0,
        averageSteps: 0,
        averageDuration: 0,
        bestSteps: 0,
        bestDuration: 0,
        totalDuration: 0
      };
    }
    
    const totalSteps = this.records.reduce((sum, record) => sum + record.steps, 0);
    const totalDuration = this.records.reduce((sum, record) => sum + record.duration, 0);
    const bestSteps = Math.min(...this.records.map(r => r.steps));
    const bestDuration = Math.min(...this.records.map(r => r.duration));
    
    // 统计已通关关卡数
    const levelSet = new Set(this.records.map(r => r.levelId));
    
    return {
      totalRecords: this.records.length,
      totalLevels: levelSet.size,
      averageSteps: Math.round(totalSteps / this.records.length),
      averageDuration: Math.round(totalDuration / this.records.length),
      bestSteps: bestSteps,
      bestDuration: bestDuration,
      totalDuration: totalDuration
    };
  }
  
  // 删除指定记录
  async deleteRecord(recordId: string): Promise<boolean> {
    const index = this.records.findIndex(r => r.id === recordId);
    if (index !== -1) {
      this.records.splice(index, 1);
      await this.saveToStorage();
      return true;
    }
    return false;
  }
  
  // 清空所有历史记录（保留最佳成绩）
  async clearAllRecords(): Promise<void> {
    this.records = [];
    await this.saveToStorage();
  }
  
  // 清空所有数据（包括最佳成绩）
  async clearAllData(): Promise<void> {
    this.records = [];
    this.bestScores = new Map();
    await this.saveToStorage();
  }
  
  // 获取记录总数
  getRecordCount(): number {
    return this.records.length;
  }
  
  // 检查关卡是否已通关
  hasCompletedLevel(levelId: number): boolean {
    return this.records.some(record => record.levelId === levelId);
  }
  
  // 检查是否已初始化
  isReady(): boolean {
    return this.isInitialized;
  }
}
