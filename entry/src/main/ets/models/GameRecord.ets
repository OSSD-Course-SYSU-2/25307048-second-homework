// 通关记录数据模型

// 通关记录接口
export interface GameRecord {
  id: string;              // 记录唯一ID
  levelId: number;         // 关卡ID
  levelName: string;       // 关卡名称
  steps: number;           // 通关步数
  duration: number;        // 用时（秒）
  durationText: string;    // 用时文本（HH:MM:SS）
  date: string;            // 完成日期
  timestamp: number;       // 时间戳
  isBest: boolean;         // 是否最佳成绩
}

// 最佳成绩接口
export interface BestScore {
  levelId: number;         // 关卡ID
  levelName: string;       // 关卡名称
  bestSteps: number;       // 最佳步数
  bestDuration: number;    // 最快用时（秒）
  bestDate: string;        // 达成日期
  recordCount: number;     // 通关次数
}

// 成绩统计接口
export interface GameStatistics {
  totalRecords: number;        // 总通关次数
  totalLevels: number;         // 已通关关卡数
  averageSteps: number;        // 平均步数
  averageDuration: number;     // 平均用时（秒）
  bestSteps: number;           // 全局最佳步数
  bestDuration: number;        // 全局最快用时（秒）
  totalDuration: number;       // 总用时（秒）
}

// 生成唯一ID
export function generateRecordId(): string {
  return Date.now().toString(36) + Math.random().toString(36).substr(2, 9);
}

// 格式化用时
export function formatDuration(seconds: number): string {
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const secs = Math.floor(seconds % 60);
  
  return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

// 格式化日期
export function formatDate(timestamp: number): string {
  const date = new Date(timestamp);
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');
  const seconds = date.getSeconds().toString().padStart(2, '0');
  
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}