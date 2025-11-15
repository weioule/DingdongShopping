import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';
import { ColorUtils } from 'module_base/src/main/ets/utils/ColorUtils';
import { SearchInput } from 'module_classify/src/main/ets/view/SearchInput';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';

/**
 * @author weioule
 * @date 2025-10-12
 */
@Component
export struct SearchBoxView {
  @Prop ratio: number = 0
  @State popularSearchesCurrentIndex: number = 0
  @State popularSearches: PopularSearchesBean[] = []

  build() {
    Row() {
      Image($r('app.media.ic_scan'))
        .width(22)
        .height(22)
        .margin({
          left: 10, right: 10
        })
        .onClick(async () => {
          ToastUtil.show("扫一扫")
        })

      Line()
        .width(1)
        .height(17)
        .backgroundColor($r('[module_base].color.theme_color'))

      SearchInput({
        popularSearches: this.popularSearches,
        onPopularSearchesIndexChange: (newIndex:number)=>{
          this.popularSearchesCurrentIndex = newIndex
        }
      })
        .layoutWeight(1)
        .margin({ left: 10 })

      Image($r('app.media.ic_mics'))
        .width(20)
        .height(20)
        .objectFit(ImageFit.Cover)
        .margin({ left: 5, right: 10 })
        .onClick(async () => {
          ToastUtil.show("语音录入")
        })

      Text('搜索')
        .width(50)
        .height(28)
        .fontSize(15)
        .fontColor(Color.White)
        .border({ radius: 20 })
        .backgroundColor('#385c3d')
        .textAlign(TextAlign.Center)
        .onClick(async () => {
          AppRouter.toSearchPage('', this.popularSearches.length > 0 ?
            this.popularSearches[this.popularSearchesCurrentIndex % this.popularSearches.length] : undefined)
        })
    }
    .height(35)
    .id('search')
    .borderRadius(20)
    .backgroundColor(Color.White)
    .padding({
      top: 2,
      right: 4,
      bottom: 2
    })
    .margin({
      right: 10
    })
    .border({
      width: 1,
      radius: 20,
      color: ColorUtils.transparentToColor('#2bb856', this.ratio)
    })
  }
}