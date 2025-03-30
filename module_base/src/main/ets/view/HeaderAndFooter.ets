/**
 * @author weioule
 * @date 2025-03-2
 * 头尾组件
 */
@Component
export struct HeaderAndFooter {
  @State name: string = ''
  @State fontColor: Resource = $r('app.color.txt_color')

  build() {
    RelativeContainer() {
      Text(this.name)
        .fontSize(14)
        .width('auto')
        .height('auto')
        .id('guess_you_like')
        .fontColor(this.fontColor)
        .alignSelf(ItemAlign.Center)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Normal)
        .backgroundColor($r('app.color.bg_color'))
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })

      Image($r('app.media.ic_lozenge'))
        .width(6)
        .height(6)
        .id('img1')
        .margin({ right: 6 })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: 'guess_you_like', align: HorizontalAlign.Start },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })

      Line()
        .backgroundColor($r('app.color.line_gray'))
        .height(0.5)
        .id('line1')
        .width('fill')
        .margin({ left: 10, right: 6 })
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: 'img1', align: HorizontalAlign.Start },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })

      Image($r('app.media.ic_lozenge'))
        .width(6)
        .height(6)
        .id('img2')
        .margin({ left: 6, right: 6 })
        .alignRules({
          left: { anchor: 'guess_you_like', align: HorizontalAlign.End },
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })

      Line()
        .backgroundColor($r('app.color.line_gray'))
        .height(0.5)
        .id('line2')
        .width('fill')
        .margin({ left: 6, right: 10 })
        .alignRules({
          left: { anchor: 'img2', align: HorizontalAlign.End },
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })

    }
    .height(45)
    .width('100%')
    .visibility(this.name ? Visibility.Visible : Visibility.None)
  }
}