import { AddCartButtonView } from 'module_base/src/main/ets/view/AddCartButtonView';
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { PriceView } from 'module_base/src/main/ets/view/PriceView';
import { RefreshState } from 'module_base/src/main/ets/refresh/MyPullToRefresh';

/**
 * @author weioule
 * @date 2025-02-01
 * 分类页商品条目
 */
@Component
export struct ClassifyCommodityItem {
  @ObjectLink commodity: Commodity;
  @Prop state: number = 0

  aboutToAppear(): void {
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image(this.commodity.commodityPic)
            .height('auto')
            .objectFit(ImageFit.Contain)
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
        }
        .width(80)

        Column() {
          Column() {
            Text(this.commodity.commodityName)
              .fontSize(16)
              .fontWeight(4)
              .width('100%')
              .margin({ bottom: 5 })
              .fontColor($r('[module_base].color.txt_color'))

            Text(this.commodity.commoditySubName)
              .width('100%')
              .fontSize('14vp')
              .fontColor($r('[module_base].color.txt_color_666'))
          }
          .width('100%')

          Row() {
            PriceView({
              //价格显示
              oldPrice: this.commodity.oldPrice,
              price: this.commodity.price,
              oldPriceLeftMargin: 10,
              fontSizeBig: 17
            }).layoutWeight(1)

            AddCartButtonView({
              commodityId: this.commodity.commodityId,
              minBuyQuantity: this.commodity.minBuyQuantity
            })
              .visibility(this.commodity.hasStock ? Visibility.Visible : Visibility.Hidden) //购物车按钮
          }.margin({ top: 5 })
        }.layoutWeight(1)
        .margin({ left: 5 })
      }
      .onClick(() => {
        if (this.state == RefreshState.FREE) {
          //解决当内容不满一屏在子条目区域内上拉、下拉抬手时触发点击事件的问题
          AppRouter.toCommodityDetailPage(this.commodity.commodityId);
        }
      })
      .padding(1)
      .width('100%')
      .alignItems(VerticalAlign.Top)

    }
    .width('100%')
    .backgroundColor(Color.White)
    .padding({ top: 10, right: 5, bottom: 5 })
  }
}
