/**
 * @author weioule
 * @date 2025-02-02
 * 数据bean
 */
export class Classify {
  sort: number = 0;
  classifyId: string = '';
  classifyName: string = '';
  groupPosition: number = 0;
  commodityList: Commodity[] = [];
  secondaryClassifyId: string = '';
  classifyPic: Resource = $r('app.media.product_images1')
}

@Observed
export class Commodity {
  commodityId: string = ''
  commodityName: string = ''
  commoditySubName: string = ''
  salesVolume: number = 0
  price: number = 0
  oldPrice: number = 0
  commodityPic: Resource = $r('app.media.product_images1')
  hasStock: boolean = true
  minBuyQuantity: number = 0
}



