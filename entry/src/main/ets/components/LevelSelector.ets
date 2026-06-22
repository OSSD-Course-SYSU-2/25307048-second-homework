// 关卡选择器组件

import { Level } from '../models/Level';

@Component
export struct LevelSelector {
  // 关卡列表
  @Prop levels: Level[] = [];
  // 当前关卡ID
  @Prop currentLevelId: number = 1;
  // 是否显示
  @Prop visible: boolean = false;
  // 关卡选择回调
  onLevelSelect?: (levelId: number) => void;
  // 关闭回调
  onClose?: () => void;
  
  build() {
    if (this.visible) {
      // 遮罩层
      Stack() {
        // 半透明背景 - 古风暗色
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#90000000')
          .onClick(() => {
            if (this.onClose) {
              this.onClose();
            }
          })
        
        // 弹窗内容 - 古风样式
        Column() {
          // 标题装饰
          Column() {
            // 上装饰线
            Row() {
              Column()
                .width(40)
                .height(2)
                .backgroundColor('#8B7355')
              
              Text('◆')
                .fontSize(10)
                .fontColor('#D4AF37')
                .margin({ left: 6, right: 6 })
              
              Column()
                .width(40)
                .height(2)
                .backgroundColor('#8B7355')
            }
            .margin({ bottom: 10 })
            
            // 标题
            Text('选择关卡')
              .fontSize(24)
              .fontColor('#D4AF37')
              .fontWeight(FontWeight.Bold)
              .letterSpacing(4)
              .margin({ bottom: 10 })
            
            // 下装饰线
            Row() {
              Column()
                .width(40)
                .height(2)
                .backgroundColor('#8B7355')
              
              Text('◆')
                .fontSize(10)
                .fontColor('#D4AF37')
                .margin({ left: 6, right: 6 })
              
              Column()
                .width(40)
                .height(2)
                .backgroundColor('#8B7355')
            }
          }
          .margin({ bottom: 25 })
          
          // 关卡列表
          Column() {
            ForEach(this.levels, (level: Level) => {
              Row() {
                Column() {
                  Row() {
                    Text(level.name)
                      .fontSize(18)
                      .fontColor(level.id === this.currentLevelId ? '#D4AF37' : '#C9A961')
                      .fontWeight(level.id === this.currentLevelId ? FontWeight.Bold : FontWeight.Normal)
                      .letterSpacing(2)
                    
                    Blank()
                      .width(15)
                    
                    Text(level.difficulty)
                      .fontSize(14)
                      .fontColor('#8B7355')
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .width('100%')
                .height(60)
                .padding({ left: 25, right: 25 })
                .backgroundColor(level.id === this.currentLevelId ? '#3D2914' : '#2C2418')
                .borderRadius(4)
                .border({ 
                  width: level.id === this.currentLevelId ? 3 : 2, 
                  color: level.id === this.currentLevelId ? '#D4AF37' : '#5C4033',
                  radius: 4
                })
                .margin({ bottom: 12 })
                .onClick(() => {
                  if (this.onLevelSelect) {
                    this.onLevelSelect(level.id);
                  }
                })
              }
            }, (level: Level) => level.id.toString())
          }
          .width('85%')
        }
        .width('88%')
        .backgroundColor('#1A1410') // 墨黑色背景
        .borderRadius(8)
        .border({ width: 4, color: '#D4AF37', radius: 8 })
        .padding(25)
        .shadow({
          radius: 30,
          color: '#80000000',
          offsetX: 0,
          offsetY: 10
        })
      }
      .width('100%')
      .height('100%')
    }
  }
}
