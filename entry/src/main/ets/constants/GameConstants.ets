// 游戏常量配置文件

// 移动方向枚举
export enum Direction {
  UP = 'UP',
  DOWN = 'DOWN',
  LEFT = 'LEFT',
  RIGHT = 'RIGHT'
}

// 棋盘尺寸配置
export const BOARD_COLS: number = 4;
export const BOARD_ROWS: number = 5;
export const CELL_SIZE: number = 75;

// 棋子颜色配置 - 古风主题
export class PieceColors {
  static readonly CAOCAO: string = '#8B1A1A';      // 曹操 - 暗红色（朱砂红）
  static readonly GENERAL: string = '#4A4A4A';     // 武将 - 墨灰色
  static readonly SOLDIER: string = '#5C4033';     // 兵卒 - 深褐色
  static readonly SELECTED_BORDER: string = '#D4AF37';  // 选中边框 - 暗金色
}

// 古风主题颜色配置
export class AncientTheme {
  // 背景色
  static readonly BG_PRIMARY: string = '#1A1410';      // 主背景 - 墨黑色
  static readonly BG_SECONDARY: string = '#2C2418';    // 次背景 - 深褐色
  static readonly BG_BOARD: string = '#3D2914';        // 棋盘背景 - 木质色
  
  // 文字色
  static readonly TEXT_PRIMARY: string = '#D4AF37';    // 主文字 - 暗金色
  static readonly TEXT_SECONDARY: string = '#C9A961';  // 次文字 - 淡金色
  static readonly TEXT_DARK: string = '#8B7355';       // 暗文字 - 褐色
  
  // 边框色
  static readonly BORDER_PRIMARY: string = '#8B7355';  // 主边框 - 褐色
  static readonly BORDER_GOLD: string = '#D4AF37';     // 金色边框
  static readonly BORDER_DARK: string = '#4A3728';     // 暗边框
  
  // 装饰色
  static readonly ACCENT_RED: string = '#8B1A1A';      // 朱砂红
  static readonly ACCENT_GOLD: string = '#D4AF37';     // 暗金色
  static readonly ACCENT_COPPER: string = '#B87333';   // 铜色
  
  // 格子条纹色
  static readonly CELL_STRIPE: string = '#1A1410';     // 格子底部黑色条纹
  static readonly CELL_BG: string = '#4A3728';         // 格子背景
  static readonly CELL_BORDER: string = '#5C4033';     // 格子边框
}

// 动画时长配置(毫秒)
export class AnimationDuration {
  static readonly PIECE_MOVE: number = 200;    // 棋子移动动画
  static readonly PIECE_SELECT: number = 150;   // 棋子选中动画
}

// 游戏文本
export class GameText {
  static readonly TITLE: string = '华容道';
  static readonly RESET: string = '重置';
  static readonly SELECT_LEVEL: string = '选关';
  static readonly WIN_MESSAGE: string = '恭喜通关！';
  static readonly MOVES: string = '步';
}
