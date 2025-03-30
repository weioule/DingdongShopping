import { router } from '@kit.ArkUI';
import { SearchListModel } from '../model/SearchListModel';
import { SearchCategoryBean } from '../bean/SearchCategoryBean';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { EmptyView } from 'module_base/src/main/ets/view/EmptyView';
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { HeaderAndFooter } from 'module_base/src/main/ets/view/HeaderAndFooter';
import { BaseDataSource } from 'module_base/src/main/ets/common/BaseDataSource';
import { CommodityItemView } from 'module_base/src/main/ets/view/CommodityItemView';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { PullToRefresh, RefreshState } from 'module_base/src/main/ets/refresh/MyPullToRefresh';
import { PullToRefreshConfigurator } from 'module_base/src/main/ets/refresh/MyPullToRefreshConfigurator';

export interface PARAMS {
  keyword: string;
  popularSearches: PopularSearchesBean;
}

export interface ResultParams {
  currentPage: number;
  hasNextPage: boolean;
  searchList: Commodity[];
  guessYouLikeList: Commodity[];
}

/**
 * @author weioule
 * @date 2025-02-23
 */
@Entry
@Component
export struct SearchListPage {
  private pageNo: number = 1
  private pageSize: number = 10
  private textScroller: Scroller = new Scroller()
  private imageScroller: Scroller = new Scroller()
  private contentListScroller: Scroller = new Scroller()
  private outsideListScroller: Scroller = new Scroller()
  private refreshConfigurator: PullToRefreshConfigurator = MyApp.Refresh.configurator()
  @State cartNum: number = 99
  @State lastIndex: number = 0
  @State folded: boolean = false
  @State classifyId: string = ''
  @State scrollOffset: number = 0
  @State oneColumnCount: number = 0
  @State twoColumnCount: number = 0
  @State selectTabIndex: number = -1
  @State waterFlowHeight: number = 0
  @State pullToRefreshHeight: number = 0
  @State data: ResultParams | null = null
  @State guessYouLikeList: Commodity[] = []
  @State hasGuessYouLikeView: boolean = false
  @State refreshState: number = RefreshState.FREE
  @State installGuessYouLikeTitleIndex: number = -1
  @State searchCategoryList: SearchCategoryBean[] = []
  @State searchType: number = 0 //0:综合  1:销量  2:价格排序
  @Provide viewModel: SearchListModel = new SearchListModel()
  @State sections: WaterFlowSections = new WaterFlowSections()
  @State priceSortType: number = 0 //-1:降序  0:默认不排序  1:升序
  @State keyword: string = (router.getParams() as PARAMS).keyword
  @State dataSource: BaseDataSource<Commodity> = new BaseDataSource<Commodity>()

  aboutToAppear(): void {
    this.viewModel.rx_searchCategoryList.subscribe(list => {
      this.searchCategoryList = list
    })

    this.viewModel.rx_searchList.subscribe(data => {
      if (data.currentPage == 1) {
        //刷新清空数据与布局配置
        this.dataSource.clear()
        this.installGuessYouLikeTitleIndex = -1
        this.sections.splice(0, this.sections.length())

        //添加商品列表顶部的空组件以实现外边距,通过SectionOptions设置margin也可以实现，但跟着下拉刷新组件一起使用时，下拉放手后顶部的外边距没有了，故使用空条目的形式实现
        data.searchList.unshift(new Commodity(5, Date.now() + Math.random().toString()))
        this.sections.push({
          itemsCount: 1, //子条目数量
          crossCount: 1 //一列
        });

        if (data.searchList.length == 1) {
          //搜索结果没有数据，那就添加空页面显示
          data.searchList.push(new Commodity(1, Date.now() + Math.random().toString()))
          //添加空页面配置
          this.sections.push({
            itemsCount: 1,
            crossCount: 1
          })
        } else {
          //搜索结果列表布局配置
          this.sections.push({
            margin: 10,
            crossCount: 2,
            itemsCount: data.searchList.length - 1
          })
        }
      } else {
        //删除尾部的外边距组件配置
        this.sections.splice(this.sections.length() - 1, 1)
        //非第一页就删除尾部的外边距组件元素，等组装好所有数据后再次添加
        this.dataSource.getDataArray().splice(this.dataSource.totalCount() - 1)

        if (data.searchList.length > 0) {
          this.sections.update(1, {
            margin: 10,
            crossCount: 2,
            //全部的搜索结果列表使用同一个两列配置，因为每个分组都是从头开始渲染，显示的时候衔接不上，-1是因为this.dataSource里面包含了外边距控件
            itemsCount: data.searchList.length + this.dataSource.totalCount() - 1
          })
        }
      }

      if (data.guessYouLikeList.length > 0) {
        if (this.installGuessYouLikeTitleIndex == -1) {
          this.installGuessYouLikeTitleIndex = this.dataSource.totalCount() + data.searchList.length
          data.guessYouLikeList.unshift(new Commodity(2, Date.now().toString()))
          //猜你喜欢组件，独占一行配置
          this.sections.push({
            itemsCount: 1,
            crossCount: 1
          })
        }

        this.sections.update(3, {
          //猜你喜欢列表数据也使用同一个两列配置
          margin: 10,
          crossCount: 2,
          itemsCount:
          //注意：sections是按照添加的顺序进行渲染的，分组数量itemsCount累加与总列表数量对应不上是不显示的
          data.guessYouLikeList.length - 1 +
          Math.max(0, (this.dataSource.totalCount() - this.installGuessYouLikeTitleIndex))
        })
      }

      if (!data.hasNextPage && this.dataSource.totalCount() >= 6) {
        //‘我是有底线的’，独占一行配置，因为使用sections分组配置后，WaterFlow的footer就不起作用了
        data.guessYouLikeList.push(new Commodity(4, Date.now() + Math.random().toString()))
        this.sections.push({
          itemsCount: 1,
          crossCount: 1
        })
      }

      //添加尾部的外边距组件，防止上拉抬手后底部的外边距不显示的问题
      if (data.guessYouLikeList.length > 0) {
        data.guessYouLikeList.push(new Commodity(5, Date.now() + Math.random().toString()))
        this.sections.push({
          itemsCount: 1,
          crossCount: 1
        });
      } else if (data.searchList.length > 0) {
        data.searchList.push(new Commodity(5, Date.now() + Math.random().toString()))
        this.sections.push({
          itemsCount: 1,
          crossCount: 1
        });
      }

      this.data = null
      if (data.currentPage == 1) {
        this.dataSource.reloadData(data.searchList)
        this.dataSource.loadMoreData(data.guessYouLikeList)
        this.contentListScroller.scrollToIndex(0)
        //刷新重置滚动偏移量与高度
        this.scrollOffset = 0
        this.waterFlowHeight = 0
        this.pullToRefreshHeight = MyApp.Size.screenHeight - MyApp.Size.statusBar - 165
      } else {
        this.dataSource.loadMoreData(data.searchList)
        this.dataSource.loadMoreData(data.guessYouLikeList)
      }

      this.refreshConfigurator.setHasLoadMore(data.hasNextPage)
    })

    this.viewModel.querySearchCategoryList(this.keyword)
    this.searchCommodityList()
  }

  build() {
    RelativeContainer() {
      List({ scroller: this.outsideListScroller }) {
        ListItemGroup({ header: this.itemHead() }) {
          ListItem() {
            this.TopImageList()
          }
        }

        ListItemGroup({ header: this.itemHeadTextTab() }) {
          ListItem() {
            Column() {
              PullToRefresh({
                changeStateOutside: (state) => {
                  this.refreshState = state
                  if (state == RefreshState.FREE) {
                    //这里做个兜底，若onAreaChange()渲染的时候没有设置高度，在这里补上
                    if (this.waterFlowHeight > 0) {
                      this.pullToRefreshHeight = this.waterFlowHeight
                      this.waterFlowHeight = 0
                    }
                  }
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
                  return this.searchCommodityList()
                },
                // 可选项，上拉加载更多回调
                onLoadMore: () => {
                  this.pageNo++
                  return this.searchCommodityList()
                },
                customLoad: null,
                customRefresh: null,
              })
                .clip(true)
                .height(this.pullToRefreshHeight)
                .backgroundColor($r('[module_base].color.bg_color'))
            }
          }
        }
      }
      .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
        if (scrollOffset != 0) {
          //非顶部不能刷新，否则会影响外部的List滚动
          this.refreshConfigurator.setHasRefresh(false)

          this.folded = this.outsideListScroller.currentOffset().yOffset + scrollOffset >= 45
        }
      })
      .onReachStart(() => {
        //滑动到顶部了 可以刷新
        this.refreshConfigurator.setHasRefresh(true)
      })
      .clip(true)
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .alignListItem(ListItemAlign.Start)
      .sticky(StickyStyle.Header | StickyStyle.Footer) // 设置吸顶，实现粘性标题效果

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
    .padding({ top: MyApp.Size.statusBar })
  }

  @Builder
  itemHead() {
    Column() {
      this.TitleView()
      this.TopTabView()
    }.backgroundColor(Color.White)
  }

  @Builder
  ContentView() {
    WaterFlow({ scroller: this.contentListScroller, sections: this.sections }) {
      LazyForEach(this.dataSource, (commodity: Commodity, index) => {
        FlowItem() {
          if (commodity.itemType == 0) {
            CommodityItemView({ commodity: commodity, state: this.refreshState })
          } else if (commodity.itemType == 1) {
            EmptyView()
          } else if (commodity.itemType == 2) {
            HeaderAndFooter({ name: '猜你喜欢' })
          } else if (commodity.itemType == 4) {
            HeaderAndFooter({ name: '我是有底线的' })
          } else if (commodity.itemType == 5) {
            Column().height(0).width('100%')
          }
        }.onAreaChange((oldValue: Area, newValue: Area) => {
          //PullToRefresh内容高度小于头部折叠时最大可显示的高度才做处理，大于等于不再做处理了
          if (this.pullToRefreshHeight < MyApp.Size.screenHeight - MyApp.Size.statusBar - 40) {
            //newValue.position.y是子条目的顶部在WaterFlow组件上的坐标，需要加上自身的高度
            let itemY = newValue.position.y as number + (newValue.height as number)
            //因为WaterFlow的内容高度是不确定的，所以这里始终获取显示在屏幕上最高的子条目的底部坐标，用来当做WaterFlow的内容高度
            if (this.pullToRefreshHeight <= itemY) {
              this.waterFlowHeight = itemY

              //PullToRefresh以上部分的总高度为165，MyApp.Size.screenHeight - MyApp.Size.statusBar - 165 是外部的List全部打开时waterFlow最大可显示的高度，就是我们要设置给PullToRefresh的最小高度，因为跟外部List嵌套，所以要定制高度，否则大了上拉的时候就看不到加载状态组件，小了加载状态组件就不是在最底部了
              if (this.waterFlowHeight < MyApp.Size.screenHeight - MyApp.Size.statusBar - 165) {
                this.waterFlowHeight = MyApp.Size.screenHeight - MyApp.Size.statusBar - 165
              } else if (this.waterFlowHeight > MyApp.Size.screenHeight - MyApp.Size.statusBar - 40) {
                //超出外部的List全部折叠时waterFlow最大可显示的高度，就指定等于最大可显示的高度
                this.waterFlowHeight = MyApp.Size.screenHeight - MyApp.Size.statusBar - 40
              }

              //上拉加载需要加载组件的状态空闲了再修改pullToRefresh的高度，不然加载状态组件还没有完全收起，会显示异常，若这里没有得到修改，那么在changeStateOutside里处理
              if (this.refreshState <= RefreshState.RefreshComplete) {
                this.pullToRefreshHeight = this.waterFlowHeight
                this.waterFlowHeight = 0
              }
            }
          }
        })

      }, (c: Commodity) => {
        return JSON.stringify(c)
      })
    }
    .clip(true)
    .rowsGap(10)
    .width('100%')
    .height('100%')
    .columnsGap(10)
    .cachedCount(10)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .backgroundColor($r('[module_base].color.bg_color'))
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .enableScrollInteraction(this.refreshState == RefreshState.FREE || this.refreshState > RefreshState.Refreshing)
    .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
      this.scrollOffset = this.contentListScroller.currentOffset().yOffset + scrollOffset
      if (this.refreshState != RefreshState.PullUpLoad &&
        this.refreshState != RefreshState.ReleaseLoad &&
        this.refreshState != RefreshState.Loading) {
        //过滤state = 上拉加载、松开加载、加载中，不然外部的List会显示异常
        this.outsideListScroller.scrollBy(0, scrollOffset)
      }
    })
  }

  @Builder
  TitleView() {
    Row() {
      Image($r('[module_base].media.ic_back'))
        .width(40)
        .height(45)
        .objectFit(ImageFit.Cover)
        .padding({
          top: 11,
          bottom: 11,
          left: 13,
          right: 13
        })
        .onClick(() => {
          router.back()
        })

      Row() {
        Image($r('[module_base].media.ic_search'))
          .width(20)
          .height(20)
          .margin({
            left: 10, right: 10
          })

        Row() {
          Text(this.keyword)
            .height('100%')
            .flexGrow(1)
            .fontSize(11)
            .margin({ top: 2 })
            .fontColor(Color.White)

          Image($r('app.media.ic_delete_white'))
            .width(8)
            .height(8)
            .margin({ left: 5, })
            .objectFit(ImageFit.Cover)
        }
        .height(20)
        .width('auto')
        .borderRadius(20)
        .backgroundColor('#5000')
        .padding({ left: 6, right: 5 })
        .onClick(() => {
          router.back()
        })
      }
      .height(32)
      .flexGrow(1)
      .width('fill')
      .borderRadius(22)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .backgroundColor($r('[module_base].color.white_f6'))
      .onClick(() => {
        AppRouter.toSearchPage(this.keyword, undefined, true)
      })

      RelativeContainer() {
        Image($r('app.media.ic_cart'))
          .width(24)
          .height(24)
          .id('icon_cart')
          .objectFit(ImageFit.Contain)
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
          })

        Text((this.cartNum > 99) ? "99+" : `${this.cartNum}`)
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
      .width(45)
      .height(30)
      .padding({ left: 6, top: 2, bottom: 2 })
      .margin({
        bottom: 4,
        right: 10,
        left: 10
      })
      .onClick(async () => {
        AppRouter.toCartPage();
      })

    }.height(45)
    .width('100%')
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  TopTabView() {
    RelativeContainer() {
      Row() {
        Text(' 综合 ')
          .padding(2)
          .fontSize(14)
          .width('auto')
          .height('auto')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.searchType == 0 ? $r('[module_base].color.theme_color') :
          $r('[module_base].color.txt_color_666'))
          .onClick(() => {
            if (this.searchType != 0) {
              this.pageNo = 1
              this.searchType = 0
              this.searchCommodityList()
            }
          })

        Text(' 销量 ')
          .padding(2)
          .fontSize(14)
          .width('auto')
          .height('auto')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.searchType == 1 ? $r('[module_base].color.theme_color') :
          $r('[module_base].color.txt_color_666'))
          .onClick(() => {
            if (this.searchType != 1) {
              this.pageNo = 1
              this.searchType = 1
              this.searchCommodityList()
            }
          })

        Stack({ alignContent: Alignment.End }) {
          Text(' 价格  ')
            .id('price')
            .fontSize(14)
            .width('auto')
            .height('auto')
            .margin({ top: 5 })
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 2, bottom: 2, right: 1 })
            .fontColor(this.searchType == 2 ? $r('[module_base].color.theme_color') :
            $r('[module_base].color.txt_color_666'))

          Image(this.searchType == 2 ?
            this.priceSortType == 1 ? $r('[module_base].media.ic_sort_up') : $r('[module_base].media.ic_sort_down') :
          $r('[module_base].media.ic_sort_def'))
            .width(6)
            .height(6)

        }
        .width('auto')
        .onClick(async () => {
          if (this.priceSortType == 1) {
            this.priceSortType = -1
          } else {
            this.priceSortType = 1
          }

          this.pageNo = 1
          this.searchType = 2
          this.searchCommodityList()
        })
      }
      .height(35)
      .width('100%')
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceEvenly)

    }
    .height(35)
    .width('100%')
    .margin({ top: 5 })
  }

  @Builder
  TopImageList() {
    List({ scroller: this.imageScroller }) {
      ForEach(this.searchCategoryList, (item: SearchCategoryBean, index?: number) => {
        ListItem() {
          Image(item.picUrl)
            .width(40)
            .height(40)
            .margin({ left: 11, right: 11 })
            .border({
              width: 2,
              radius: 16,
              color: this.selectTabIndex == index ? $r('[module_base].color.theme_color') : '#0000'
            })
        }.onClick(() => {
          if (this.selectTabIndex != index) {
            this.classifyId = item.classifyId
            this.selectTabIndex = index ?? -1
            this.outsideListScroller.scrollEdge(Edge.Top);
            this.textScroller.scrollToIndex(index, false, ScrollAlign.CENTER);
            this.imageScroller.scrollToIndex(index, false, ScrollAlign.CENTER);
          } else {
            this.classifyId = ''
            this.selectTabIndex = -1
          }

          this.pageNo = 1
          this.searchCommodityList()
        })
      })
    }
    .width('100%')
    .height('auto')
    .padding({ top: 5 })
    .scrollBar(BarState.Off)
    .backgroundColor(Color.White)
    .listDirection(Axis.Horizontal)
    .visibility(this.searchCategoryList.length > 0 ? Visibility.Visible : Visibility.None)
    .edgeEffect(EdgeEffect.None, {
      alwaysEnabled: true
    })
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      this.textScroller.scrollTo({
        //文字列表同步滚动
        yOffset: 0,
        animation: false,
        xOffset: this.imageScroller.currentOffset().xOffset + offset
      })
      return { offsetRemain: offset }
    })
  }

  @Builder
  itemHeadTextTab() {
    List({ scroller: this.textScroller }) {
      ForEach(this.searchCategoryList, (item: SearchCategoryBean, index?: number) => {
        ListItem() {
          Text(item.classifyName?.substring(0, item.classifyName.length > 3 ? 4 : item.classifyName.length) ?? '')
            .width(52)
            .height(20)
            .fontSize(12)
            .borderRadius(5)
            .textAlign(TextAlign.Center)
            .margin({
              left: 5,
              top: 5,
              right: 5,
              bottom: 10
            })
            .fontWeight(this.selectTabIndex == index ? FontWeight.Medium : FontWeight.Normal)
            .backgroundColor(this.selectTabIndex == index && this.folded ? $r('[module_base].color.theme_color') :
              this.folded ? $r('[module_base].color.white_f6') : Color.Transparent)
            .fontColor(this.selectTabIndex == index ?
              (this.folded ? Color.White : $r('[module_base].color.theme_color')) :
            $r('[module_base].color.txt_color'))

        }.onClick(() => {
          if (this.selectTabIndex != index) {
            this.classifyId = item.classifyId
            this.selectTabIndex = index ?? -1
            this.outsideListScroller.scrollEdge(Edge.Top);
            this.textScroller.scrollToIndex(index, false, ScrollAlign.CENTER);
            this.imageScroller.scrollToIndex(index, false, ScrollAlign.CENTER);
          } else {
            this.classifyId = ''
            this.selectTabIndex = -1
          }
          this.pageNo = 1
          this.searchCommodityList()
        })
      })
    }
    .height(35)
    .width('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .backgroundColor(Color.White)
    .listDirection(Axis.Horizontal)
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      this.imageScroller.scrollTo({
        //图片列表同步滚动
        yOffset: 0,
        animation: false,
        xOffset: this.textScroller.currentOffset().xOffset + offset
      })
      return { offsetRemain: offset }
    })
  }

  async searchCommodityList(): Promise<string> {
    return this.viewModel.querySearchList({
      pageNo: this.pageNo,
      keyword: this.keyword,
      pageSize: this.pageSize,
      classifyId: this.classifyId,
      searchType: this.searchType,
      priceSortType: this.priceSortType
    })
  }
}

