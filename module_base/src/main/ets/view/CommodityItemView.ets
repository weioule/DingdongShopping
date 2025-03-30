import { PriceView } from './PriceView';
import { Commodity } from '../bean/ClassifyBean';
import { AddCartButtonView } from './AddCartButtonView';
import { AppRouter } from '../common/AppRouter';
import { MyApp } from '../common/Application';
import { RefreshState } from '../refresh/MyPullToRefresh';
import { App } from '@kit.ArkUI';

/**
 * @author weioule
 * @date 2025-02-23
 * 猜你喜欢列表item组件
 */
@Component
export struct CommodityItemView {
  @Prop commodity: Commodity;
  @Prop state: number = 0

  aboutToAppear(): void {
    App.setImageRawDataCacheSize(1024 * 1024 * 1000); // 避免图片渲染闪缩使用缓存 解码前数据上限，单位为字节；约等于9.53M
    App.setImageCacheCount(1000); // 设置内存中缓存解码后图片的数量上限
  }

  build() {
    Column() {
      Image(this.commodity.commodityPic)
        .height('auto')
        .objectFit(ImageFit.Auto)
        .backgroundColor(Color.White)
        .border({ radius: { topLeft: 10, topRight: 10 } })
        .interpolation(ImageInterpolation.None) // 禁用插值

      Text(this.commodity.commodityName)
        .fontSize(15)
        .fontColor($r('app.color.txt_color'))
        .margin({ left: 10, right: 5, top: 5 })

      Text(this.commodity.commoditySubName)
        .fontSize(12)
        .fontColor($r('app.color.txt_color_666'))
        .margin({ left: 10, right: 5, top: 5 })

      if (this.commodity.discountTag.length > 0) {
        Row() {
          Text('折')
            .width(16)
            .height(16)
            .fontSize(11)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
            .borderRadius({ topLeft: 3, bottomLeft: 3 })
            .backgroundColor($r('app.color.red_color'))

          Text(this.commodity.discountTag)
            .height(16)
            .fontSize(10)
            .backgroundColor('#11ff0000')
            .padding({ left: 3, right: 3 })
            .fontColor($r('app.color.red_color'))
            .border({
              width: 0.5,
              color: $r('app.color.red_color'),
              radius: { topRight: 3, bottomRight: 3 }
            })
        }
        .margin({ left: 10, top: 5 })
      }

      Flex({ direction: FlexDirection.Row }) {
        PriceView({
          fontSizeBig: 18,
          price: this.commodity.price,
          oldPrice: this.commodity.oldPrice,
        })
        AddCartButtonView({ commodityId: this.commodity.commodityId })
          .visibility(this.commodity.hasStock ? Visibility.Visible : Visibility.Hidden) //购物车按钮
      }.padding({ left: 10, top: 10, right: 10 }).width((MyApp.Size.screenWidth - 30) / 2)
    }
    .width('auto')
    .border({ radius: 10 })
    .padding({ bottom: 10 })
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
    .onClick(async () => {
      if (this.state == RefreshState.FREE) {
        //解决当内容不满一屏上拉、下拉抬手时偶现触发点击事件的问题
        AppRouter.toCommodityDetailPage(this.commodity.commodityId);
      }
    })
  }
}