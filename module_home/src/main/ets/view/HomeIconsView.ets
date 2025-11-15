import { RefreshState } from 'module_base/src/main/ets/refresh/MyPullToRefresh';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { CategoryBean as CategoryBean } from 'module_base/src/main/ets/bean/CategoryBean';

/**
 * @author weioule
 * @date 2025-10-12
 */
@Component
export struct HomeIconsView {
  @State ratio: number = 0
  @State yOffset: number = 0
  @State folded: boolean = false
  @State scrollOffset: number = 0
  @State waterFlowHeight: number = 0
  @State pullToRefreshHeight: number = 0
  @State hasNextPage: boolean | null = null
  @State refreshState: number = RefreshState.FREE
  @State popularSearches: PopularSearchesBean[] = []
  @State icons: CategoryBean[] = [] //图标列表
  private scroller: Scroller = new Scroller()

  build() {
    Column() {
      Grid(this.scroller) {
        ForEach(this.icons, (item: CategoryBean) => {
          GridItem() {
            Column() {
              Image(item.picUrl)
                .width(50)
                .height(50)
                .objectFit(ImageFit.Cover)
                .border({
                  width: 1,
                  radius: 20,
                  color: Color.Red
                })

              Text(item.categoryName)
                .padding(10)
                .fontSize(14)
            }
            .border({ radius: 10 })
            .backgroundColor(Color.White)
          }
        })
      }
      .rowsGap(6)
      .id('icons')
      .height(170)
      .width('100%')
      .columnsGap(6)
      .scrollBar(BarState.Off)
      .rowsTemplate('1fr 1fr')
      .edgeEffect(EdgeEffect.None)
      .padding({ left: 8, right: 8 })
      .layoutDirection(GridDirection.Row)
      .margin({
        left: -8,
        top: 15,
        right: -8,
        bottom: 5
      }) // 使用负边距让内容可以滑出padding区域

      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Horizontal, state: BarState.On }) {
        Column()
          .width(15)
          .height(5)
          .borderRadius(3)
          .backgroundColor(Color.Green)
      }
      .width(30)
      .height(5)
      .id('scrollBar')
      .borderRadius(3)
      .margin({ bottom: 5 })
      .backgroundColor($r('[module_base].color.line_gray'))
    }
    .width('100%')
    .margin({ top: 8 })
    .backgroundColor(Color.White)
    .border({ radius: { topLeft: 10, topRight: 10 } })
    .height(200) //指定精确高度，因外部容器是RelativeContainer，避免渲染时因计算误差出现缝隙
  }
}