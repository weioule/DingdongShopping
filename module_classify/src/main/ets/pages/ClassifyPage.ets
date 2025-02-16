import { Classify } from '../bean/ClassifyBean';
import { SearchInput } from '../view/SearchInput';
import { emitter, systemDateTime } from '@kit.BasicServicesKit';
import { ClassifyModel } from '../model/ClassifyModel';
import { ClassifyContentView } from '../view/ClassifyContentView';
import { StateLayout, StateType } from 'module_base/src/main/ets/view/Statelayout';
import { MyApp } from 'module_base/src/main/ets/common/Application';

/**
 * @author weioule
 * @date 2025-02-01
 *  分类页
 */
@Entry
@Component
export struct ClassifyPage {
  private viewModel: ClassifyModel = new ClassifyModel();
  @State firstClassify: Array<Classify> = new Array;
  private controller: TabsController = new TabsController()
  private listScroller: Scroller = new Scroller();
  @State currentFirstClassifyIndex: number = 0;
  @State currentFirstClassifyId: string = '';
  @State firstStateLayout: StateType = StateType.normal
  @Prop @Watch('customShow') classifyShow: boolean
  private classifyRefreshTime: number = 0
  @State gridHeight: number = 0
  @State moveGridHeight: number = 0
  @State gridColumnCount: string = ''
  @State isOpen: boolean = false
  @State firstInit: boolean = true

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
        setTimeout(()=>{
          this.openDialog()
        },400)
      }
    }).catch((e: string) => {
      this.firstStateLayout = StateType.error
    })
  }

  build() {
    RelativeContainer() {
      Column() {
        SearchInput()
      }
      .width('100%')
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
      .id('search_input')

      RelativeContainer() {
        Row() {
          List({ initialIndex: this.currentFirstClassifyIndex, scroller: this.listScroller }) {
            ForEach(this.firstClassify, (item: Classify, index: number) => {
              this.tabBuilder(index, item)
            }, (item: Classify, index: number) => JSON.stringify(item) + index)
          }
          .height(85)
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
          .friction(0.6)
          .layoutWeight(1)

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
                .margin({ top: 3 })
                .width(18)
                .height(18)
            }.layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          }.height(70)
          .width(35)
          .onClick(() => {
            this.openDialog();
          })
        }
        .height(85)
        .width('100%')
        .id('tabs')
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
        .vertical(false)
        .scrollable(true)
        .barMode(BarMode.Scrollable)
        .barHeight(0)
        .onChange((index: number) => {
          this.currentFirstClassifyIndex = index
          this.listScroller.scrollToIndex(index, true, ScrollAlign.CENTER);
        })
        .width('100%')
        .layoutWeight(1)
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
                .padding({ left: 15 })
            }
            .clip(true)
            .height(15)

            Grid() {
              ForEach(this.firstClassify, (item: Classify, index: number) => {
                GridItem() {
                  Column() {
                    Image(item.classifyPic)
                      .width(44)
                      .height(44)
                      .padding(1)
                      .alt($r("[module_base].media.ic_default"))
                      .margin({ left: 11, right: 11 })
                      .border({
                        radius: 100,
                        color: this.currentFirstClassifyIndex == index ? $r('[module_base].color.theme_color') :
                          0xffE5E5E5,
                        width: this.currentFirstClassifyIndex == index ? 1 : 0
                      })

                    Text(item.classifyName?.substring(0,
                      item.classifyName.length > 5 ? 6 : item.classifyName.length) ?? '')
                      .width('auto')
                      .height(20)
                      .fontSize(11)
                      .margin({ top: 5, bottom: 10 })
                      .padding({
                        left: 5,
                        top: 2,
                        right: 5,
                        bottom: 2
                      })
                      .backgroundColor(this.currentFirstClassifyIndex == index ? $r('[module_base].color.theme_color') :
                      Color.Transparent)
                      .fontColor(this.currentFirstClassifyIndex == index ? Color.White :
                      $r('[module_base].color.txt_color'))
                      .borderRadius(20)
                  }
                  .padding({ top: 5 })
                  .onClick(() => {
                    if (this.currentFirstClassifyIndex != index) {
                      this.controller.changeIndex(index)
                      this.currentFirstClassifyId = item.classifyId ?? ''
                    }
                    //关闭弹框不要动画
                    this.moveGridHeight = 0
                    this.isOpen = false
                  })
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
            .rowsTemplate(this.gridColumnCount)
            .height(this.gridHeight)
            .width('100%')
            .padding({ left: 5, right: 5 })

            Row() {
              Text('点击收起')
                .fontSize(12)
                .fontColor($r('[module_base].color.txt_color_666'))

              Image($r('app.media.iv_top_arrows'))
                .width(15)
                .margin({ left: 5 })
                .height(this.moveGridHeight >= this.gridHeight + 60 ? 10 : 0)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height(40)
            .onClick(() => {
              this.closeDialog()
            })
          }
          .justifyContent(FlexAlign.Start)
          .clip(true)
          .width('100%')
          .height(this.moveGridHeight)
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
        .justifyContent(FlexAlign.Start)
        .width('100%')
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
  tabBuilder(index: number, item: Classify) {
    Column() {
      Image(item.classifyPic)
        .width(44)
        .height(44)
        .padding(1)
        .margin({ left: 11, right: 11 })
        .border({
          radius: 100,
          color: this.currentFirstClassifyIndex == index ? $r('[module_base].color.theme_color') : 0xffE5E5E5,
          width: this.currentFirstClassifyIndex == index ? 1 : 0
        })

      Text(item.classifyName?.substring(0,
        item.classifyName.length > 5 ? 6 : item.classifyName.length) ?? '')
        .width('auto')
        .height(20)
        .fontSize(11)
        .margin({ top: 5, bottom: 10 })
        .padding({
          left: 5,
          top: 2,
          right: 5,
          bottom: 2
        })
        .backgroundColor(this.currentFirstClassifyIndex == index ? $r("[module_base].color.theme_color") :
        Color.Transparent)
        .fontColor(this.currentFirstClassifyIndex == index ? Color.White : $r('[module_base].color.txt_color'))
        .borderRadius(20)
    }.width('auto')
    .height('auto')
    .padding({ top: 5 })
    .onClick(() => {
      if (this.currentFirstClassifyIndex != index) {
        this.controller.changeIndex(index);
        this.currentFirstClassifyId = item.classifyId ?? ''
      }
    })
  }
}






