/**
 * @author weioule
 * @date 2025-02-09
 * 搜索框
 */
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { SeamlessScrollView } from './SeamlessScrollView';

@Component
export struct SearchInput {
  @State popularSearches: PopularSearchesBean[] = []
  @State currentIndex: number = 0

  build() {
    Flex({ alignItems: ItemAlign.Center }) {
      Image($r('[module_base].media.ic_search'))
        .width(18)
        .height(18)
        .margin({
          left: 10,
          right: 10
        })

      if (this.popularSearches.length > 0) {
        SeamlessScrollView({
          fontSize: 13,
          currentIndex: this.currentIndex,
          popularSearches: this.popularSearches,
          fontColor: $r('[module_base].color.gray_color')
        })
          .flexGrow(1)
          .height('100%')
      } else {
        Text('搜索商品')
          .flexGrow(1)
          .fontSize(13)
          .height('100%')
          .fontColor($r('[module_base].color.gray_color'))
      }
    }.onClick(() => {
      AppRouter.toSearchPage('', this.popularSearches.length > 0 ? this.popularSearches[this.currentIndex] : undefined)
    })
    .height(30)
    .borderRadius(50)
    .backgroundColor(Color.White)
  }
}