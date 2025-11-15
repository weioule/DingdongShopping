import { MyApp } from 'module_base/src/main/ets/common/Application';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';

/**
 * @author weioule
 * @date 2025-10-12
 */
@Component
export struct HomeAddressView {
  @State address: string = ''
  @State msgCount: number = 0

  build() {
    RelativeContainer() {
      Row() {
        Image($r('app.media.ic_address'))
          .width(20)
          .height(20)
          .id('iv_back')
          .objectFit(ImageFit.Cover)

        Text(this.address ?? '--')
          .fontSize(15)
          .width('auto')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('[module_base].color.white'))

        Image($r('app.media.ic_pull_down'))
          .width(25)
          .height(25)
          .padding(5)
      }
      .height(32)
      .width('auto')
      .justifyContent(FlexAlign.Start)
      .padding({ left: 10, right: 5 })
      .alignItems(VerticalAlign.Center)
      .alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        top: { anchor: '__container__', align: VerticalAlign.Top },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .onClick(() => {
        ToastUtil.show("收货地址")
      })

      RelativeContainer() {
        Image($r('app.media.ic_msg'))
          .width(24)
          .height(24)
          .id('iv_cart')
          .objectFit(ImageFit.Contain)
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
          })

        Text((this.msgCount ?? 0 > 99) ? "99+" : `${this.msgCount ?? 0}`)
          .height(13)
          .fontSize(10)
          .width('auto')
          .minFontSize(8)
          .borderRadius(6)
          .margin({ left: -10 })
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .constraintSize({ minWidth: 13 })
          .backgroundColor($r('[module_base].color.red_color'))
          .visibility(this.msgCount ?? 0 > 0 ? Visibility.Visible : Visibility.None)
          .padding({
            top: 1,
            bottom: 1,
            left: 2,
            right: 2
          })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: 'iv_cart', align: HorizontalAlign.End }
          })
      }
      .width(50)
      .height(30)
      .id('rc_cart')
      .padding({ left: 10 })
      .onClick(async () => {
        ToastUtil.show("消息")
      })
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      })
    }
    .width('100%')
    .height(42 + MyApp.Size.statusBar)
    .padding({ top: MyApp.Size.statusBar })
  }
}