import { common } from '@kit.AbilityKit';
import { HomePage } from 'module_home/src/main/ets/pages/HomePage';
import { ClassifyPage } from 'module_classify/src/main/ets/pages/ClassifyPage';
import { ShoppingCartPage } from 'module_shopping_cart/src/main/ets/pages/ShoppingCartPage';
import { UserPage } from 'module_user/src/main/ets/pages/UserPage';
import { MyApp } from 'module_base/src/main/ets/common/Application';
import { MembershipQrCodePage } from './MembershipQrCodePage';

/**
 * @author weioule
 * @date 2025-02-01
 * 程序主入口
 */
@Entry
@Component
export struct Index {
  public static context = (getContext() as common.UIAbilityContext)
  @State currentIndex: number = 1
  @State mainShow: boolean = false;
  @State userShow: boolean = false;
  @State classifyShow: boolean = true;
  @State shopCartShow: boolean = false;
  @State membershipQrCode: boolean = false;

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        HomePage({ mainShow: this.mainShow })
      }
      .tabBar(this.TabBuilder('首页', 0, $r("app.media.ic_home_theme"), $r("app.media.ic_home_gray")))

      TabContent() {
        ClassifyPage({ classifyShow: this.classifyShow })
      }
      .tabBar(this.TabBuilder('分类', 1, $r("app.media.ic_classify_theme"), $r("app.media.ic_classify_gray")))

      TabContent() {
        MembershipQrCodePage({ membershipQrCode: this.membershipQrCode })
      }
      .tabBar(this.TabBuilder('', 2, $r('app.media.ic_membership_qr_code'),
        $r('app.media.ic_membership_qr_code')))

      TabContent() {
        ShoppingCartPage({ shopCartShow: this.shopCartShow })
      }
      .tabBar(this.TabBuilder('购物车', 3, $r("app.media.ic_shopping_cart_theme"),
        $r("app.media.ic_shopping_cart_gray")))

      TabContent() {
        UserPage({ userShow: this.userShow })
      }
      .tabBar(this.TabBuilder('我的', 4, $r("app.media.ic_user_theme"), $r("app.media.ic_user_gray")))

    }
    .animationDuration(0)
    .scrollable(false)
    .margin({
      bottom: MyApp.Size.safeArea
    })
    .onChange((index: number) => {
      if (this.currentIndex == 0) {
        this.mainShow = false
      } else if (this.currentIndex == 1) {
        this.classifyShow = false
      } else if (this.currentIndex == 2) {
        this.membershipQrCode = false
      } else if (this.currentIndex == 3) {
        this.shopCartShow = false
      } else if (this.currentIndex == 4) {
        this.userShow = false
      }

      this.currentIndex = index

      if (this.currentIndex == 0) {
        this.mainShow = true
      } else if (this.currentIndex == 1) {
        this.classifyShow = true
      } else if (this.currentIndex == 2) {
        this.membershipQrCode = true
      } else if (this.currentIndex == 3) {
        this.shopCartShow = true
      } else if (this.currentIndex == 4) {
        this.userShow = true
      }
    })
  }

  @Builder
  TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: targetIndex == 2 ? 35 : 25, height: targetIndex == 2 ? 35 : 25 })

      if (title) {
        Text(title)
          .margin({ top: 5 })
          .fontSize(this.currentIndex === targetIndex ? 13 : 12)
          .fontColor(this.currentIndex === targetIndex ? $r("[module_base].color.green_color") :
          $r('[module_base].color.txt_color_999'))
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: $r('[module_base].color.line_gray') })
  }
}


