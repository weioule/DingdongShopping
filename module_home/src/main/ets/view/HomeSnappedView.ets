import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { RefreshState } from 'module_base/src/main/ets/refresh/MyPullToRefresh';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';

/**
 * @author weioule
 * @date 2025-10-12
 */
@Component
export struct HomeSnappedView {
  @State ratio: number = 0
  @State yOffset: number = 0
  @State folded: boolean = false
  @State scrollOffset: number = 0
  @State waterFlowHeight: number = 0
  @State pullToRefreshHeight: number = 0
  @State hasNextPage: boolean | null = null
  @State refreshState: number = RefreshState.FREE
  @State popularSearches: PopularSearchesBean[] = []
  @State snapped: Commodity[] = [] //图标列表

  build() {
    Column() {
      RelativeContainer() {
        //叮咚买菜这里使用图片实现
        Text('今日疯抢')
          .fontSize(20)
          .id('snapped')
          .fontWeight(FontWeight.Bold)
          .padding({
            left: 10,
            top: 10,
            right: 5,
            bottom: 10
          })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })

        Text('好货万人抢')
          .padding(3)
          .fontSize(11)
          .borderRadius(3)
          .fontColor(Color.White)
          .backgroundColor('#ff3133')
          .margin({ top: 12, right: 5 })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: 'snapped', align: HorizontalAlign.End }
          })

        Image($r('[module_base].media.ic_back'))
          .width(15)
          .height(15)
          .id('right_arrow')
          .rotate({ angle: 180 })
          .margin({ top: 12, right: 10 })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })

        Text('爆款好货 低价天天抢')
          .fontSize(13)
          .margin({ top: 12 })
          .fontColor($r('[module_base].color.txt_color_666'))
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            right: { anchor: 'right_arrow', align: HorizontalAlign.Start }
          })

        List() {
          ForEach(this.snapped, (item: Commodity, index: number) => {
            ListItem() {
              Column() {
                Image(item.commodityPic)
                  .width(70)
                  .height(70)
                  .objectFit(ImageFit.Cover)
                  .border({
                    width: 1,
                    radius: 5,
                    color: Color.Red
                  })

                Stack({ alignContent: Alignment.End }) {
                  Text() {
                    Span('¥ ')
                      .fontSize(10)
                      .fontColor(Color.Black)
                      .fontColor($r('[module_base].color.red_color'))

                    Span('' + item.price)
                      .height(20)
                      .fontSize(13)
                      .margin({ left: 6 })
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('[module_base].color.red_color'))
                  }
                  .height(20)
                  .width('100%')
                  .borderRadius(10)
                  .align(Alignment.Center)
                  .padding({ left: 6, top: 1 })
                  .linearGradient({
                    angle: 90,
                    colors: [
                      ['#fef0ef', 1.0],
                      ['#ffdbdb', 1.0],
                    ]
                  })

                  Image($r('app.media.ic_snapped'))
                    .width(27)
                    .height(20)
                    .objectFit(ImageFit.Contain)

                }.width(70)
                .margin({ top: 6 })

                Text('¥' + item.oldPrice)
                  .fontSize(14)
                  .height(20)
                  .margin({ top: 5 })
                  .fontColor($r('[module_base].color.gray_color'))
                  .decoration({
                    type: TextDecorationType.LineThrough, // 中划线类型
                    color: $r('[module_base].color.gray_color')
                  })
              }
              .border({ radius: 10 })
              .backgroundColor(Color.White)
              .margin({
                left: index === 0 ? 16 : 8,
                right: index === (this.snapped?.length ?? 0) - 1 ? 16 : 8
              })
            }
          })
        }
        .height(140)
        .width('100%')
        .padding({ bottom: 10 })
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.None)
        .listDirection(Axis.Horizontal)
        .alignRules({
          top: { anchor: 'snapped', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End },
        })

      }
      .height(170)
      .border({ radius: 10 })
      .margin({ left: 10, top: 2, right: 10 })
      .linearGradient({
        colors: [
          ['#ffe7e8', 0.0],
          ['#fefbfb', 0.2],
          ['#fefffe', 1.0]
        ]
      })
    }
    .height(172)
    .width('100%')
    .linearGradient({
      angle: 180,
      colors: [
        [$r('[module_base].color.white'), 0.0],
        [$r('[module_base].color.bg_color'), 1.0],
      ]
    })
  }
}