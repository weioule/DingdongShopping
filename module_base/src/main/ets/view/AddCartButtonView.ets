import { MyApp } from "../common/Application";

/**
 * @author weioule
 * @date 2025-02-02
 * 加购物车按钮
 */
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
              ['#01c335', 0.0],
              ['#019c2a', 1.0],
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
        .borderRadius(10)
        .margin({ left: -10 })
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .constraintSize({ minWidth: 13 })
        .fontSize(MyApp.Font.smallTextSize)
        .minFontSize(MyApp.Font.minimumTextSize)
        .backgroundColor($r('app.color.red_color'))
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
      this.cartNum++
    })
  }
}