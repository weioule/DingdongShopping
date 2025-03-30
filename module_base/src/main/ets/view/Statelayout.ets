
/**
 * @author weioule
 * * @date 2025-02-09
 * 页面状态管理
 */
export enum StateType {
  normal = 0, //空页面
  empty = 1, //暂无数据页面
  error = 2, //加载失败页面
}

@Component
export struct StateLayout {
  @Prop stateType: number
  clickRetry?: () => void

  build() {
    Column() {
      if (this.stateType > 0) {
        Image(this.stateType == StateType.empty ? $r("app.media.ic_empty") : $r("app.media.ic_error"))
          .width(80)
          .height(80)
      }
      Text(StateType.empty ? '空空如也！' : '哎呦，加载失败！')
        .margin({ top: 20 })
        .fontSize(14)
        .fontColor($r('app.color.bg_color'))

      Text(StateType.empty ? '' : '轻触屏幕重试')
        .margin({ top: 10 })
        .fontSize(12)
        .fontColor($r('app.color.txt_color_999'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.bg_color'))
    .onClick(() => {
      if (this.clickRetry) {
        this.clickRetry()
      }
    })
  }
}