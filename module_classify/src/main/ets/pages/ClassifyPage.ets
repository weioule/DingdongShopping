import { Classify } from 'module_base/src/main/ets/bean/ClassifyBean';
import { SearchInput } from '../view/SearchInput';
import { emitter, systemDateTime } from '@kit.BasicServicesKit';
import { ClassifyModel } from '../model/ClassifyModel';
import { ClassifyContentView } from '../view/ClassifyContentView';
import { StateLayout, StateType } from 'module_base/src/main/ets/view/Statelayout';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';

/**
 * @author weioule
 * @date 2025-02-01
 *  分类页
 */
@Entry
@Component
export struct ClassifyPage {
  private classifyRefreshTime: number = 0
  private listScroller: Scroller = new Scroller();
  private viewModel: ClassifyModel = new ClassifyModel();
  private controller: TabsController = new TabsController()

  @State gridHeight: number = 0
  @State isOpen: boolean = false
  @State firstInit: boolean = true
  @State moveGridHeight: number = 0
  @State gridColumnCount: string = ''
  @State currentFirstClassifyId: string = '';
  @State currentFirstClassifyIndex: number = 0;
  @Prop @Watch('customShow') classifyShow: boolean
  @State popularSearches: PopularSearchesBean[] = []
  @State firstClassify: Array<Classify> = new Array;
  @State firstStateLayout: StateType = StateType.normal

  refreshGridHeight() {
    if (this.firstClassify?.length > 0) {
      let totalCount = this.firstClassify.length
      //计算满格行数，要向下取整
      let columnCount = Math.floor(totalCount / 6)
      if (totalCount % 6 == 0) {
        //计算grid高度，把分割线一起算上，分割线=10
        this.gridHeight = 75 * columnCount + 5 * (columnCount - 1)
      } else {
        //多出并且不满一行的，多加一行
        this.gridHeight = 75 * (columnCount + 1) + 5 * (columnCount)
      }

      this.gridColumnCount = ''
      for (let i = 0; i < (totalCount % 6 == 0 ? columnCount : (columnCount + 1)); i++) {
        if (i > 0) {
          this.gridColumnCount += ' '
        }
        //计算行数
        this.gridColumnCount += '1fr'
      }
    }
  }

  aboutToAppear(): void {
    this.customShow()
    emitter.on('10001', (eventData: emitter.GenericEventData<number>) => {
      //上下拉刷新切换tab
      this.controller.changeIndex(eventData.data)
    })
  }

  customShow() {
    //当前页面可见
    if (this.classifyShow) {
      if (this.classifyRefreshTime == 0 ||
        systemDateTime.getTime() - 300000 >= this.classifyRefreshTime) {
        // 更新时间超过5分钟，拉取新数据
        this.getData()
      }
    }
  }

  getData() {
    this.viewModel.getFirstClassify().then((list: Classify[]) => {
      if (list != null && list.length > 0) {
        this.classifyRefreshTime = systemDateTime.getTime()

        this.firstStateLayout = StateType.normal
        if (this.firstClassify === list) {
          return;
        }

        if (null == this.currentFirstClassifyId || this.currentFirstClassifyId.length == 0) {
          this.currentFirstClassifyIndex = 0
          this.currentFirstClassifyId = list[this.currentFirstClassifyIndex].classifyId ?? ''
        } else {
          for (let i = 0; i < list.length; i++) {
            if (this.currentFirstClassifyId == list[i].classifyId) {
              this.currentFirstClassifyIndex = i
              break
            }
          }
        }

        this.firstClassify = list
      } else if (this.firstClassify.length == 0) {
        //都没有数据则展示成错误页面
        this.firstStateLayout = StateType.empty
      }

      //计算grid的高度
      this.refreshGridHeight()

      if (this.firstInit) {
        this.firstInit = false
        setTimeout(() => {
          this.openDialog()
        }, 400)
      }
    }).catch((e: string) => {
      this.firstStateLayout = StateType.error
    })

    this.viewModel.getPopularSearches().then((list: PopularSearchesBean[]) => {
      this.popularSearches = list
    })
  }

  build() {
    RelativeContainer() {
      Column() {
        SearchInput({ popularSearches: this.popularSearches })
      }
      .width('100%')
      .id('search_input')
      .height(45 + MyApp.Size.statusBar)
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        angle: 90,
        colors: [
          ['#e6ffe6', 0.0],
          ['#ffe6fe', 1.0],
        ]
      })
      .padding({
        left: 16,
        right: 16,
        top: MyApp.Size.statusBar,
      })

      RelativeContainer() {
        Row() {
          List({ initialIndex: this.currentFirstClassifyIndex, scroller: this.listScroller }) {
            ForEach(this.firstClassify, (item: Classify, index: number) => {
              this.tabBuilder(index, item)
            }, (item: Classify, index: number) => JSON.stringify(item) + index)
          }
          .height(85)
          .friction(0.6)
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)

          Row() {
            Image($r("app.media.ic_white_shade"))
              .width(1)
              .height(70)

            Column() {
              Text('全部')
                .fontColor($r('[module_base].color.theme_color'))
                .fontSize(12)
                .width('100%')
                .textAlign(TextAlign.Center)

              Image($r('app.media.ic_unfold'))
                .width(18)
                .height(18)
                .margin({ top: 3 })
            }.layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          }.height(70)
          .width(35)
          .onClick(() => {
            this.openDialog();
          })
        }
        .height(85)
        .id('tabs')
        .width('100%')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
        })
        .linearGradient({
          angle: 90,
          colors: [
            ['#e6ffe6', 0.0],
            ['#ffe6fe', 1.0],
          ]
        })

        Tabs({ index: this.currentFirstClassifyIndex, controller: this.controller }) {
          ForEach(this.firstClassify, (item: Classify, index: number) => {
            TabContent() {
              ClassifyContentView({
                myFirstClassifyIndex: index,
                firstClassifyList: this.firstClassify,
                currentFirstClassifyIndex: this.currentFirstClassifyIndex,
              })
            }
          }, (item: Classify, index: number) => JSON.stringify(item))
        }
        .onAnimationStart((index: number, targetIndex: number) => {
          this.listScroller.scrollToIndex(targetIndex, true, ScrollAlign.CENTER);
        })
        .barHeight(0)
        .width('100%')
        .layoutWeight(1)
        .vertical(false)
        .scrollable(true)
        .barMode(BarMode.Scrollable)
        .onChange((index: number) => {
          this.currentFirstClassifyIndex = index
          this.listScroller.scrollToIndex(index, true, ScrollAlign.CENTER);
        })
        .alignRules({
          top: { anchor: 'tabs', align: VerticalAlign.Bottom },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })

        StateLayout({
          stateType: this.firstStateLayout, clickRetry: () => {
            this.getData()
          }
        }).visibility(this.firstStateLayout != StateType.normal ? Visibility.Visible : Visibility.None)
          .width('100%')
          .height('100%')

        //一级分类下拉弹框展示
        Column() {
          Column() {
            Column() {
              Text('全部分类')
                .width('100%')
                .fontSize(12)
                .fontColor($r('[module_base].color.txt_color'))
                .padding({ left: 15, top: 5 })
            }
            .height(20)

            Grid() {
              ForEach(this.firstClassify, (item: Classify, index: number) => {
                GridItem() {
                  this.tabBuilder(index, item, () => {
                    //关闭弹框不要动画
                    this.moveGridHeight = 0
                    this.isOpen = false
                  })
                }
              })
            }
            .width('100%')
            .height(this.gridHeight)
            .padding({ left: 5, right: 5 })
            .rowsTemplate(this.gridColumnCount)
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')

            Row() {
              Text('点击收起')
                .fontSize(12)
                .fontColor($r('[module_base].color.txt_color_666'))

              Image($r("app.media.ic_top_arrows"))
                .width(15)
                .margin({ left: 5 })
                .height(this.moveGridHeight >= this.gridHeight + 60 ? 10 : 0)
            }
            .height(40)
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.closeDialog()
            })
          }
          .clip(true)
          .width('100%')
          .height(this.moveGridHeight)
          .justifyContent(FlexAlign.Start)
          .border({ radius: { bottomLeft: 10, bottomRight: 10 } })
          //点击列表空白地方不关闭弹框
          .onClick(() => {
          })
          .linearGradient({
            angle: 90,
            colors: [
              ['#e6ffe6', 0.0],
              ['#ffe6fe', 1.0],
            ]
          })

        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .height(this.isOpen ? '100%' : 0)
        .backgroundColor(this.moveGridHeight >= this.gridHeight + 60 ? '#3000' : '#0000')
        .onClick(() => {
          this.closeDialog()
        })
      }
      .layoutWeight(1)
      .alignRules({
        top: { anchor: 'search_input', align: VerticalAlign.Bottom },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })

    }.onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, _currentRatio: number) => {
      if (!isVisible) {
        //页面不可见关闭弹框
        this.moveGridHeight = 0
        this.isOpen = false
      }
    })
  }

  //使用动画实现下拉弹框
  private openDialog() {
    this.isOpen = true
    animateTo({
      duration: 300,
      curve: Curve.EaseIn,
    }, () => {
      //打开，目标高度为整个弹框的高度，60=‘全部分类’+‘点击收起’的高度
      this.moveGridHeight = this.gridHeight + 60
    });
  }

  private closeDialog() {
    this.isOpen = false
    animateTo({
      duration: 300,
      curve: Curve.EaseInOut,
    }, () => {
      this.moveGridHeight = 0
    });
  }

  @Builder
  tabBuilder(index: number, item: Classify, onClick?: () => void) {
    Column() {
      Image(item.classifyPic)
        .width(this.currentFirstClassifyIndex == index ? 45 : 40)
        .height(this.currentFirstClassifyIndex == index ? 45 : 40)
        .margin({ left: 10, right: 10 })
        .border({
          width: 2,
          radius: this.currentFirstClassifyIndex == index ? 18 : 16,
          color: this.currentFirstClassifyIndex == index ? $r('[module_base].color.theme_color') : Color.White
        })

      Text(item.classifyName?.substring(0,
        item.classifyName.length > 5 ? 6 : item.classifyName.length) ?? '')
        .height(15)
        .width('auto')
        .margin({ top: 5 })
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)
        .fontSize(this.currentFirstClassifyIndex == index ? 11 : 10)
        .padding({
          left: 3,
          top: 1,
          right: 3
        })
        .backgroundColor(this.currentFirstClassifyIndex == index ? $r("[module_base].color.theme_color") :
        Color.Transparent)
        .fontColor(this.currentFirstClassifyIndex == index ? Color.White : $r('[module_base].color.txt_color'))
        .borderRadius(20)
    }
    .height(70)
    .width('auto')
    .margin({ top: 5 })
    .justifyContent(FlexAlign.End)
    .onClick(() => {
      if (this.currentFirstClassifyIndex != index) {
        this.controller.changeIndex(index);
        this.currentFirstClassifyId = item.classifyId ?? ''
      }

      if (onClick) {
        onClick()
      }
    })
  }
}






