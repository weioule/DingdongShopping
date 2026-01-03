import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { ColorUtils } from 'module_base/src/main/ets/utils/ColorUtils';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { HomeDiversionView } from './HomeDiversionView';
import { HomeInfoBean } from '../bean/HomeInfoBean';
import { HomeAddressView } from './HomeAddressView';
import { HomeSnappedView } from './HomeSnappedView';
import { HomeBannersView } from './HomeBannersView';
import { HomeSearchView } from './HomeSearchView';
import { HomeIconsView } from './HomeIconsView';

/**
 * @author weioule
 * @date 2025-10-11
 */
@Component
export struct HomeResourceBitView {
  static readonly ROLLING_OFFSET = 42
  static readonly MAX_COUNT: number = 100
  @Prop scrollOffset: number = 0
  @State totalHeight: number = 128
  @State homeInfo: HomeInfoBean | null = null
  @State popularSearches: PopularSearchesBean[] = []

  aboutToAppear(): void {
    if ((this.homeInfo?.banners?.length ?? 0) > 0) {
      this.totalHeight += 210
    }
    if ((this.homeInfo?.icons?.length ?? 0) > 0) {
      this.totalHeight += 208
    }
    if ((this.homeInfo?.diversion?.length ?? 0) > 0) {
      this.totalHeight += Math.ceil((this.homeInfo?.diversion?.length ?? 0) / 2) * 100 +
        //+间距的总高度
        10 * (Math.ceil((this.homeInfo?.diversion?.length ?? 0) / 2) + 1)
    }
    if ((this.homeInfo?.snapped?.length ?? 0) > 0) {
      this.totalHeight += 172
    }
  }

  build() {
    RelativeContainer() {
      Image($r('app.media.bg_home_top'))
        .height(355)
        .width('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        //高度：128
        Column() {
          HomeAddressView({ address: this.homeInfo?.address, msgCount: this.homeInfo?.msgCount })

          HomeSearchView({ popularSearches: this.popularSearches, scrollOffset: this.scrollOffset, type: 2 })
        }
        .id('address')
        .height(HomeResourceBitView.ROLLING_OFFSET + MyApp.Size.statusBar + 50) //高度：状态栏高度+两组件高度
        .backgroundColor(ColorUtils.transparentToColor(Color.White.toString(),
          this.scrollOffset / HomeResourceBitView.ROLLING_OFFSET)) // 应用渐变背景
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End },
        })

        //高度：110+100
        if ((this.homeInfo?.banners?.length ?? 0) > 0) {
          HomeBannersView({ banners: this.homeInfo?.banners })
            .id('banners')
            .alignRules({
              top: { anchor: 'address', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
              right: { anchor: '__container__', align: HorizontalAlign.End },
            })
        }

        //高度：170+5+15+5+8+5
        if ((this.homeInfo?.icons?.length ?? 0) > 0) {
          HomeIconsView({ icons: this.homeInfo?.icons })
            .id('icons')
            .alignRules({
              top: { anchor: 'banners', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
              right: { anchor: '__container__', align: HorizontalAlign.End },
            })
        }

        //高度：行高度（单行100）+间距（单个间距10），单行总高度=120
        if ((this.homeInfo?.diversion?.length ?? 0) > 0) {
          HomeDiversionView({ diversion: this.homeInfo?.diversion })
            .id('diversion')
            .alignRules({
              top: { anchor: 'icons', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
              right: { anchor: '__container__', align: HorizontalAlign.End },
            })
        }

        //高度：172
        if ((this.homeInfo?.snapped?.length ?? 0) > 0) {
          HomeSnappedView({ snapped: this.homeInfo?.snapped })
            .alignRules({
              top: { anchor: 'diversion', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
              right: { anchor: '__container__', align: HorizontalAlign.End },
            })
        }
      }
    }
    .clip(true)
    .height(this.totalHeight)
    .backgroundColor(Color.White)
  }
}