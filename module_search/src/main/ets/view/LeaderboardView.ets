import { LeaderboardBean } from '../bean/LeaderboardBean'
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean'
import { AddCartButtonView } from 'module_base/src/main/ets/view/AddCartButtonView'
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter'
import { MoneyUtils } from 'module_base/src/main/ets/utils/MoneyUtils'

@ComponentV2
export struct LeaderboardView {
  @Param data?: LeaderboardBean | undefined = undefined
  @Param index: number = 0

  build() {
    Column() {
      Row() {
        Text(this.data?.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('[module_base].color.txt_color'))
          .margin({
            left: this.index == 0 ? 10 : 0
          })

        Image($r('[module_base].media.ic_back'))
          .width(18)
          .height(18)
          .padding(2)
          .rotate({ angle: 180 })
          .visibility(this.index == 0 ? Visibility.Visible : Visibility.None)

        Blank()

        Text('全部榜单')
          .fontSize(15)
          .fontColor(0xffbe9d74)
          .border({ radius: 20 })
          .backgroundColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .visibility(this.index == 0 ? Visibility.None : Visibility.Visible)
          .padding({
            left: 10,
            top: 5,
            right: 10,
            bottom: 4
          })

      }.width('100%')
      .height(this.index == 0 ? 50 : 40)
      .padding({ top: this.index == 0 ? 10 : 0 })

      Column() {
        ForEach(this.data?.list, (commodity: Commodity, i: number) => {
          if (i < 6) {
            ListItem() {
              Stack() {
                Row() {
                  Image(commodity.commodityPic)
                    .width(60)
                    .height(60)
                    .margin({ left: 5 })
                    .objectFit(ImageFit.Contain)
                    .alignRules({
                      left: { anchor: '__container__', align: HorizontalAlign.Start },
                      top: { anchor: '__container__', align: VerticalAlign.Top },
                      right: { anchor: '__container__', align: HorizontalAlign.End },
                      bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
                    })

                  Column() {
                    Text(commodity.commodityName + ' ' + commodity.commoditySpec)
                      .fontSize(16)
                      .fontWeight(4)
                      .width('100%')
                      .maxLines(1)
                      .margin({ bottom: 5 })
                      .fontColor($r('[module_base].color.txt_color'))

                    Row() {
                      Text('¥')
                        .fontSize(12)
                        .padding({ bottom: 2 })
                        .fontColor($r('[module_base].color.red_color'))
                        .alignRules({
                          bottom: { anchor: 'price', align: VerticalAlign.Bottom },
                          right: { anchor: 'price', align: HorizontalAlign.Start }
                        })

                      Text(MoneyUtils.formattedAmount(commodity.price)
                        .split('.')[0])
                        .maxLines(1)
                        .id('price')
                        .fontSize(17)
                        .fontColor($r('[module_base].color.red_color'))
                        .alignRules({
                          top: { anchor: '__container__', align: VerticalAlign.Top }
                        })

                      Text('.' + MoneyUtils.formattedAmount(commodity.price).split('.')[1])
                        .maxLines(1)
                        .fontSize(12)
                        .id('price_decimal')
                        .padding({ bottom: 2 })
                        .fontColor($r('[module_base].color.red_color'))
                        .alignRules({
                          bottom: { anchor: 'price', align: VerticalAlign.Bottom },
                          left: { anchor: 'price', align: HorizontalAlign.End }
                        })

                      Text('/' + commodity.commodityUnit)
                        .fontSize(16)
                        .fontWeight(4)
                        .fontColor($r('[module_base].color.txt_color_999'))
                        .visibility(commodity.price > 0 ? Visibility.Visible : Visibility.Hidden)

                      Blank()

                      AddCartButtonView({
                        commodityId: commodity.commodityId,
                        minBuyQuantity: commodity.minBuyQuantity
                      })
                        .visibility(commodity.hasStock ? Visibility.Visible : Visibility.Hidden)
                    }
                    .width('100%')
                    .alignItems(VerticalAlign.Bottom)
                    .justifyContent(FlexAlign.SpaceBetween)
                    .visibility(commodity.itemType == 0 ? Visibility.Visible : Visibility.None)

                    Row() {
                      Image($r(i < 3 ? "app.media.ic_fire" : "app.media.ic_fire_gradient"))
                        .width(15)
                        .height(15)
                        .margin({ right: 3, bottom: 3 })

                      Text('热度' + commodity.heat / 10000 + 'W')
                        .fontSize(12)
                        .fontColor(i < 3 ? 0xffff5b5d : 0xff8c8c8c)
                    }
                    .width('auto')
                    .borderRadius(15)
                    .margin({ top: 10 })
                    .backgroundColor(i < 3 ? 0xfffef5f6 : 0xfff6f7f6)
                    .visibility(commodity.itemType == 6 ? Visibility.Visible : Visibility.None)
                    .padding({
                      left: 10,
                      top: 5,
                      right: 10,
                      bottom: 5
                    })

                  }.layoutWeight(1)
                  .borderRadius(20)
                  .margin({ left: 5 })
                  .alignItems(HorizontalAlign.Start)
                }
                .backgroundColor(Color.White)
                .alignItems(VerticalAlign.Top)
                .padding({ top: 10, right: 5, bottom: 5 })

                Text((i + 1).toString())
                  .width(22)
                  .height(22)
                  .fontSize(13)
                  .fontColor(Color.White)
                  .textAlign(TextAlign.Center)
                  .backgroundImageSize(ImageSize.Cover)
                  .position({ x: 0, y: 0 })// 左上角坐标 (0, 0)
                  .background(this.BubbleBackground(i + 1))
              }

            }.padding({ top: 10 })
            .onClick(() => {
              AppRouter.toCommodityDetailPage(commodity.commodityId)
            })
          }

        }, (commodity: Commodity) => JSON.stringify(commodity))
      }
      .padding(10)
      .layoutWeight(1)
      .margin({ top: 5 })
      .backgroundColor(Color.White)
      .border({ radius: this.index == 0 ? { bottomLeft: 15, bottomRight: 15 } : 15 })
      .shadow({
        radius: 10, // 阴影模糊半径，值越大越模糊
        color: Color.White, // 阴影颜色
        offsetX: 0, // X方向偏移，0表示四周均匀模糊
        offsetY: -3   // Y方向偏移，0表示四周均匀模糊
      })

      Text('查看更多')
        .height(50)
        .fontSize(15)
        .width('100%')
        .fontColor(0xffbe9d74)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)
        .visibility(this.index > 0 && (this.data?.list?.length ?? 0 > 6) ?
        Visibility.Visible : Visibility.None)

    }
    .border({ radius: 15 })
    .height((this.index == 0 ? 600 : 650))
    .margin({ bottom: this.index == 0 ? 50 : 0 })
    .linearGradient({
      colors: [
        ['#fed4bf', 0.0],
        ['#fef5eb', 0.1],
        ['#ffeedc', 0.3],
        ['#ffddcb', 1.0]
      ]
    })
    .padding(this.index == 0 ? 0 : {
      left: 10,
      top: 10,
      right: 10,
    })
  }

  @Builder
  BubbleBackground(index: number) {
    Image($r('app.media.ic_ranking'))
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Fill)
      .fillColor(this.getFillColor(index))
      .resizable({
        slice: {
          top: 3,
          bottom: 3,
          left: 5,
          right: 5
        }
      })
  }

  getFillColor(index: number): ResourceColor {
    return index == 1 ? 0xfffebe7b : index == 2 ? 0xffa3c1d5 : index == 3 ? 0xffdbb1a0 : 0xffd5cbc7
  }
}