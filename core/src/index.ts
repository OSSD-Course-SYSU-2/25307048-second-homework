// 核心层导出 - 平台无关

// 导出模型
export * from './models/Piece';
export * from './models/Level';
export * from './models/BoardState';

// 导出常量
export * from './constants/GameConstants';

// 导出管理器
export * from './managers/GameStateManager';
export * from './managers/MoveValidator';
export * from './managers/WinChecker';
export * from './managers/LevelManager';

// 导出数据
export * from './data/LevelData';