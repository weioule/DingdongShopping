/**
 * @author weioule
 * @date 2025-02-02
 * 价格显示
 */
import { MoneyUtils } from '../utils/MoneyUtils';

@Component
export struct PriceView {
  @Prop oldPrice: number = 0; // 原价
  @Prop price: number = 0; //优惠后价格
  @State fontSize: number = 12; // 小字体
  @State fontSizeBig: number = 16; // 大字体
  @State oldPriceLeftMargin: number = 2; // 原价距离优惠价的距离

  aboutToAppear(): void {
  }

  build() {
    Row() {
      Text('¥')
        .fontColor($r('app.color.red_color'))
        .fontSize(this.fontSize)
        .padding({ bottom: this.fontSizeBig > 17 ? 3 : 2 })
        .alignRules({
          bottom: { anchor: 'price', align: VerticalAlign.Bottom },
          right: { anchor: 'price', align: HorizontalAlign.Start }
        })

      Text(MoneyUtils.formattedAmount(this.price > 0 && this.price < this.oldPrice ? this.price : this.oldPrice)
        .split('.')[0])
        .maxLines(1)
        .id('price')
        .fontSize(this.fontSizeBig)
        .fontColor($r('app.color.red_color'))
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
        })

      Text('.' + MoneyUtils.formattedAmount(this.price > 0 && this.price < this.oldPrice ? this.price : this.oldPrice)
        .split('.')[1])
        .maxLines(1)
        .id('price_decimal')
        .fontSize(this.fontSize)
        .fontColor($r('app.color.red_color'))
        .padding({ bottom: this.fontSizeBig > 17 ? 3 : 2 })
        .alignRules({
          bottom: { anchor: 'price', align: VerticalAlign.Bottom },
          left: { anchor: 'price', align: HorizontalAlign.End }
        })

      if (this.price > 0 && this.price < this.oldPrice) {
        Text('¥' + MoneyUtils.formattedAmount(this.oldPrice))
          .maxLines(1)
          .id('oldPrice')
          .fontSize(this.fontSize)
          .margin({ left: this.oldPriceLeftMargin })
          .fontColor($r('app.color.txt_color_999'))
          .padding({ bottom: this.fontSizeBig > 17 ? 3 : 2 })
          .alignRules({
            left: { anchor: 'price_decimal', align: HorizontalAlign.End },
            bottom: { anchor: 'price', align: VerticalAlign.Bottom }
          })
          .decoration({
            color: $r('app.color.txt_color_999'),
            type: TextDecorationType.LineThrough
          })
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Bottom)
  }
}