import { CategoryBean } from 'module_base/src/main/ets/bean/CategoryBean';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';


/**
 * @author weioule
 * @date 2025-10-01
 */
export class HomeInfoBean {
  address: string = '' //收货地址
  msgCount: number = 0 //消息数量
  banners: CategoryBean[] = [] //banners
  icons: CategoryBean[] = [] //图标列表
  diversion: Commodity[][] = [] //营销引流
  snapped: Commodity[] = [] //抢购商品列表
  commodityList: Commodity[] = [] //商品列表
}
