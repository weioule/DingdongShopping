import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';

@Component
export struct SeamlessScrollView {
  @State delay: number = 3000
  @State fontSize: number = 15
  @State fontColor: ResourceColor = 0
  private isVisible: boolean = false
  private textHeight: number = 30 // 单行高度
  @State containerHeight: number = 0
  @State popularSearches: PopularSearchesBean[] = []
  // 关键点1：使用 StorageLink 连接到全局状态
  @StorageLink('globalScrollOffset') globalOffsetY: number = 0
  // 关键点2：全局唯一的定时器ID
  private static globalTimerId: number | null = null
  // 关键点3：可见组件计数器
  private static visibleComponents: number = 0

  // 精准计算滚动时机 - 全局共享定时器
  startScroll() {
    // 如果全局定时器已经在运行，直接返回
    if (SeamlessScrollView.globalTimerId !== null) {
      return;
    }

    // 启动全局定时器
    SeamlessScrollView.globalTimerId = setInterval(() => {
      // 使用 animateTo 实现动画
      animateTo({
        duration: 500,
        curve: Curve.Linear,
        onFinish: () => {
          // 在动画结束时检查是否需要重置
          const currentOffset = AppStorage.get<number>('globalScrollOffset') || 0
          if (-currentOffset >= this.containerHeight * 0.95 && this.containerHeight > 0) {
            // 重置到起始位置
            AppStorage.setOrCreate('globalScrollOffset', 0)
            AppStorage.setOrCreate('globalScrollIndex', 0)
          }
        }
      }, () => {
        // 更新全局偏移量
        const currentOffset = AppStorage.get<number>('globalScrollOffset') || 0
        const newOffsetY = currentOffset - this.textHeight
        const newIndex = Math.abs(newOffsetY) / this.textHeight

        // 关键点4：更新到 AppStorage，所有组件会自动同步
        AppStorage.setOrCreate('globalScrollOffset', newOffsetY)
        AppStorage.setOrCreate('globalScrollIndex', newIndex % this.popularSearches.length)
      })
    }, this.delay)
  }

  aboutToAppear() {
    this.containerHeight = this.textHeight * this.popularSearches.length
  }

  // 检查并清理定时器的方法
  private checkAndCleanTimer(): void {
    if (SeamlessScrollView.visibleComponents === 0 && SeamlessScrollView.globalTimerId !== null) {
      clearInterval(SeamlessScrollView.globalTimerId)
      SeamlessScrollView.globalTimerId = null
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 主显示容器（当前可视区域）
      Column() {
        ForEach(this.popularSearches, (item: PopularSearchesBean, index?: number) => {
          Row() {
            if (item.picUrl) {
              Image(item.picUrl)
                .margin({ right: 3 })
                .size({ width: 20, height: 20 })
                .objectFit(ImageFit.Fill)
            }

            Text(item.name)
              .maxLines(1)
              .width('100%')
              .height(this.textHeight)
              .fontSize(this.fontSize)
              .fontColor(this.fontColor)
          }
        })
      }
      // 关键点6：使用全局偏移量
      .offset({ y: this.globalOffsetY })

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
              .maxLines(1)
              .width('100%')
              .height(this.textHeight)
              .fontSize(this.fontSize)
              .fontColor(this.fontColor)
          }
        })
      }
      .offset({ y: this.globalOffsetY + this.containerHeight })

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
              .maxLines(1)
              .width('100%')
              .height(this.textHeight)
              .fontSize(this.fontSize)
              .fontColor(this.fontColor)
          }
        })
      }
      .offset({ y: this.globalOffsetY + this.containerHeight * 2 })
    }
    .clip(true)
    .width('100%')
    .height(this.textHeight) // 单行可视区域
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && !this.isVisible) {
        // 变为可见
        this.isVisible = true
        SeamlessScrollView.visibleComponents++

        // 启动滚动（如果还没启动）
        if (SeamlessScrollView.globalTimerId === null) {
          this.startScroll()
        }

      } else if (!isVisible && this.isVisible) {
        // 变为不可见
        this.isVisible = false
        SeamlessScrollView.visibleComponents--

        // 检查是否需要清理定时器
        this.checkAndCleanTimer()
      }
    })
  }
}