/**
 * @author weioule
 * @date 2025-02-01
 * Index
 */
@Entry
@Component
export struct Index {
  @State message: string = 'Hello World!';

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