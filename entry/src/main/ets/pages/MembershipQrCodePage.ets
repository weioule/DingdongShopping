@Entry
@Component
export struct MembershipQrCodePage {
  @State message: string = 'MembershipQrCodePage';
  @Prop @Watch('customShow') membershipQrCode: boolean

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