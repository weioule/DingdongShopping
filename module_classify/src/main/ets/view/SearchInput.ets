/**
 * @author weioule
 * @date 2025-02-09
 * 搜索框
 */
import { SeamlessScrollView } from './SeamlessScrollView';
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';


@Component
export struct SearchInput {
  @State showSearchIcon: boolean = false
  @State popularSearchesCurrentIndex: number = 0
  @State popularSearches: PopularSearchesBean[] = []
  private onPopularSearchesIndexChange?: (newIndex: number) => void

  build() {
    Flex({ alignItems: ItemAlign.Center }) {
      Image($r('[module_base].media.ic_search'))
        .width(18)
        .height(18)
        .margin({
          left: 10,
          right: 10
        }).visibility(this.showSearchIcon ? Visibility.Visible : Visibility.None)

      if (this.popularSearches.length > 0) {
        SeamlessScrollView({
          fontSize: 13,
          popularSearches: this.popularSearches,
          fontColor: $r('[module_base].color.gray_color'),
          onPopularSearchesIndexChange: (newIndex: number) => {
            this.popularSearchesCurrentIndex = newIndex
            this.onPopularSearchesIndexChange?.(newIndex)
          }
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
    }
    .height(30)
    .border({ radius: 20 })
    .backgroundColor(Color.White)
    .onClick(() => {
      AppRouter.toSearchPage('', this.popularSearches.length > 0 ?
        this.popularSearches[this.popularSearchesCurrentIndex % this.popularSearches.length] : undefined)
    })
  }
}