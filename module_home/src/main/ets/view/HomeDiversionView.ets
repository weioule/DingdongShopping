import { RefreshState } from 'module_base/src/main/ets/refresh/MyPullToRefresh';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { CategoryBean as CategoryBean } from 'module_base/src/main/ets/bean/CategoryBean';

/**
 * @author weioule
 * @date 2025-10-12
 */
@Component
export struct HomeDiversionView {
  @State ratio: number = 0
  @State yOffset: number = 0
  @State folded: boolean = false
  @State scrollOffset: number = 0
  @State waterFlowHeight: number = 0
  @State pullToRefreshHeight: number = 0
  @State hasNextPage: boolean | null = null
  @State refreshState: number = RefreshState.FREE
  @State popularSearches: PopularSearchesBean[] = []
  @State diversion: CategoryBean[] = [] //图标列表

  build() {
    Row() {
      Image(this.diversion[0].picUrl)
        .height(100)
        .layoutWeight(1)
        .objectFit(ImageFit.Cover)
        .border({
          width: 1,
          radius: 10,
          color: Color.Red
        })

      if (this.diversion?.length > 1) {
        Image(this.diversion[1].picUrl)
          .height(100)
          .layoutWeight(1)
          .margin({ left: 10 })
          .objectFit(ImageFit.Cover)
          .border({
            width: 1,
            radius: 10,
            color: Color.Red
          })
      }
    }
    .padding(10)
    .backgroundColor(Color.White)
    .height(120) //指定精确高度，因外部容器是RelativeContainer，避免渲染时因计算误差出现缝隙
  }
}