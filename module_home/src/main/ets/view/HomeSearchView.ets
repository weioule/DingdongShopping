import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { ColorUtils } from 'module_base/src/main/ets/utils/ColorUtils';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { HomeResourceBitView } from './HomeResourceBitView';
import { SearchBoxView } from './SearchBoxView';

/**
 * @author weioule
 * @date 2025-10-12
 */
@Component
export struct HomeSearchView {
  @State type: number = 1
  @Prop scrollOffset: number = 0
  @State popularSearches: PopularSearchesBean[] = []

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_rider'))
          .width(30)
          .height(20)
          .padding({ left: 10 })

        Text('可约10:30配送')
          .maxLines(1)
          .fontSize(14)
          .margin({ left: 5 })
          .margin({ right: 10 })
          .fontColor($r('[module_base].color.green_color'))
      }
      .clip(true)
      .height(36)
      .width(this.getEasedWidth())
      .alignItems(VerticalAlign.Center)
      .visibility(this.scrollOffset > 0 ? Visibility.Visible : Visibility.Hidden)
      .opacity(Math.min(this.scrollOffset / 45, 1)) //滚动高度是42，使用45是为了提早一点透明
      .margin({ right: Math.min(6 * (this.scrollOffset / HomeResourceBitView.ROLLING_OFFSET), 10) })
      .border({
        width: 1,
        radius: 20,
        color: ColorUtils.transparentToColor('#e7e7e7', Math.min(this.scrollOffset / 45, 1))
      })
      .onClick(async () => {
        ToastUtil.show("可约配送时间")
      })

      SearchBoxView({
        popularSearches: this.popularSearches,
        ratio: this.scrollOffset >= HomeResourceBitView.ROLLING_OFFSET ? 1 :
          this.scrollOffset / HomeResourceBitView.ROLLING_OFFSET
      }).layoutWeight(1)

    }
    .alignItems(VerticalAlign.Center)
    .height(this.type == 1 ? 50 + MyApp.Size.statusBar : 50)
    .backgroundColor(this.type == 1 ? Color.White : Color.Transparent)
    .padding({ left: 10, top: this.type == 1 ? MyApp.Size.statusBar : 0 })
  }

  // 使用缓动函数
  private getEasedWidth(): number {
    const progress = Math.min(Math.max(this.scrollOffset / HomeResourceBitView.ROLLING_OFFSET, 0), 1);
    // 使用二次缓动函数，让变化更平滑
    const easedProgress = progress * progress;
    return 140 * easedProgress;
  }
}