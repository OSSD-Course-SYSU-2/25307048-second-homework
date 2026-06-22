// 棋盘组件

import { Piece } from '../models/Piece';
import { Direction, BOARD_COLS, BOARD_ROWS } from '../constants/GameConstants';
import { PieceBlock } from './PieceBlock';

@Component
export struct GameBoard {
  // 棋子数组
  @Prop pieces: Piece[];
  // 选中的棋子ID
  @Prop selectedPieceId: string | null = null;
  // 单元格尺寸（支持动态调整）
  @Prop cellSize: number = 75;
  // 点击回调
  onPieceClick?: (pieceId: string) => void;
  // 移动回调
  onPieceMove?: (pieceId: string, direction: Direction) => void;
  
  build() {
    Column() {
      Stack() {
        // 棋盘背景 - 深黑色木质底座
        Column() {
          // 绘制网格线 - 深黑色格子
          ForEach([0, 1, 2, 3, 4], (row: number) => {
            Row() {
              ForEach([0, 1, 2, 3], (col: number) => {
                Column() {
                  // 格子内容区域 - 深黑色底座
                  Column()
                    .width('100%')
                    .height('100%')
                }
                .width(this.cellSize)
                .height(this.cellSize)
                .backgroundColor('#1A1410') // 深黑色底座
              }, (col: number) => col.toString())
            }
          }, (row: number) => row.toString())
        }
        .width(BOARD_COLS * this.cellSize)
        .height(BOARD_ROWS * this.cellSize)
        .backgroundColor('#0D0D0D') // 棋盘底色 - 纯黑
        .border({ 
          width: 4, 
          color: '#D4AF37', // 金色边框
          radius: 4 
        })
        .shadow({
          radius: 25,
          color: '#90000000',
          offsetX: 0,
          offsetY: 10
        })
        
        // 出口标识 - 古风装饰
        Row() {
          Text('▼ 出口 ▼')
            .fontSize(16)
            .fontColor('#D4AF37')
            .fontWeight(FontWeight.Bold)
            .letterSpacing(2)
        }
        .width(this.cellSize * 2 + 20)
        .height(40)
        .backgroundColor('#2C2418')
        .border({ 
          width: 2, 
          color: '#8B7355',
          radius: 2 
        })
        .justifyContent(FlexAlign.Center)
        .position({
          x: this.cellSize - 10,
          y: BOARD_ROWS * this.cellSize + 8
        })
        
        // 渲染所有棋子
        ForEach(this.pieces, (piece: Piece, index: number) => {
          PieceBlock({
            piece: piece,
            isSelected: piece.id === this.selectedPieceId,
            cellSize: this.cellSize,
            onPieceClick: this.onPieceClick,
            onPieceMove: this.onPieceMove
          })
        }, (piece: Piece, index: number) => {
          // 使用id和位置作为key,确保位置变化时重新渲染
          return `${piece.id}_${piece.position.row}_${piece.position.col}`;
        })
      }
      .width(BOARD_COLS * this.cellSize)
      .height(BOARD_ROWS * this.cellSize + 55)
    }
  }
}
