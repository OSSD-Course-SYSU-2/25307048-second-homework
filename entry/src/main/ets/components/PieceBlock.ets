// 棋子组件

import { Piece } from '../models/Piece';
import { Direction, PieceColors } from '../constants/GameConstants';

@Component
export struct PieceBlock {
  // 棋子数据 - 使用@Prop确保响应式更新
  @Prop piece: Piece;
  // 是否选中
  @Prop isSelected: boolean = false;
  // 单元格尺寸
  @Prop cellSize: number = 80;
  // 点击回调
  onPieceClick?: (pieceId: string) => void;
  // 移动回调
  onPieceMove?: (pieceId: string, direction: Direction) => void;
  
  build() {
    Stack() {
      // 棋子主体 - 严丝合缝对齐格子
      Column() {
        // 棋子名称 - 金色篆书效果
        Text(this.piece.name)
          .fontSize(this.piece.type === 'CAOCAO' ? 26 : 20)
          .fontColor('#D4AF37') // 金色文字
          .fontWeight(FontWeight.Bold)
          .letterSpacing(3) // 字间距，篆书效果
      }
      .width(this.piece.size.width * this.cellSize) // 宽度等于格子宽度
      .height(this.piece.size.height * this.cellSize) // 高度等于格子高度
      .backgroundColor(this.piece.color)
      .borderRadius(4)
      .justifyContent(FlexAlign.Center)
      .border({
        width: this.isSelected ? 4 : 3,
        color: this.isSelected ? '#FFD700' : '#D4AF37', // 金色边框
        radius: 4
      })
      // 立体阴影效果 - 让棋子"浮"在棋盘上
      .shadow({
        radius: this.isSelected ? 18 : 10,
        color: this.isSelected ? '#80D4AF37' : '#60000000',
        offsetX: 2,
        offsetY: 3
      })
      .padding({ top: 4, bottom: 4, left: 4, right: 4 })
    }
    // 使用计算属性确保位置更新 - 从格子左上角开始
    .position({
      x: this.getPositionX(),
      y: this.getPositionY()
    })
    .onClick(() => {
      if (this.onPieceClick) {
        this.onPieceClick(this.piece.id);
      }
    })
    .gesture(
      PanGesture({ direction: PanDirection.All })
        .onActionEnd((event: GestureEvent) => {
          if (!this.onPieceMove) {
            return;
          }
          
          const offsetX = event.offsetX;
          const offsetY = event.offsetY;
          const threshold = 15; // 移动阈值
          
          // 判断移动方向
          if (Math.abs(offsetX) > Math.abs(offsetY)) {
            // 水平移动
            if (offsetX > threshold) {
              this.onPieceMove(this.piece.id, Direction.RIGHT);
            } else if (offsetX < -threshold) {
              this.onPieceMove(this.piece.id, Direction.LEFT);
            }
          } else {
            // 垂直移动
            if (offsetY > threshold) {
              this.onPieceMove(this.piece.id, Direction.DOWN);
            } else if (offsetY < -threshold) {
              this.onPieceMove(this.piece.id, Direction.UP);
            }
          }
        })
    )
  }
  
  // 计算X位置 - 对齐格子左边缘
  private getPositionX(): number {
    return this.piece.position.col * this.cellSize;
  }
  
  // 计算Y位置 - 对齐格子上边缘
  private getPositionY(): number {
    return this.piece.position.row * this.cellSize;
  }
}
