/**
 * @author weioule
 * @date 2025-02-02
 * 加购物车按钮
 */
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';

@Component
export struct AddCartButtonView {
  @Prop cartNum: number = 0;
  @Prop commodityId: string = '';
  @State minBuyQuantity: number = 0;

  build() {
    RelativeContainer() {
      if (this.cartNum == 0 && this.minBuyQuantity > 0) {
        Text(this.minBuyQuantity + '件起购')
          .maxLines(1)
          .height(26)
          .fontSize(8)
          .borderRadius(50)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .padding({ left: 5, right: 5 })
          .linearGradient({
            angle: 90,
            colors: [
              ['#009436', 0.0],
              ['#6ece3a', 1.0],
            ]
          })
      } else {
        Image($r("app.media.ic_add_cart"))
          .width(27)
          .height(27)
          .id('icon_cart')
          .borderRadius(30)
          .objectFit(ImageFit.Contain)
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
          })
      }

      Text((this.cartNum > 99) ? "99+" : `${this.cartNum}`)
        .height(13)
        .width('auto')
        .borderRadius(6)
        .margin({ left: -10 })
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .fontSize(MyApp.Font.smallTextSize)
        .constraintSize({ minWidth: 13 })
        .minFontSize(MyApp.Font.minimumTextSize)
        .backgroundColor($r('[module_base].color.red_color'))
        .visibility(this.cartNum > 0 ? Visibility.Visible : Visibility.None)
        .padding({
          top: 1,
          bottom: 1,
          left: 2,
          right: 2
        })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: 'icon_cart', align: HorizontalAlign.End }
        })

    }
    .width('auto')
    .height(30)
    .margin({ bottom: 4 })
    .onClick(() => {
      this.cartNum ++
      //ToastUtil.show('加购成功')
    })
  }
}