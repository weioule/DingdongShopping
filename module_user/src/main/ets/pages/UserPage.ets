@Entry
@Component
export struct UserPage {
  @State message: string = 'UserPage';
  @Prop @Watch('customShow') userShow: boolean

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