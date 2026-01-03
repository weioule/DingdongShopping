import { CategoryBean } from "./CategoryBean";

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
  classifyPic: Resource = $r("app.media.img_product1")
}

@Observed
export class Commodity {
  constructor(itemType: number = 0) {
    this.itemType = itemType;
    this.commodityId = Date.now() + Math.random().toString();
  }

  heat: number = 0
  price: number = 0
  oldPrice: number = 0
  //本地标记  0：正常商品，  1：搜索空页面，  2：猜你喜欢组件，  3：品类列表，  4：我是有底线的，  5：商品列表顶尾部的外边距控件，  6: 热搜榜，  7：首页头部地址+搜索框+首页banners+首页图标列表+首页营销引流+首页抢购商品列表   8：商品列表banner
  itemType: number = 0
  salesVolume: number = 0
  commodityId: string = ''
  discountTag: string = ''
  hasStock: boolean = true
  minBuyQuantity: number = 0
  commodityName: string = ''
  commodityUnit: string = ''
  commoditySpec: string = ''
  commoditySubName: string = ''
  commodityPic: Resource = $r("app.media.img_product1")
  commodityList: Commodity[] = [] //首页抢购商品列表、商品列表
  categoryList: CategoryBean[] = [] //首页banners、图标列表、营销引流
  maskColor: string = ''
}



