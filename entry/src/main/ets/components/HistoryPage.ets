// 历史记录页面组件

import { GameRecord, BestScore, GameStatistics, formatDuration } from '../models/GameRecord';
import { RecordManager } from '../managers/RecordManager';
import promptAction from '@ohos.promptAction';

@Component
export struct HistoryPage {
  @State records: GameRecord[] = [];
  @State bestScores: BestScore[] = [];
  @State statistics: GameStatistics | null = null;
  @State showConfirm: boolean = false;
  @State selectedTab: number = 0; // 0: 记录列表, 1: 最佳成绩, 2: 统计
  
  // 关闭回调
  onClose?: () => void;
  
  aboutToAppear() {
    this.loadData();
  }
  
  // 加载数据
  private loadData() {
    const manager = RecordManager.getInstance();
    this.records = manager.getAllRecords();
    this.bestScores = manager.getAllBestScores();
    this.statistics = manager.getStatistics();
  }
  
  // 清空历史记录
  private handleClearHistory() {
    this.showConfirm = true;
  }
  
  // 确认清空
  private async confirmClear() {
    await RecordManager.getInstance().clearAllRecords();
    this.loadData();
    this.showConfirm = false;
    promptAction.showToast({
      message: '历史记录已清空',
      duration: 2000
    });
  }
  
  // 取消清空
  private cancelClear() {
    this.showConfirm = false;
  }
  
  build() {
    Column() {
      // 标题栏
      Row() {
        Text('历史记录')
          .fontSize(24)
          .fontColor('#D4AF37')
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
        
        Button('×')
          .width(40)
          .height(40)
          .fontSize(24)
          .fontColor('#D4AF37')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            if (this.onClose) {
              this.onClose();
            }
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 15, bottom: 15 })
      .backgroundColor('#2C2418')
      
      // 标签切换
      Row() {
        Button('通关记录')
          .fontSize(16)
          .fontColor(this.selectedTab === 0 ? '#1A1410' : '#D4AF37')
          .backgroundColor(this.selectedTab === 0 ? '#D4AF37' : Color.Transparent)
          .borderRadius(8)
          .height(36)
          .layoutWeight(1)
          .onClick(() => { this.selectedTab = 0; })
        
        Button('最佳成绩')
          .fontSize(16)
          .fontColor(this.selectedTab === 1 ? '#1A1410' : '#D4AF37')
          .backgroundColor(this.selectedTab === 1 ? '#D4AF37' : Color.Transparent)
          .borderRadius(8)
          .height(36)
          .layoutWeight(1)
          .margin({ left: 8, right: 8 })
          .onClick(() => { this.selectedTab = 1; })
        
        Button('统计数据')
          .fontSize(16)
          .fontColor(this.selectedTab === 2 ? '#1A1410' : '#D4AF37')
          .backgroundColor(this.selectedTab === 2 ? '#D4AF37' : Color.Transparent)
          .borderRadius(8)
          .height(36)
          .layoutWeight(1)
          .onClick(() => { this.selectedTab = 2; })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#2C2418')
      
      // 内容区域
      if (this.selectedTab === 0) {
        // 通关记录列表
        this.RecordsList()
      } else if (this.selectedTab === 1) {
        // 最佳成绩列表
        this.BestScoresList()
      } else {
        // 统计数据
        this.StatisticsView()
      }
      
      // 确认对话框
      if (this.showConfirm) {
        this.ConfirmDialog()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#1A1410')
  }
  
  // 通关记录列表
  @Builder RecordsList() {
    Column() {
      if (this.records.length === 0) {
        // 空状态
        Column() {
          Text('📝')
            .fontSize(48)
            .margin({ bottom: 16 })
          
          Text('暂无通关记录')
            .fontSize(18)
            .fontColor('#999999')
          
          Text('开始游戏吧！')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 8 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        // 记录列表
        Scroll() {
          Column() {
            ForEach(this.records, (record: GameRecord) => {
              this.RecordItem(record)
            }, (record: GameRecord) => record.id)
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 80 })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        
        // 清空按钮
        Button('清空历史记录')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#FF5722')
          .borderRadius(8)
          .width('90%')
          .height(44)
          .margin({ bottom: 16 })
          .onClick(() => {
            this.handleClearHistory();
          })
      }
    }
    .width('100%')
    .layoutWeight(1)
  }
  
  // 记录项
  @Builder RecordItem(record: GameRecord) {
    Row() {
      // 关卡信息
      Column() {
        Row() {
          Text(record.levelName)
            .fontSize(18)
            .fontColor('#D4AF37')
            .fontWeight(FontWeight.Bold)
          
          if (record.isBest) {
            Text('🏆')
              .fontSize(16)
              .margin({ left: 8 })
          }
        }
        
        Text(record.date)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      
      // 步数和用时
      Column() {
        Text(`${record.steps} 步`)
          .fontSize(16)
          .fontColor('#C9A961')
          .fontWeight(FontWeight.Bold)
        
        Text(record.durationText)
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#2C2418')
    .borderRadius(8)
    .margin({ bottom: 12 })
  }
  
  // 最佳成绩列表
  @Builder BestScoresList() {
    Scroll() {
      Column() {
        if (this.bestScores.length === 0) {
          Column() {
            Text('🏆')
              .fontSize(48)
              .margin({ bottom: 16 })
            
            Text('暂无最佳成绩')
              .fontSize(18)
              .fontColor('#999999')
          }
          .width('100%')
          .height(300)
          .justifyContent(FlexAlign.Center)
        } else {
          ForEach(this.bestScores, (score: BestScore) => {
            this.BestScoreItem(score)
          }, (score: BestScore) => score.levelId.toString())
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }
  
  // 最佳成绩项
  @Builder BestScoreItem(score: BestScore) {
    Row() {
      Column() {
        Text(score.levelName)
          .fontSize(18)
          .fontColor('#D4AF37')
          .fontWeight(FontWeight.Bold)
        
        Text(`通关 ${score.recordCount} 次`)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      
      Column() {
        Text(`最佳: ${score.bestSteps} 步`)
          .fontSize(16)
          .fontColor('#C9A961')
          .fontWeight(FontWeight.Bold)
        
        Text(formatDuration(score.bestDuration))
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#2C2418')
    .borderRadius(8)
    .margin({ bottom: 12 })
  }
  
  // 统计数据视图
  @Builder StatisticsView() {
    Column() {
      if (this.statistics && this.statistics.totalRecords > 0) {
        // 统计卡片
        Column() {
          this.StatItem('总通关次数', `${this.statistics.totalRecords} 次`)
          this.StatItem('已通关关卡', `${this.statistics.totalLevels} 关`)
          this.StatItem('平均步数', `${this.statistics.averageSteps} 步`)
          this.StatItem('平均用时', formatDuration(this.statistics.averageDuration))
          this.StatItem('最佳步数', `${this.statistics.bestSteps} 步`)
          this.StatItem('最快用时', formatDuration(this.statistics.bestDuration))
          this.StatItem('总用时', formatDuration(this.statistics.totalDuration))
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      } else {
        Column() {
          Text('📊')
            .fontSize(48)
            .margin({ bottom: 16 })
          
          Text('暂无统计数据')
            .fontSize(18)
            .fontColor('#999999')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .layoutWeight(1)
  }
  
  // 统计项
  @Builder StatItem(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor('#C9A961')
        .layoutWeight(1)
      
      Text(value)
        .fontSize(18)
        .fontColor('#D4AF37')
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .border({ width: { bottom: 1 }, color: { bottom: '#3D2914' } })
  }
  
  // 确认对话框
  @Builder ConfirmDialog() {
    Column() {
      Column() {
        Text('确认清空')
          .fontSize(20)
          .fontColor('#D4AF37')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 16 })
        
        Text('确定要清空所有历史记录吗？')
          .fontSize(16)
          .fontColor('#C9A961')
          .margin({ bottom: 8 })
        
        Text('（最佳成绩将保留）')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ bottom: 24 })
        
        Row() {
          Button('取消')
            .fontSize(16)
            .fontColor('#D4AF37')
            .backgroundColor('#2C2418')
            .borderRadius(8)
            .width(100)
            .height(40)
            .onClick(() => {
              this.cancelClear();
            })
          
          Button('确定')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF5722')
            .borderRadius(8)
            .width(100)
            .height(40)
            .margin({ left: 16 })
            .onClick(() => {
              this.confirmClear();
            })
        }
      }
      .width('80%')
      .padding(24)
      .backgroundColor('#2C2418')
      .borderRadius(12)
      .border({ width: 2, color: '#D4AF37' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#80000000')
    .justifyContent(FlexAlign.Center)
  }
}