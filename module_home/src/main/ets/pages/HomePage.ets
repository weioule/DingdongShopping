import { HomeModel } from '../model/HomeModel';
import { HomeInfoBean } from '../bean/HomeInfoBean';
import { HomeSearchView } from '../view/HomeSearchView';
import { HomeResourceBitView } from '../view/HomeResourceBitView';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { EmptyView } from 'module_base/src/main/ets/view/EmptyView';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { HeaderAndFooter } from 'module_base/src/main/ets/view/HeaderAndFooter';
import { BaseDataSource } from 'module_base/src/main/ets/common/BaseDataSource';
import { CommodityItemView } from 'module_base/src/main/ets/view/CommodityItemView';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { PullToRefresh, RefreshState } from 'module_base/src/main/ets/refresh/MyPullToRefresh';
import { StatusBarContentColor, StatusBarUtils } from 'module_base/src/main/ets/utils/StatusBarUtils';
import { PullToRefreshConfigurator } from 'module_base/src/main/ets/refresh/MyPullToRefreshConfigurator';
import { SwiperWithIndicatorView } from '../view/SwiperWithIndicatorView';

export interface ResultParams {
  currentPage: number
  hasNextPage: boolean
  list: Commodity[]
}

@Entry
@Component
export struct HomePage {
  @State message: string = 'HomePage'
  @Prop @Watch('customShow') mainShow: boolean

  customShow() {
  }

  private pageNo: number = 1
  @State scrollOffset: number = 0
  @State hasNextPage: boolean | null = null
  @State homeInfo: HomeInfoBean | null = null
  @Provide viewModel: HomeModel = new HomeModel()
  @State refreshState: number = RefreshState.FREE
  @State popularSearches: PopularSearchesBean[] = []
  private contentListScroller: Scroller = new Scroller()
  @State sections: WaterFlowSections = new WaterFlowSections()
  @State dataSource: BaseDataSource<Commodity> = new BaseDataSource<Commodity>()
  private refreshConfigurator: PullToRefreshConfigurator = MyApp.Refresh.configurator()

  aboutToAppear(): void {
    this.viewModel.rx_homeInfo.subscribe(data => {
      //刷新前清空数据
      this.dataSource.clear()
      this.sections.splice(0, this.sections.length())

      this.homeInfo = data

      let itemsCount = 1
      this.dataSource.getDataArray().push(new Commodity(7))

      //设置单列sections
      this.sections.push({
        itemsCount: itemsCount, //子条目数量
        crossCount: 1 //一列
      });

      if (null != data.commodityList) {
        this.dataSource.loadMoreData(data.commodityList)

        //设置双列sections
        this.sections.push({
          margin: 10,
          crossCount: 2,
          itemsCount: data.commodityList.length
        })
      }

      //添加尾部的外边距组件，防止上拉抬手后底部的外边距不显示的问题
      this.dataSource.getDataArray().push(new Commodity(5))
      this.sections.push({
        itemsCount: 1,
        crossCount: 1
      });

      this.refreshConfigurator.setHasLoadMore(true)
      this.hasNextPage = null
    })

    this.viewModel.rx_commodityList.subscribe(data => {
      if (null != data.list && data.list.length > 0) {
        //删除尾部的外边距组件配置
        this.sections.splice(this.sections.length() - 1, 1)
        // 非第一页就删除尾部的外边距组件元素，等组装好所有数据后再次添加
        this.dataSource.getDataArray().splice(this.dataSource.totalCount() - 1)

        let index = -1
        for (let i = 0; i < this.sections.length(); i++) {
          let section = this.sections.values();
          if (section[i].crossCount == 2) {
            index = i
            break
          }
        }

        this.dataSource.loadMoreData(data.list)
        if (index > -1) {
          //之前存在两列的配置就更新数量
          this.sections.update(index, {
            margin: 10,
            crossCount: 2,
            //全部的商品列表使用同一个两列配置，因为每个分组都是从头开始渲染，显示的时候衔接不上
            itemsCount: data.list.length + this.sections.values()[index].itemsCount
          })
        } else {
          //之前不存在两列的配置就新增配置
          this.sections.push({
            margin: 10,
            crossCount: 2,
            itemsCount: data.list.length
          })
        }

        if (!data.hasNextPage && this.dataSource.totalCount() >= 6) {
          //‘我是有底线的’，独占一行配置，因为使用sections分组配置后，WaterFlow的footer就不起作用了
          this.dataSource.getDataArray().push(new Commodity(4))
          this.sections.push({
            itemsCount: 1,
            crossCount: 1
          })
        }

        //添加尾部的外边距组件，防止上拉抬手后底部的外边距不显示的问题
        this.dataSource.getDataArray().push(new Commodity(5))
        this.sections.push({
          itemsCount: 1,
          crossCount: 1
        });
      }

      this.hasNextPage = data.hasNextPage
      this.refreshConfigurator.setHasLoadMore(data.hasNextPage)
    })

    this.viewModel.getPopularSearches().then((list: PopularSearchesBean[]) => {
      this.popularSearches = list
    })

    this.viewModel.refresh()
  }

  build() {
    RelativeContainer() {
      PullToRefresh({
        changeStateOutside: (state) => {
          this.refreshState = state
        },
        refreshConfigurator: this.refreshConfigurator,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.contentListScroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: () => {
          // 一个用@Builder修饰过的UI方法
          this.ContentView();
        },
        // 可选项，下拉刷新回调
        onRefresh: () => {
          this.pageNo = 1
          return this.viewModel.refresh()
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          this.pageNo++
          return this.viewModel.loadMore(this.pageNo)
        },
        customLoad: null,
        customRefresh: null
      })
        .clip(true)
        .height('100%')
        .backgroundColor($r('[module_base].color.bg_color'))

      //置顶按钮
      Image($r("app.media.ic_to_top"))
        .width(36)
        .height(36)
        .margin({ right: 12, bottom: 40 + MyApp.Size.naviBar })
        .visibility(this.scrollOffset > 1000 ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.contentListScroller.scrollToIndex(0)
          this.scrollOffset = 0
        })
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
    }
    .width('100%')
    .height('100%')
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, _currentRatio: number) => {
      if (this.scrollOffset > 20) {
        StatusBarUtils.setStatusBarTextColor(MyApp.AppUtil.context, StatusBarContentColor.BLACK)
      } else {
        StatusBarUtils.setStatusBarTextColor(MyApp.AppUtil.context, StatusBarContentColor.WHITE)
      }
    })
  }

  @Builder
  ContentView() {
    Stack({ alignContent: Alignment.Top }) {
      WaterFlow({ scroller: this.contentListScroller, sections: this.sections }) {
        LazyForEach(this.dataSource, (commodity: Commodity, index) => {
          FlowItem() {
            if (commodity.itemType == 8) {
              SwiperWithIndicatorView({ banners: commodity.commodityList })
            } else if (commodity.itemType == 0) {
              CommodityItemView({ commodity: commodity, state: this.refreshState })
            } else if (commodity.itemType == 1) {
              EmptyView()
            } else if (commodity.itemType == 2) {
              HeaderAndFooter({ name: '猜你喜欢' })
            } else if (commodity.itemType == 4) {
              HeaderAndFooter({ name: '我是有底线的' })
            } else if (commodity.itemType == 5) {
              Column().height(0).width('100%')
            } else if (commodity.itemType == 7) {
              HomeResourceBitView({
                homeInfo: this.homeInfo,
                scrollOffset: this.scrollOffset,
                popularSearches: this.popularSearches
              })
            }
          }

        }, (c: Commodity) => {
          return JSON.stringify(c)
        })
      }
      .clip(true)
      .rowsGap(10)
      .width('100%')
      .columnsGap(8)
      .cachedCount(8)
      .height('100%')
      .scrollBar(BarState.Off)
      .columnsTemplate("1fr 1fr")
      .edgeEffect(EdgeEffect.Fade)
      .backgroundColor($r('[module_base].color.bg_color'))
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
      .enableScrollInteraction(this.refreshState == RefreshState.FREE || this.refreshState > RefreshState.Refreshing)
      .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
        if (scrollOffset != 0) {
          //非顶部不能刷新，否则会影响WaterFlow的滚动
          this.refreshConfigurator.setHasRefresh(false)
        }

        this.scrollOffset = this.contentListScroller.currentOffset().yOffset

        //动态更新状态栏内容颜色
        if (this.scrollOffset > 20) {
          StatusBarUtils.setStatusBarTextColor(MyApp.AppUtil.context, StatusBarContentColor.BLACK)
        } else {
          StatusBarUtils.setStatusBarTextColor(MyApp.AppUtil.context, StatusBarContentColor.WHITE)
        }
      })
      .onReachStart(() => {
        //滑动到顶部了 可以刷新
        this.refreshConfigurator.setHasRefresh(true)
      })

      //吸顶效果悬浮组件
      HomeSearchView({ popularSearches: this.popularSearches, scrollOffset: HomeResourceBitView.ROLLING_OFFSET })
        .visibility(this.scrollOffset >= HomeResourceBitView.ROLLING_OFFSET ? Visibility.Visible : Visibility.None)
    }
  }
}