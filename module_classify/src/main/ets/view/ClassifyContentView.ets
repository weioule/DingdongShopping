import { PullToRefresh } from 'module_base/src/main/ets/refresh/MyPullToRefresh';
import { BaseDataSource } from 'module_base/src/main/ets/common/BaseDataSource';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { Classify, Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { ClassifyModel } from '../model/ClassifyModel';
import { FirstClassifyItem } from './FirstClassifyItem';
import { emitter } from '@kit.BasicServicesKit';
import { ClassifyCommodityItem } from './ClassifyCommodityItem';
import { PullToRefreshConfigurator } from 'module_base/src/main/ets/refresh/MyPullToRefreshConfigurator';
import { App } from '@kit.ArkUI';

/**
 * @author weioule
 * @date 2025-02-01
 * 分类页右侧内容列表组件
 */
@Component
export struct ClassifyContentView {
  private refreshConfigurator: PullToRefreshConfigurator = MyApp.Refresh.configurator();
  @State data: BaseDataSource<Classify> = new BaseDataSource<Classify>();
  private viewModel: ClassifyModel = new ClassifyModel();
  private rightListScroller: Scroller = new Scroller();
  private leftListScroller: Scroller = new Scroller();
  @State currentSecondClassifyIndex: number = 0;
  @Prop currentFirstClassifyIndex: number = 0;
  @Prop myFirstClassifyIndex: number = 0;
  @State firstClassifyList: Classify[] = [];
  @State noScroller: boolean = false;
  private isVisible: boolean = false
  @State hasAd: boolean = true
  @State state: number = 0;

  aboutToAppear(): void {
    App.setImageRawDataCacheSize(1024 * 1024 * 100); // 避免图片渲染闪缩使用缓存 解码前数据上限，单位为字节；约等于9.53M
    App.setImageCacheCount(100); // 设置内存中缓存解码后图片的数量上限
    this.refreshConfigurator?.setHasLoadMore(true)
    this.refreshConfigurator?.setTxtPullDownRefresh('下拉 至上一个分类')
    this.refreshConfigurator?.setTxtReleaseRefresh('释放 至上一个分类')
    this.refreshConfigurator?.setTxtPullUpLoad('上拉 至下一个分类')
    this.refreshConfigurator?.setTxtReleaseLoad('释放 至下一个分类')
  }

  build() {
    Row() {
      List({ scroller: this.leftListScroller }) {
        LazyForEach(this.data, (item: Classify, index: number) => {
          ListItem() {
            FirstClassifyItem({
              classify: item,
              index: index,
              currentIndex: this.currentSecondClassifyIndex,
              onClickAction: () => {
                if (this.currentSecondClassifyIndex !== index) {
                  this.currentSecondClassifyIndex = index
                  this.noScroller = true
                  this.rightListScroller.scrollToIndex(this.hasAd ? this.currentSecondClassifyIndex + 1 :
                  this.currentSecondClassifyIndex, false, ScrollAlign.START)
                }
              }
            })
          }
        })
      }
      .enableScrollInteraction(false)
      .alignListItem(ListItemAlign.Center)
      .edgeEffect(EdgeEffect.None)
      .backgroundColor('#f6f6f6')
      .scrollBar(BarState.Off)
      .height('100%')
      .width('25%')

      Column() {
        PullToRefresh({
          changeStateOutside: (state) => {
            this.state = state
          },
          refreshConfigurator: this.refreshConfigurator,
          scroller: this.rightListScroller,
          customList: () => {
            this.getListView();
          },
          onRefresh: () => {
            if (this.currentFirstClassifyIndex > 0) {
              emitter.emit('10001', { data: this.currentFirstClassifyIndex - 1 })
              return new Promise((resolve, reject) => {
                resolve('')
              })
            } else {
              return new Promise((resolve, reject) => {
                resolve('已经是第一个分类了')
              })
            }
          },
          onLoadMore: () => {
            if (this.currentFirstClassifyIndex < this.firstClassifyList.length - 1) {
              emitter.emit('10001', { data: this.currentFirstClassifyIndex + 1 })
              return new Promise((resolve, reject) => {
                resolve('')
              })
            } else {
              return new Promise((resolve, reject) => {
                resolve('已经是最后一个分类了')
              })
            }
          },
          customLoad: null,
          customRefresh: null,
        })
          .layoutWeight(1)
      }
      .width('75%')
      .height('100%')
      .padding({ left: 8 })
      .backgroundColor(Color.White)
    }
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && this.isVisible != true) {
        this.isVisible = true
        this.viewModel.getSecondClassify(this.firstClassifyList[this.myFirstClassifyIndex].classifyId).then(list => {
          if (null != list && list.length > 0 && 'useCache' != list) {
            if (this.data.getDataArray() === list) {
              return;
            }

            this.data.reloadData(list as [])
          }
        })
      }
      if (!isVisible && this.isVisible != false) {
        this.isVisible = false
      }
    })
  }

  @Builder
  private getListView() {
    List({ scroller: this.rightListScroller }) {
      if (this.hasAd) {
        ListItem() {
          Image($r("app.media.img_ad"))
            .height(80)
            .width('100%')
            .border({ radius: 10 })
            .objectFit(ImageFit.Auto)
            .backgroundColor(Color.White)
            .padding({ top: 5, right: 5 })
        }
      }

      LazyForEach(this.data, (secondClassify: Classify, index: number) => {
        ListItemGroup({ header: this.itemHead(secondClassify, index) }) {
          LazyForEach(this.getItemBaseDataSource(secondClassify.commodityList),
            (classifyCommodity: Commodity, i: number) => {
              ListItem() {
                ClassifyCommodityItem({
                  state: this.state,
                  commodity: classifyCommodity
                });
              }
            }, (classifyCommodity: Commodity) => JSON.stringify(classifyCommodity))
        }
        .divider({ strokeWidth: 1, color: $r('[module_base].color.bg_color') })

      }, (secondClassify: Classify) => JSON.stringify(secondClassify))
    }
    .onScrollIndex((firstIndex: number) => {
      if (this.noScroller) {
        //点击tab的时候不处理滚动
        this.noScroller = false
      } else {
        this.currentSecondClassifyIndex = Math.max(this.hasAd ? firstIndex - 1 : firstIndex, 0)
        this.leftListScroller.scrollToIndex(Math.max(this.hasAd ? firstIndex - 1 : firstIndex, 0))
      }
    })
    .width('100%')
    .height('100%')
    .cachedCount(1)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .alignListItem(ListItemAlign.Start)
    .sticky(StickyStyle.Header | StickyStyle.Footer) // 设置吸顶，实现粘性标题效果
  }

  @Builder
  itemHead(secondClassify: Classify, index: number) {
    Row() {
      Row() {
        Text(secondClassify.classifyName)
          .width('70%')
          .fontSize(12)
          .padding({ left: 8 })
          .fontColor($r('[module_base].color.txt_color_666'))

        Text('销量')
          .fontSize(12)
          .fontColor(secondClassify.sort == 1 ? $r('[module_base].color.theme_color') :
          $r('[module_base].color.txt_color_666'))
          .padding({
            left: 8,
            right: 8,
            top: 5,
            bottom: 4
          })
          .onClick(() => {
            if (secondClassify.sort != 1) {
              this.viewModel.sortBySalesVolume(this.data.getData(index))
              this.data.onDataRefresh(secondClassify, index)
            }
          })

        Text('价格')
          .fontSize(12)
          .padding({
            left: 8,
            top: 5,
            bottom: 4
          })
          .fontColor((secondClassify.sort == 2 || secondClassify.sort == 3) ?
          $r('[module_base].color.theme_color') :
          $r('[module_base].color.txt_color_666'))
          .onClick(() => {
            if (secondClassify.sort == 2) {
              this.viewModel.sortByPriceDown(this.data.getData(index))
              this.data.onDataRefresh(secondClassify, index)
            } else {
              this.viewModel.sortByPriceUp(this.data.getData(index))
              this.data.onDataRefresh(secondClassify, index)
            }
          })

        if (secondClassify.sort == 2) {
          this.sortBuilder($r("[module_base].media.ic_sort_up"))
        } else if (secondClassify.sort == 3) {
          this.sortBuilder($r("[module_base].media.ic_sort_down"))
        } else {
          this.sortBuilder($r("[module_base].media.ic_sort_def"))
        }
      }
      .height(25)
      .padding({ right: 5 })
      .borderRadius({ topLeft: 4, bottomLeft: 4 })
      .backgroundColor($r('[module_base].color.bg_color'))

    }
    .height(35)
    .width('100%')
    .margin({ top: -1 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  sortBuilder(img: Resource) {
    Image(img)
      .width(16)
      .height(24)
      .padding({ top: 7, bottom: 7, right: 6 })
  }

  getItemBaseDataSource(list: Commodity[]) {
    let bds = new BaseDataSource<Commodity>()
    bds.reloadData(list)
    return bds
  }
}