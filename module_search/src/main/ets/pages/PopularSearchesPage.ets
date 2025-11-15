import { router } from '@kit.ArkUI';
import { PARAMS } from './SearchListPage';
import { LeaderboardBean } from '../bean/LeaderboardBean';
import { LeaderboardView } from '../view/LeaderboardView';
import { AssociativeWordsBean } from '../bean/AssociativeWordsBean';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';
import { PopularSearchesPageModel } from '../model/PopularSearchesPageModel';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import PreferencesUtils, { PreferencesKey } from 'module_base/src/main/ets/utils/PreferencesUtils';
import { StatusBarContentColor, StatusBarUtils } from 'module_base/src/main/ets/utils/StatusBarUtils';

/**
 * @author weioule
 * @date 2025-02-22
 */
@Entry
@Component
export struct PopularSearchesPage {
  private timeoutId: number = 0
  @State keyword: string = '';
  @State cartNum: number = 100
  @State scrollHeight: number = 0
  @State searchHistoryHeight: number = 0
  @State placeholder: string = '';
  @State picUrl: Resource | null = null;
  @State searchHistoryList: string[] = [];
  @State popularSearchesList: PopularSearchesBean[] = []
  @State leaderboardList: LeaderboardBean[] = []
  @State popularSearches: PopularSearchesBean | null = null
  @State AssociativeWordsList: AssociativeWordsBean[] | null = null
  @Provide viewModel: PopularSearchesPageModel = new PopularSearchesPageModel();

  aboutToAppear(): void {
    StatusBarUtils.setStatusBarTextColor(MyApp.AppUtil.context, StatusBarContentColor.BLACK);

    this.viewModel.rx_associativeWordsList.subscribe(list => {
      this.AssociativeWordsList = list
    })
    this.viewModel.rx_popularSearchesList.subscribe(list => {
      this.popularSearchesList = list
    })
    this.viewModel.rx_leaderboardList.subscribe(list => {
      this.leaderboardList = list
    })

    PreferencesUtils.get(PreferencesKey.searchRecordsLocallyKey, []).then(map => {
      this.searchHistoryList = map as string[]
    })

    this.viewModel.queryHotSearch()
    this.viewModel.queryLeaderboardList()
  }

  aboutToDisappear(): void {
    if (this.searchHistoryList.length > 0) {
      PreferencesUtils.save(PreferencesKey.searchRecordsLocallyKey, this.searchHistoryList)
    }
  }

  onPageShow(): void {
    if (router.getParams()) {
      this.keyword = (router.getParams() as PARAMS).keyword ?? ''
      this.popularSearches = (router.getParams() as PARAMS).popularSearches ?? null
      if (this.popularSearches != null) {
        if (this.popularSearches.picUrl != null) {
          this.placeholder = '      ' + this.popularSearches.name
          this.picUrl = this.popularSearches.picUrl
        } else {
          this.placeholder = this.popularSearches.name
        }
      } else {
        this.placeholder = '      周二会员日|爆品真5折！'
        this.picUrl = $r('app.media.ic_flame')
      }
    } else {
      this.keyword = ''
      this.AssociativeWordsList = null
    }
  }

  private startTimer() {
    clearTimeout(this.timeoutId)
    this.timeoutId = setTimeout(() => {
      this.queryAssociativeWords(this.keyword)
    }, 200)
  }

  build() {
    Column() {
      RelativeContainer() {
        Image($r('app.media.ic_back'))
          .width(40)
          .height(44)
          .id('iv_back')
          .objectFit(ImageFit.Cover)
          .padding({
            top: 11,
            bottom: 11,
            left: 13,
            right: 13
          })
          .onClick(() => {
            if (this.keyword.length > 0) {
              this.keyword = ''
              this.AssociativeWordsList = null
            } else {
              router.back()
            }
          })
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          })

        Row() {
          Image($r('app.media.ic_search'))
            .width(20)
            .height(20)
            .margin({
              left: 8, right: 3
            })

          RelativeContainer() {
            Image(this.picUrl)
              .size({ width: 20, height: 20 })
              .visibility(this.keyword.length > 0 ? Visibility.None : Visibility.Visible)
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
              })

            TextInput({
              text: this.keyword,
              placeholder: this.placeholder
            })
              .fontSize(13)
              .width('100%')
              .height('100%')
              .borderRadius(0)
              .placeholderFont({ size: 13 })
              .enterKeyType(EnterKeyType.Search)
              .backgroundColor(Color.Transparent)
              .fontColor($r('[module_base].color.txt_color'))
              .placeholderColor($r('[module_base].color.txt_color_666'))
              .padding({
                left: 0,
                top: 2,
                right: 0,
                bottom: 0
              })//0=去除左右内边距，默认有值
              .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
                if (enterKey == EnterKeyType.Search) {
                  this.insertHistory(this.keyword)
                }
              })
              .onChange((value) => {
                this.keyword = value
                if (this.keyword.length == 0) {
                  this.AssociativeWordsList = null
                }

                if (!this.popularSearches) {
                  this.startTimer()
                }
              })
              .width('100%')
              .defaultFocus(true)//默认获取焦点
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
              })
          }
          .layoutWeight(1)

          Image($r('app.media.ic_delete'))
            .width(25)
            .height(25)
            .padding(5)
            .visibility(null == this.keyword || this.keyword.length == 0 ? Visibility.None : Visibility.Visible)
            .onClick(() => {
              this.keyword = ''
              this.AssociativeWordsList = null
            })

          Line()
            .width(1)
            .height(17)
            .backgroundColor($r('[module_base].color.theme_color'))

          Text('搜索')
            .fontSize(13)
            .width('auto')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
            .margin({ left: 10, right: 10 })
            .fontColor($r('[module_base].color.theme_color'))
            .onClick(() => {
              this.insertHistory(this.keyword || this.placeholder || '')
            })
        }
        .height(32)
        .layoutWeight(1)
        .borderRadius(22)
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('[module_base].color.white_f6'))
        .alignRules({
          left: { anchor: 'iv_back', align: HorizontalAlign.End },
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: 'rc_cart', align: HorizontalAlign.Start },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })

        RelativeContainer() {
          Image($r('app.media.ic_cart'))
            .width(24)
            .height(24)
            .id('iv_cart')
            .objectFit(ImageFit.Contain)
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
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
              left: { anchor: 'iv_cart', align: HorizontalAlign.End }
            })
        }
        .width(50)
        .height(30)
        .id('rc_cart')
        .padding({ left: 10 })
        .onClick(async () => {
          AppRouter.toCartPage();
        })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        })
      }
      .height(42)
      .width('100%')

      RelativeContainer() {
        Scroll() {
          Column() {
            Row() {
              Text('历史搜索')
                .fontSize(12)
                .height(30)
                .margin({ left: 10, top: 10 })
                .align(Alignment.Center)
                .fontColor($r('[module_base].color.txt_color_999'))
                .alignSelf(ItemAlign.Center)

              Image($r("app.media.ic_delete_btn"))
                .width(28)
                .height(30)
                .margin({ right: 6, top: 10 })
                .objectFit(ImageFit.Contain)
                .padding({
                  top: 8,
                  bottom: 8,
                  left: 4,
                  right: 4
                })
                .onClick(() => {
                  this.searchHistoryList = []
                  PreferencesUtils.save(PreferencesKey.searchRecordsLocallyKey, this.searchHistoryList)
                })
            }
            .width('100%')
            .height(50)
            .padding({ top: 5, bottom: 5 })
            .justifyContent(FlexAlign.SpaceBetween)
            .visibility(this.searchHistoryList.length > 0 ? Visibility.Visible : Visibility.None)

            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              ForEach(this.searchHistoryList, (item: string, index?: number) => {
                Row() {
                  Text(item)
                    .height(26)
                    .fontSize(12)
                    .borderRadius(3)
                    .margin({ right: 8, bottom: 8 })
                    .fontColor($r('[module_base].color.txt_color_666'))
                    .backgroundColor($r('[module_base].color.white_f6'))
                    .padding({
                      left: 10,
                      right: 10,
                    })
                    .onClick(() => {
                      this.insertHistory(item)
                    })
                }
              })
            }.padding({ left: 10, right: 10 })
            .onAreaChange((oldValue, newValue) => {
              if (this.searchHistoryHeight != newValue.height as number) {
                this.scrollHeight = this.scrollHeight - (oldValue.height as number) + (newValue.height as number) +
                this.searchHistoryHeight == 0 ? 50 : 0 //历史搜索文案Row的高度
                this.searchHistoryHeight = newValue.height as number
              }
            })

            Text('搜索发现')
              .fontColor($r('[module_base].color.txt_color_999'))
              .fontSize(12)
              .margin({ top: 20 })
              .padding({ left: 10, bottom: 15 })
              .visibility(this.popularSearchesList.length > 0 ? Visibility.Visible : Visibility.None)

            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              ForEach(this.popularSearchesList, (item: PopularSearchesBean, index?: number) => {
                Row() {
                  Image($r("app.media.ic_fire"))
                    .width(15)
                    .height(15)
                    .margin({ right: 3, bottom: 3 })
                    .visibility(item.isHot ? Visibility.Visible : Visibility.None)

                  Text(item.name)
                    .fontSize(12)
                    .fontColor($r('[module_base].color.txt_color_666'))
                }
                .height(26)
                .borderRadius(3)
                .margin({ right: 8, bottom: 8 })
                .backgroundColor($r('[module_base].color.white_f6'))
                .padding({
                  left: 10,
                  right: 10,
                })
                .onClick(() => {
                  this.insertHistory(item.name)
                })
              })

            }
            .padding({ left: 10, right: 10 })

            Swiper() {
              ForEach(this.leaderboardList, (item: LeaderboardBean, index: number) => {
                LeaderboardView({ data: item, index: index })
              })
            }
            .height('auto')
            .padding({ left: 10, top: 20, right: 10 })
            .indicator(false) // 可选：显示指示器
            .itemSpace(10) // 设置项与项之间的间隔为10vp
            .linearGradient({
              colors: [
                ['#ffffff', 0.0],
                ['#f0f0f0', 0.15],
                ['#f0f0f0', 1.0],
              ]
            })

            Blank().height(100).backgroundColor('#f0f0f0')

          }.width('100%')
          .alignItems(HorizontalAlign.Start)
          .height(this.scrollHeight > 0 ? this.scrollHeight : 'auto')
          .onAreaChange((oldValue, newValue) => {
            if (this.scrollHeight != newValue.height) {
              // 动态设置Scroll高度（不超过屏幕剩余空间）
              this.scrollHeight = (newValue.height as number)
            }
          })
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
        .height(this.scrollHeight > 0 ? this.scrollHeight : 1000)

        List() {
          ForEach(this.AssociativeWordsList, (item: AssociativeWordsBean, index?: number) => {
            ListItem() {
              Text(item.name) {
                ForEach(item.highlightList, (str: string, index) => {
                  if (str == item.highlight) {
                    Span(str).fontColor($r('[module_base].color.theme_color')).fontSize(14)
                  } else {
                    Span(str).fontColor($r('[module_base].color.txt_color')).fontSize(14)
                  }
                })
              }
              .height(40)
              .onClick(() => {
                this.insertHistory(item.name)
              })
              .width('100%')
              .padding({ left: 16 })
              .textAlign(TextAlign.Start)
              .border({ width: { bottom: 1 }, color: $r('[module_base].color.line_gray') })
            }
          })

        }.width('100%')
        .height('100%')
        .backgroundColor(Color.White)
        .visibility(this.keyword && this.AssociativeWordsList ? Visibility.Visible : Visibility.None)
      }

    }.padding({ top: MyApp.Size.statusBar })
    .backgroundColor(Color.White)
  }

  private queryAssociativeWords(searchKey: string) {
    if (null != searchKey && searchKey.length > 0) {
      this.viewModel.queryAssociativeWords(searchKey)
    }
  }

  private insertHistory(searchKey: string) {
    if (searchKey == null || searchKey.length == 0) {
      ToastUtil.show("请输入搜索内容")
      return
    }

    //删除添加的空格
    searchKey = searchKey.trim()

    if (this.searchHistoryList.includes(searchKey)) {
      this.searchHistoryList.splice(this.searchHistoryList.indexOf(searchKey), 1)
    }

    this.searchHistoryList.unshift(searchKey)

    this.AssociativeWordsList = null

    AppRouter.toSearchListPage(searchKey)
  }
}