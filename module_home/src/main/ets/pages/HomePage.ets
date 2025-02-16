@Entry
@Component
export struct HomePage {
  @State message: string = 'HomePage';
  @Prop @Watch('customShow') mainShow: boolean

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