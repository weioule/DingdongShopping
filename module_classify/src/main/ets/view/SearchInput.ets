/**
 * @author weioule
 * @date 2025-02-09
 * 搜索框
 */
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';

@Component
export struct SearchInput {
  build() {
    Flex({ alignItems: ItemAlign.Center }) {
      Image($r('[module_base].media.ic_search_gray'))
        .width(18)
        .height(18)
        .margin({
          left: 10,
          right: 10
        })

      Text('搜索商品')
        .flexGrow(1)
        .fontSize(13)
        .height('100%')
        .fontColor($r('[module_base].color.gray_color'))
    }.onClick(() => {
      AppRouter.toSearchPage()
    })
    .height(30)
    .borderRadius(50)
    .backgroundColor(Color.White)
  }
}