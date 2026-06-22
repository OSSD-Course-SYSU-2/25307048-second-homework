// 胜利检测器 - 平台无关

import { Piece, PieceType } from '../models/Piece';

export class WinChecker {
  // 检查是否胜利(曹操到达出口位置)
  static checkWin(pieces: Piece[]): boolean {
    const caocao = pieces.find(piece => piece.type === PieceType.CAOCAO);
    
    if (!caocao) {
      return false;
    }
    
    // 曹操胜利位置: row=3, col=1 (出口位置)
    if (caocao.position.row === 3 && caocao.position.col === 1) {
      return true;
    }
    
    return false;
  }
}