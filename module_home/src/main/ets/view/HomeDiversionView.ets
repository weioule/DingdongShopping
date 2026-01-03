import { RefreshState } from 'module_base/src/main/ets/refresh/MyPullToRefresh';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';

/**
 * 这个模块的效果感觉叮咚买菜（ios端）应该是使用gif图片实现的，移动端实现比较繁琐一点
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
  @State diversion: Commodity[][] = [] //图标列表
  @State currentIndexArray: number[] = [] //Swiper当前角标
  @State imageOpacityArray: number[] = [] // 每个图片的透明度

  aboutToAppear(): void {
    //初始化数组
    this.currentIndexArray = new Array(this.diversion.length).fill(0)
    this.imageOpacityArray = new Array(this.diversion.length).fill(1)
  }

  build() {
    Row() {
      WaterFlow() {
        ForEach(this.diversion, (commodity: Commodity[], index) => {
          FlowItem() {
            RelativeContainer() {
              Image(commodity[this.currentIndexArray[index]%commodity.length].commodityPic)
                .height('100%')
                .borderRadius(10)
                .objectFit(ImageFit.Cover)
                .opacity(this.imageOpacityArray[index])
                .width((MyApp.Size.screenWidth - 30) / 2)
                .alignRules({
                  right: { anchor: '__container__', align: HorizontalAlign.End },
                  top: { anchor: '__container__', align: VerticalAlign.Top }
                })

              //discountTag下一层背景,与蒙层一致
              Text()
                .height(20)
                .borderRadius({ topLeft: 10 })
                .width((MyApp.Size.screenWidth - 30) / 2 / 2)
                .linearGradient({
                  angle: 90,
                  colors: this.gradientColors(commodity[this.currentIndexArray[index]%commodity.length].maskColor)
                })
                .alignRules({
                  left: { anchor: '__container__', align: HorizontalAlign.Start },
                  top: { anchor: '__container__', align: VerticalAlign.Top }
                })

              Text(commodity[this.currentIndexArray[index]%commodity.length].discountTag)
                .height(20)
                .fontSize(14)
                .id('discountTag')
                .fontColor('#a23915')
                .backgroundColor('#fde193')
                .fontWeight(FontWeight.Bold)
                .borderRadius({ topRight: 10, bottomRight: 10 })
                .padding({
                  left: 5,
                  top: 2,
                  right: 5,
                  bottom: 2
                })
                .alignRules({
                  left: { anchor: '__container__', align: HorizontalAlign.Start },
                  top: { anchor: '__container__', align: VerticalAlign.Top }
                })

              //与下方Text组合实现圆角效果
              Text()
                .width(10)
                .height(10)
                .backgroundColor('#fde193')
                .alignRules({
                  left: { anchor: '__container__', align: HorizontalAlign.Start },
                  top: { anchor: 'discountTag', align: VerticalAlign.Bottom }
                })

              //蒙层
              Text()
                .borderRadius(10)
                .height('calc(100% - 20vp)')
                .width((MyApp.Size.screenWidth - 30) / 2 / 2)
                .linearGradient({
                  angle: 90,
                  colors: this.gradientColors(commodity[this.currentIndexArray[index]%commodity.length].maskColor)
                })
                .alignRules({
                  left: { anchor: '__container__', align: HorizontalAlign.Start },
                  top: { anchor: 'discountTag', align: VerticalAlign.Bottom }
                })

              Swiper() {
                ForEach(commodity, (item: Commodity, i: number) => {
                  Text() {
                    Span(index == 0 ? '特价' : '第二件')
                      .fontSize(20)
                      .fontColor(Color.White)

                    Span('¥')
                      .fontSize(12)
                      .fontColor(Color.White)

                    Span(item.price.toString().split('.')[0] + '.')
                      .fontSize(20)
                      .fontColor(Color.White)

                    Span(item.price.toString().split('.')[1])
                      .fontSize(12)
                      .fontColor(Color.White)
                  }
                  .height(20)
                  .width('100%')
                  .fontWeight(FontWeight.Bold)
                })
              }
              .loop(true)
              .id('price')
              .width('auto')
              .autoPlay(true)
              .interval(3000)
              .vertical(true)
              .indicator(false)
              .background('#feebb0')
              .margin({ left: 5, top: 10 })
              .borderRadius({ topLeft: 10 })
              .disableSwipe(true) //禁止手动滑动
              // 监听滚动动画开始
              .onAnimationStart(() => {
                this.transitionTo(index)
              })
              .alignRules({
                left: { anchor: '__container__', align: HorizontalAlign.Start },
                top: { anchor: 'discountTag', align: VerticalAlign.Bottom }
              })

              Text(commodity[this.currentIndexArray[index]%commodity.length].commoditySubName)
                .fontSize(12)
                .id('commoditySubName')
                .fontColor(Color.White)
                .margin({ left: 5, top: 8 })
                .fontWeight(FontWeight.Bold)
                .backgroundColor('#55' +
                commodity[this.currentIndexArray[index]%commodity.length].maskColor.substring(1))
                .padding({
                  left: 5,
                  top: 2,
                  right: 5,
                  bottom: 2
                })
                .border({ width: 1, color: Color.White, radius: 10 })
                .alignRules({
                  left: { anchor: '__container__', align: HorizontalAlign.Start },
                  top: { anchor: 'price', align: VerticalAlign.Bottom }
                })

              Image($r('[module_base].media.ic_next_white'))
                .width(22)
                .height(22)
                .padding(4)
                .borderRadius(50)
                .backgroundColor(commodity[this.currentIndexArray[index]%commodity.length].maskColor)
                .alignRules({
                  left: { anchor: 'commoditySubName', align: HorizontalAlign.End },
                  top: { anchor: 'commoditySubName', align: VerticalAlign.Top },
                  bottom: { anchor: 'commoditySubName', align: VerticalAlign.Bottom }
                })

              Text(commodity[this.currentIndexArray[index]%commodity.length].commodityName)
                .padding(3)
                .fontSize(10)
                .borderRadius(10)
                .fontColor(Color.White)
                .backgroundColor('#5000')
                .fontWeight(FontWeight.Bold)
                .margin({ right: 5, bottom: 3 })
                .alignRules({
                  right: { anchor: '__container__', align: HorizontalAlign.End },
                  bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
                })
            }
            .height(100)
            .borderRadius(10)
            .width((MyApp.Size.screenWidth - 30) / 2)
            .onClick(() => {
              ToastUtil.show(commodity[this.currentIndexArray[index]%commodity.length].commodityName)
            })
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
      .enableScrollInteraction(false)

    }
    .padding(10)
    .backgroundColor(Color.White)
    .height(Math.ceil((this.diversion?.length ?? 0) / 2) * 100+
    10 * (Math.ceil((this.diversion?.length ?? 0) / 2)+1)) //指定精确高度，因外部容器是RelativeContainer，避免渲染时因计算误差出现缝隙
  }

  /**
   * 切换图片（0 → 0.5 → 1 透明度过渡效果）
   */
  public transitionTo(index: number) {
    // 如果已经在过渡中，跳过
    if (this.imageOpacityArray[index] !== 1) {
      return
    }

    // 三步过渡法
    this.performThreeStepTransition(index)
  }

  /**
   * 执行三步过渡：1 → 0.5 → 1
   */
  private async performThreeStepTransition(index: number) {
    const group = this.diversion[index]
    if (!group || group.length === 0) {
      return
    }

    // 步骤1：1 → 0.5（变半透明）
    await this.animateOpacity(index, 0.5, 200, Curve.EaseOut)

    // 步骤2：切换图片索引
    this.currentIndexArray[index] = (this.currentIndexArray[index] + 1) % group.length

    // 步骤3：0.5 → 1（恢复不透明）
    await this.animateOpacity(index, 1, 200, Curve.EaseIn)
  }

  /**
   * 执行透明度动画
   */
  private animateOpacity(
    index: number,
    target: number,
    duration: number,
    curve: Curve
  ): Promise<void> {
    return new Promise((resolve) => {
      animateTo({
        duration: duration,
        curve: curve
      }, () => {
        this.imageOpacityArray[index] = target
      })

      // 等待动画完成
      setTimeout(resolve, duration)
    })
  }

  // 计算渐变颜色数组
  private gradientColors(color: string): Array<[ResourceColor, number]> {
    color = color.substring(1) // 去掉#号
    return [
      [`#${color}`, 0.1],
      [`#99${color}`, 0.5],
      [`#55${color}`, 0.9],
      [`#00${color}`, 1.0]
    ]
  }
}