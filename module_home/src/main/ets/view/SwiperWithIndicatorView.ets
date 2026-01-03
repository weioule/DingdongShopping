import { MyApp } from 'module_base/src/main/ets/common/Application';
import { ToastUtil } from 'module_base/src/main/ets/utils/ToastUtil';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';

@Component
export struct SwiperWithIndicatorView {
  @State currentIndex: number = 0;
  @State banners: Commodity[] = [];

  build() {
    Column() {
      Swiper() {
        ForEach(this.banners, (banner: Commodity, index: number) => {
          Image(banner.commodityPic)
            .width('100%')
            .height(150)
            .borderRadius(10)
            .onClick(() => {
              ToastUtil.show(banner.commodityName)
            })
        })
      }
      .loop(true)
      .autoPlay(true)
      .interval(3000)
      .background(Color.Yellow)
      .width((MyApp.Size.screenWidth - 30) / 2)
      .indicator(new DotIndicator()
        .itemWidth(5)
        .itemHeight(5)
        .selectedItemWidth(5)
        .selectedItemHeight(5)
        .color(Color.White)
        .selectedColor($r('[module_base].color.green_color')))
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
  }
}