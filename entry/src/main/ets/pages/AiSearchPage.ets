@Entry
@Component
export struct AiSearchPage {
  @State message: string = 'aiSearchPage';
  @Prop @Watch('customShow') aiSearchShow: boolean

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