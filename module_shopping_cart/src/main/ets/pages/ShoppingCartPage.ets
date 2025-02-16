@Entry
@Component
export struct ShoppingCartPage {
  @State message: string = 'ShoppingCart';
  @Prop @Watch('customShow') shopCartShow: boolean

  customShow() {

  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}