// 华容道游戏主页面

import { Piece } from '../models/Piece';
import { Level } from '../models/Level';
import { Direction, GameText } from '../constants/GameConstants';
import { GameStateManager } from '../managers/GameStateManager';
import { LevelManager } from '../managers/LevelManager';
import { RecordManager } from '../managers/RecordManager';
import { GameHeader } from '../components/GameHeader';
import { GameBoard } from '../components/GameBoard';
import { GameFooter } from '../components/GameFooter';
import { LevelSelector } from '../components/LevelSelector';
import { HistoryPage } from '../components/HistoryPage';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  // 游戏状态管理器
  private gameManager: GameStateManager = new GameStateManager();
  
  // 响应式状态
  @State pieces: Piece[] = [];
  @State selectedPieceId: string | null = null;
  @State moveCount: number = 0;
  @State currentLevelId: number = 1;
  @State levelName: string = '';
  @State isWin: boolean = false;
  @State showLevelSelector: boolean = false;
  @State showHistoryPage: boolean = false;
  @State levels: Level[] = [];
  
  // 游戏计时
  private startTime: number = 0;
  private cellSize: number = 65;
  
  // 生命周期:页面即将显示
  aboutToAppear() {
    // 初始化关卡列表
    this.levels = LevelManager.getAllLevels();
    
    // 初始化游戏
    this.initGame(1);
  }
  
  // 页面即将消失
  aboutToDisappear() {
    // 可以在这里取消监听
  }
  
  // 初始化游戏
  private initGame(levelId: number) {
    this.gameManager.initGame(levelId);
    this.startTime = Date.now(); // 记录开始时间
    this.updateState();
  }
  
  // 更新UI状态
  private updateState() {
    const state = this.gameManager.getBoardState();
    // 创建新数组以触发UI更新
    const newPieces: Piece[] = [];
    for (let i = 0; i < state.pieces.length; i++) {
      newPieces.push(state.pieces[i]);
    }
    this.pieces = newPieces;
    this.selectedPieceId = state.selectedPieceId;
    this.moveCount = state.moveCount;
    this.currentLevelId = state.currentLevelId;
    this.isWin = state.isWin;
    this.levelName = this.gameManager.getCurrentLevelName();
  }
  
  // 处理棋子点击
  private handlePieceClick(pieceId: string) {
    if (this.selectedPieceId === pieceId) {
      // 取消选择
      this.gameManager.deselectPiece();
    } else {
      // 选择棋子
      this.gameManager.selectPiece(pieceId);
    }
    this.updateState();
  }
  
  // 处理棋子移动
  private handlePieceMove(pieceId: string, direction: Direction) {
    // 先选中棋子
    this.gameManager.selectPiece(pieceId);
    
    // 执行移动
    const success = this.gameManager.movePiece(pieceId, direction);
    if (success) {
      this.updateState();
      
      // 检查胜利
      if (this.isWin) {
        // 延迟显示胜利提示
        setTimeout(() => {
          this.showWinDialog();
        }, 300);
      }
    } else {
      // 移动失败也要更新状态(选中状态)
      this.updateState();
    }
  }
  
  // 处理重置
  private handleReset() {
    this.gameManager.resetGame();
    this.updateState();
  }
  
  // 显示关卡选择器
  private handleShowLevelSelector() {
    this.showLevelSelector = true;
  }
  
  // 关闭关卡选择器
  private handleCloseLevelSelector() {
    this.showLevelSelector = false;
  }
  
  // 处理关卡选择
  private handleLevelSelect(levelId: number) {
    this.showLevelSelector = false;
    this.initGame(levelId);
  }
  
  // 显示胜利对话框 - 古风样式
  private async showWinDialog() {
    // 计算用时
    const endTime = Date.now();
    const duration = Math.floor((endTime - this.startTime) / 1000); // 秒
    
    // 保存通关记录
    const recordManager = RecordManager.getInstance();
    const record = await recordManager.addRecord(
      this.currentLevelId,
      this.levelName,
      this.moveCount,
      duration
    );
    
    // 构建提示消息
    let message = `🎉 恭喜通关 🎉\n关卡：${this.levelName}\n步数：${this.moveCount} 步\n用时：${record.durationText}`;
    
    if (record.isBest) {
      message += '\n🏆 刷新最佳成绩！';
    }
    
    promptAction.showToast({
      message: message,
      duration: 3000
    });
  }
  
  build() {
    Column() {
      // 标题区域
      GameHeader({
        levelName: this.levelName,
        moveCount: this.moveCount
      })
      
      // 可滚动的内容区域
      Scroll() {
        Column() {
          // 棋盘区域
          GameBoard({
            pieces: this.pieces,
            selectedPieceId: this.selectedPieceId,
            cellSize: this.cellSize,
            onPieceClick: (pieceId: string) => {
              this.handlePieceClick(pieceId);
            },
            onPieceMove: (pieceId: string, direction: Direction) => {
              this.handlePieceMove(pieceId, direction);
            }
          })
          
          // 控制按钮区域
          this.ControlPanel()
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      
      // 关卡选择器
      LevelSelector({
        levels: this.levels,
        currentLevelId: this.currentLevelId,
        visible: this.showLevelSelector,
        onLevelSelect: (levelId: number) => {
          this.handleLevelSelect(levelId);
        },
        onClose: () => {
          this.handleCloseLevelSelector();
        }
      })
      
      // 历史记录页面
      if (this.showHistoryPage) {
        HistoryPage({
          onClose: () => {
            this.showHistoryPage = false;
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#1A1410') // 墨黑色背景 - 古风主题
  }
  
  // 控制面板组件
  @Builder ControlPanel() {
    Column() {
      // 提示文字
      Text('滑动棋子进行移动')
        .fontSize(13)
        .fontColor('#C9A961')
        .margin({ bottom: 10 })
      
      // 分割线
      Row() {
        Column()
          .width(40)
          .height(2)
          .backgroundColor('#8B7355')
        
        Text('◆')
          .fontSize(11)
          .fontColor('#D4AF37')
          .margin({ left: 6, right: 6 })
        
        Column()
          .width(40)
          .height(2)
          .backgroundColor('#8B7355')
      }
      .margin({ bottom: 10 })
      
      // 功能按钮
      Column() {
        // 第一行：重置和历史记录
        Row() {
          Button(GameText.RESET)
            .fontSize(15)
            .fontColor('#8B4513')
            .backgroundColor('#B8860B')
            .borderRadius(8)
            .border({ width: 3, color: '#D4AF37', radius: 8 })
            .width(90)
            .height(40)
            .shadow({ radius: 8, color: '#80000000', offsetX: 2, offsetY: 3 })
            .onClick(() => {
              this.handleReset();
            })
          
          Button('历史')
            .fontSize(15)
            .fontColor('#8B4513')
            .backgroundColor('#B8860B')
            .borderRadius(8)
            .border({ width: 3, color: '#D4AF37', radius: 8 })
            .width(90)
            .height(40)
            .shadow({ radius: 8, color: '#80000000', offsetX: 2, offsetY: 3 })
            .margin({ left: 10 })
            .onClick(() => {
              this.showHistoryPage = true;
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        
        // 第二行：选关
        Button(GameText.SELECT_LEVEL)
          .fontSize(15)
          .fontColor('#8B4513')
          .backgroundColor('#B8860B')
          .borderRadius(8)
          .border({ width: 3, color: '#D4AF37', radius: 8 })
          .width(90)
          .height(40)
          .shadow({ radius: 8, color: '#80000000', offsetX: 2, offsetY: 3 })
          .margin({ top: 10 })
          .onClick(() => {
            this.handleShowLevelSelector();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 12 })
    .backgroundColor('#2C2418')
    .border({ width: { top: 2 }, color: { top: '#D4AF37' } })
    .margin({ top: 12 })
  }
}
