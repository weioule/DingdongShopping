/**
 * @author weioule
 * @date 2025-03-2
 */
@Component
export struct EmptyView {
  build() {
    Column() {
      Image($r("app.media.ic_empty")).width(120).height(100)
      Text('暂无数据').margin({ top: 8 }).fontSize(14).fontColor(0x6C6C6C)
    }
    .width('100%')
    .padding({ top: 60, bottom: 40 })
  }
}