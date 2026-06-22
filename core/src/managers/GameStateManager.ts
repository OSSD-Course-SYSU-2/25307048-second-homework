// 游戏状态管理器 - 平台无关

import { Piece, Position, Size } from '../models/Piece';
import { BoardState } from '../models/BoardState';
import { Direction } from '../constants/GameConstants';
import { LevelManager } from './LevelManager';
import { MoveValidator } from './MoveValidator';
import { WinChecker } from './WinChecker';

export class GameStateManager {
  private pieces: Piece[] = [];
  private selectedPieceId: string | null = null;
  private moveCount: number = 0;
  private currentLevelId: number = 1;
  private isWin: boolean = false;
  
  initGame(levelId: number): void {
    const level = LevelManager.getLevel(levelId);
    if (!level) {
      console.error(`Level ${levelId} not found`);
      return;
    }
    
    this.currentLevelId = levelId;
    this.moveCount = 0;
    this.selectedPieceId = null;
    this.isWin = false;
    
    this.pieces = level.pieces.map(piece => {
      const pos: Position = { row: piece.position.row, col: piece.position.col };
      const sz: Size = { width: piece.size.width, height: piece.size.height };
      const newPiece: Piece = {
        id: piece.id,
        name: piece.name,
        type: piece.type,
        position: pos,
        size: sz,
        color: piece.color
      };
      return newPiece;
    });
  }
  
  getBoardState(): BoardState {
    return {
      pieces: this.pieces,
      selectedPieceId: this.selectedPieceId,
      moveCount: this.moveCount,
      currentLevelId: this.currentLevelId,
      isWin: this.isWin
    };
  }
  
  selectPiece(pieceId: string): void {
    const piece = this.pieces.find(p => p.id === pieceId);
    if (piece) {
      this.selectedPieceId = pieceId;
    }
  }
  
  deselectPiece(): void {
    this.selectedPieceId = null;
  }
  
  movePiece(pieceId: string, direction: Direction): boolean {
    const pieceIndex = this.pieces.findIndex(p => p.id === pieceId);
    if (pieceIndex === -1) {
      return false;
    }
    
    const piece = this.pieces[pieceIndex];
    
    if (!MoveValidator.validateMove(piece, direction, this.pieces)) {
      return false;
    }
    
    let newRow = piece.position.row;
    let newCol = piece.position.col;
    
    switch (direction) {
      case Direction.UP:
        newRow -= 1;
        break;
      case Direction.DOWN:
        newRow += 1;
        break;
      case Direction.LEFT:
        newCol -= 1;
        break;
      case Direction.RIGHT:
        newCol += 1;
        break;
    }
    
    const newPosition: Position = { row: newRow, col: newCol };
    
    this.pieces[pieceIndex] = {
      id: piece.id,
      name: piece.name,
      type: piece.type,
      position: newPosition,
      size: piece.size,
      color: piece.color
    };
    
    this.moveCount++;
    this.isWin = WinChecker.checkWin(this.pieces);
    
    return true;
  }
  
  resetGame(): void {
    this.initGame(this.currentLevelId);
  }
  
  checkWin(): boolean {
    return this.isWin;
  }
  
  getCurrentLevelId(): number {
    return this.currentLevelId;
  }
  
  getCurrentLevelName(): string {
    const level = LevelManager.getLevel(this.currentLevelId);
    return level ? level.name : '';
  }
  
  getMoveCount(): number {
    return this.moveCount;
  }
  
  getSelectedPieceId(): string | null {
    return this.selectedPieceId;
  }
  
  getPieces(): Piece[] {
    return this.pieces;
  }
}