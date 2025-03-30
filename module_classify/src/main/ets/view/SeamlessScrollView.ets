import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';

/**
 * @author weioule
 * @date 2025-03-01
 * 输入框热门搜索滚动组件
 */
@Component
export struct SeamlessScrollView {
  @Link currentIndex: number;
  @State delay: number = 3000;
  @State fontSize: number = 15;
  @State private offsetY: number = 0;
  private isVisible: boolean = false;
  private timer: number | null = null;
  @State fontColor: ResourceColor = 0;
  private textHeight: number = 30; // 单行高度
  @State popularSearches: PopularSearchesBean[] = [];
  @State containerHeight: number = this.textHeight * this.popularSearches.length;

  // 精准计算滚动时机
  startScroll() {
    this.timer = setInterval(() => {
      animateTo({
        duration: 500,
        curve: Curve.Linear,
        onFinish: () => {
          // 在动画结束时检查是否需要重置
          if (-this.offsetY >= this.containerHeight * 0.95) {
            this.offsetY = 0;
          }
        }
      }, () => {
        this.offsetY -= this.textHeight;
        this.currentIndex = Math.abs(this.offsetY) / this.textHeight
      });
    }, this.delay);
  }

  aboutToAppear() {
    this.containerHeight = this.textHeight * this.popularSearches.length;
  }

  aboutToDisappear() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 主显示容器（当前可视区域）
      Column() {
        ForEach(this.popularSearches, (item: PopularSearchesBean) => {
          Row() {
            if (item.picUrl) {
              Image(item.picUrl)
                .margin({ right: 3 })
                .size({ width: 20, height: 20 })
                .objectFit(ImageFit.Fill)
            }

            Text(item.name)
              .width('100%')
              .height(this.textHeight)
              .fontSize(this.fontSize)
              .fontColor(this.fontColor)
          }
        })
      }
      .offset({ y: this.offsetY })

      // 预加载容器（紧随主容器下方）
      Column() {
        ForEach(this.popularSearches, (item: PopularSearchesBean) => {
          Row() {
            if (item.picUrl) {
              Image(item.picUrl)
                .margin({ right: 3 })
                .size({ width: 20, height: 20 })
                .objectFit(ImageFit.Fill)
            }

            Text(item.name)
              .width('100%')
              .height(this.textHeight)
              .fontSize(this.fontSize)
              .fontColor(this.fontColor)
          }
        })
      }
      .offset({ y: this.offsetY + this.containerHeight })

      // 缓冲容器（再下方一层，确保最极端情况下也不露白）
      Column() {
        ForEach(this.popularSearches, (item: PopularSearchesBean) => {
          Row() {
            if (item.picUrl) {
              Image(item.picUrl)
                .margin({ right: 3 })
                .size({ width: 20, height: 20 })
                .objectFit(ImageFit.Fill)
            }

            Text(item.name)
              .width('100%')
              .height(this.textHeight)
              .fontSize(this.fontSize)
              .fontColor(this.fontColor)
          }
        })
      }
      .offset({ y: this.offsetY + this.containerHeight * 2 })
    }
    .clip(true)
    .width('100%')
    .opacity(0.99)
    .height(this.textHeight) // 单行可视区域
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && this.isVisible != true) {
        this.isVisible = true
        this.startScroll()
      } else if (this.isVisible) {
        this.isVisible = false
        if (this.timer) {
          clearInterval(this.timer);
        }
      }
    })
  }
}