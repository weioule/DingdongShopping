import { Classify } from "module_base/src/main/ets/bean/ClassifyBean";

/**
 * @author weioule
 * @date 2025-02-01
 * 左侧一级分类商品条目
 */
@Component
export struct FirstClassifyItem {
  @State classify?: Classify = undefined;
  @Prop currentIndex: number;
  @Prop index: number;
  onClickAction = () => {
    this.currentIndex = this.index
  }

  build() {
    RelativeContainer() {
      Text('')
        .width(4)
        .height(20)
        .backgroundColor($r('[module_base].color.theme_color'))
        .visibility(this.currentIndex == this.index ? Visibility.Visible : Visibility.Hidden)
        .alignRules({ center: { anchor: '__container__', align: VerticalAlign.Center } })

      Row() {
        Text(this.classify?.classifyName)
          .width('auto')
          .fontColor(this.currentIndex == this.index ? $r('[module_base].color.theme_color') :
          $r('[module_base].color.txt_color_666'))
          .fontSize(14)
          .maxFontSize(5)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height(50)
    .width('100%')
    .onClick(this.onClickAction)
    .backgroundColor(this.currentIndex == this.index ? Color.White : '#f6f6f6')
    .border({
      radius: {
        topRight: this.currentIndex + 1 == this.index ? 10 : 0,
        bottomRight: this.currentIndex - 1 == this.index ? 10 : 0
      }
    })
  }
}