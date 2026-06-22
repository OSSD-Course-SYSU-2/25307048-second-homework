// 游戏标题组件

import { GameText } from '../constants/GameConstants';

@Component
export struct GameHeader {
  // 关卡名称
  @Prop levelName: string = '';
  // 移动步数
  @Prop moveCount: number = 0;
  
  build() {
    Column() {
      // 游戏标题 - 古风书法风格
      Text(GameText.TITLE)
        .fontSize(36)
        .fontColor('#D4AF37') // 暗金色
        .fontWeight(FontWeight.Bold)
        .letterSpacing(8) // 字间距，书法效果
        .margin({ bottom: 12 })
      
      // 装饰分割线
      Row() {
        Column()
          .width(60)
          .height(2)
          .backgroundColor('#8B7355')
        
        Text('◆')
          .fontSize(12)
          .fontColor('#D4AF37')
          .margin({ left: 8, right: 8 })
        
        Column()
          .width(60)
          .height(2)
          .backgroundColor('#8B7355')
      }
      .margin({ bottom: 12 })
      
      // 关卡和步数信息 - 古风样式
      Row() {
        Row() {
          Text('关卡：')
            .fontSize(16)
            .fontColor('#C9A961')
          
          Text(this.levelName)
            .fontSize(16)
            .fontColor('#D4AF37')
            .fontWeight(FontWeight.Bold)
        }
        
        Column()
          .width(2)
          .height(16)
          .backgroundColor('#8B7355')
          .margin({ left: 20, right: 20 })
        
        Row() {
          Text('步数：')
            .fontSize(16)
            .fontColor('#C9A961')
          
          Text(this.moveCount.toString())
            .fontSize(16)
            .fontColor('#D4AF37')
            .fontWeight(FontWeight.Bold)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ top: 25, bottom: 20 })
    .backgroundColor('#2C2418') // 深褐色背景
    .border({ 
      width: { bottom: 3 },
      color: { bottom: '#D4AF37' }
    })
  }
}
