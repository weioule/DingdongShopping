import { CategoryBean as CategoryBean } from 'module_base/src/main/ets/bean/CategoryBean';

/**
 * @author weioule
 * @date 2025-10-12
 */
@Component
export struct HomeBannersView {
  @State banners: CategoryBean[] = []

  build() {
    List() {
      ForEach(this?.banners, (item: CategoryBean, index: number) => {
        ListItem() {
          Column() {
            Text(item.categoryName)
              .height(45)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .padding({
                left: 10,
                top: 10,
                right: 10,
                bottom: 5
              })

            Image(item.picUrl)
              .width(55)
              .height(55)
              .objectFit(ImageFit.Cover)
              .border({//为了体现图片的轮廓
                width: 1,
                radius: 50,
                color: Color.Red
              })
          }
          .height(110)
          .border({ radius: 10 })
          .backgroundColor(Color.White)
          .padding({
            left: 10,
            right: 10
          })
          .margin({
            left: index === 0 ? 8 : 4,
            right: index === (this.banners?.length ?? 0) - 1 ? 8 : 4
          })
        }
      })
    }
    .height(110)
    .width('100%')
    .margin({ top: 100 })
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .listDirection(Axis.Horizontal)
  }
}