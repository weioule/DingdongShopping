import { router } from '@kit.ArkUI';
import { PARAMS } from './SearchListPage';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { AssociativeWordsBean } from '../bean/AssociativeWordsBean';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { AppRouter } from 'module_base/src/main/ets/common/AppRouter';
import { PopularSearchesPageModel } from '../model/PopularSearchesPageModel';
import PreferencesUtils, { PreferencesKey } from 'module_base/src/main/ets/utils/PreferencesUtils';

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
  @State placeholder: string = '';
  @State picUrl: Resource | null = null;
  @State searchHistoryList: string[] = [];
  @State popularSearchesList: PopularSearchesBean[] = []
  @State popularSearches: PopularSearchesBean | null = null
  @State AssociativeWordsList: AssociativeWordsBean[] | null = null
  @Provide viewModel: PopularSearchesPageModel = new PopularSearchesPageModel();

  aboutToAppear(): void {
    this.viewModel.rx_associativeWordsList.subscribe(list => {
      this.AssociativeWordsList = list
    })
    this.viewModel.rx_popularSearchesList.subscribe(list => {
      this.popularSearchesList = list
    })

    PreferencesUtils.get(PreferencesKey.searchRecordsLocallyKey, []).then(map => {
      this.searchHistoryList = map as string[]
    })

    this.viewModel.queryHotSearch()
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
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
              })
              .width('100%')
              .defaultFocus(true) //默认获取焦点
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
            .backgroundColor($r('[module_base].color.green_color'))

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
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        })

        RelativeContainer() {
          Image($r('app.media.ic_cart'))
            .width(24)
            .height(24)
            .id('iv_cart')
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            })
            .objectFit(ImageFit.Contain)

          Text((this.cartNum > 99) ? "99+" : `${this.cartNum}`)
            .fontSize(10)
            .minFontSize(8)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .backgroundColor($r('[module_base].color.red_color'))
            .constraintSize({ minWidth: 13 })
            .width('auto')
            .height(13)
            .padding({
              top: 1,
              bottom: 1,
              left: 2,
              right: 2
            })
            .margin({ left: -10 })
            .borderRadius(6)
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              left: { anchor: 'iv_cart', align: HorizontalAlign.End }
            })
            .visibility(this.cartNum > 0 ? Visibility.Visible : Visibility.None)
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
        Column() {
          Row() {
            Text('历史搜索')
              .fontSize(12)
              .margin({ left: 10, top: 15 })
              .fontColor($r('[module_base].color.txt_color_999'))

            Image($r("app.media.ic_delete_btn"))
              .width(28)
              .height(30)
              .objectFit(ImageFit.Contain)
              .margin({ right: 6 })
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
          .justifyContent(FlexAlign.SpaceBetween)
          .height('auto')
          .width('100%')
          .padding({ top: 5 })
          .visibility(this.searchHistoryList.length > 0 ? Visibility.Visible : Visibility.None)

          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            ForEach(this.searchHistoryList, (item: string, index?: number) => {
              Row() {
                Text(item)
                  .fontSize(12)
                  .fontColor($r('[module_base].color.txt_color_666'))
                  .borderRadius(3)
                  .height(26)
                  .padding({
                    left: 10,
                    right: 10,
                  })
                  .onClick(() => {
                    this.insertHistory(item)
                  })
                  .margin({ right: 8, top: 8 })
                  .backgroundColor($r('[module_base].color.white_f6'))
              }
            })
          }.padding({ left: 10, right: 10, bottom: 10 })

          Text('搜索发现')
            .fontColor($r('[module_base].color.txt_color_999'))
            .fontSize(12)
            .margin({ top: 20 })
            .padding({ left: 10, bottom: 5 })
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
              .backgroundColor($r('[module_base].color.white_f6'))
              .padding({
                left: 10,
                right: 10,
              })
              .onClick(() => {
                this.insertHistory(item.name)
              })
              .margin({ right: 8, top: 8 })
            })

          }.padding({ left: 10, right: 10 })
        }.alignItems(HorizontalAlign.Start)
        .width('100%')
        .height('100%')

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
              .textAlign(TextAlign.Start)
              .padding({ left: 16 })
              .border({ width: { bottom: 1 }, color: $r('[module_base].color.line_gray') })
            }
          })
        }.width('100%')
        .height('100%')
        .backgroundColor(Color.White)
        .visibility(this.keyword && this.AssociativeWordsList ? Visibility.Visible : Visibility.None)
      }

    }.padding({
      top: MyApp.Size.statusBar,
    })
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