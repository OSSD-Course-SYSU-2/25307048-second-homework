// 游戏常量配置 - 平台无关

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
  static readonly CAOCAO: string = '#8B1A1A';
  static readonly GENERAL: string = '#4A4A4A';
  static readonly SOLDIER: string = '#5C4033';
  static readonly SELECTED_BORDER: string = '#D4AF37';
}

// 古风主题颜色配置
export class AncientTheme {
  static readonly BG_PRIMARY: string = '#1A1410';
  static readonly BG_SECONDARY: string = '#2C2418';
  static readonly BG_BOARD: string = '#3D2914';
  static readonly TEXT_PRIMARY: string = '#D4AF37';
  static readonly TEXT_SECONDARY: string = '#C9A961';
  static readonly TEXT_DARK: string = '#8B7355';
  static readonly BORDER_PRIMARY: string = '#8B7355';
  static readonly BORDER_GOLD: string = '#D4AF37';
  static readonly BORDER_DARK: string = '#4A3728';
  static readonly ACCENT_RED: string = '#8B1A1A';
  static readonly ACCENT_GOLD: string = '#D4AF37';
  static readonly ACCENT_COPPER: string = '#B87333';
  static readonly CELL_STRIPE: string = '#1A1410';
  static readonly CELL_BG: string = '#4A3728';
  static readonly CELL_BORDER: string = '#5C4033';
}

// 动画时长配置(毫秒)
export class AnimationDuration {
  static readonly PIECE_MOVE: number = 200;
  static readonly PIECE_SELECT: number = 150;
}

// 游戏文本
export class GameText {
  static readonly TITLE: string = '华容道';
  static readonly RESET: string = '重置';
  static readonly SELECT_LEVEL: string = '选关';
  static readonly WIN_MESSAGE: string = '恭喜通关！';
  static readonly MOVES: string = '步';
}