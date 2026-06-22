// 游戏按钮组件

import { GameText } from '../constants/GameConstants';

@Component
export struct GameFooter {
  // 重置回调
  onReset?: () => void;
  // 选关回调
  onSelectLevel?: () => void;
  
  build() {
    Column() {
      // 装饰分割线
      Row() {
        Column()
          .width(100)
          .height(2)
          .backgroundColor('#8B7355')
        
        Text('◆')
          .fontSize(14)
          .fontColor('#D4AF37')
          .margin({ left: 10, right: 10 })
        
        Column()
          .width(100)
          .height(2)
          .backgroundColor('#8B7355')
      }
      .margin({ bottom: 20 })
      
      Row() {
        // 重置按钮 - 金色牌匾样式
        Button(GameText.RESET)
          .fontSize(20)
          .fontColor('#1A1410') // 黑色文字
          .backgroundColor('#D4AF37') // 金色背景
          .borderRadius(6)
          .border({ width: 4, color: '#B8860B', radius: 6 }) // 深金边框
          .width(140) // 加宽按钮
          .height(55) // 加高按钮
          .shadow({
            radius: 12,
            color: '#60000000',
            offsetX: 3,
            offsetY: 4
          })
          .constraintSize({ minWidth: 60, maxWidth: 200 })
          .padding({ left: 12, right: 12 })
          .onClick(() => {
            if (this.onReset) {
              this.onReset();
            }
          })
        
        Blank()
          .width(50)
        
        // 选关按钮 - 金色牌匾样式
        Button(GameText.SELECT_LEVEL)
          .fontSize(20)
          .fontColor('#1A1410') // 黑色文字
          .backgroundColor('#D4AF37') // 金色背景
          .borderRadius(6)
          .border({ width: 4, color: '#B8860B', radius: 6 }) // 深金边框
          .width(140) // 加宽按钮
          .height(55) // 加高按钮
          .shadow({
            radius: 12,
            color: '#60000000',
            offsetX: 3,
            offsetY: 4
          })
          .constraintSize({ minWidth: 60, maxWidth: 200 })
          .padding({ left: 12, right: 12 })
          .onClick(() => {
            if (this.onSelectLevel) {
              this.onSelectLevel();
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .padding({ top: 25, bottom: 30 })
    .backgroundColor('#2C2418')
    .border({ 
      width: { top: 3 },
      color: { top: '#D4AF37' }
    })
  }
}
