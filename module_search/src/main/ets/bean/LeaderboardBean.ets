import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';

export class LeaderboardBean {
  name: string = ''
  list: Commodity[] = []
}

export class LeaderboardDetailBean {
  name: string = ''
  unit: string = ''
  heat: number = 0
  type: number = 0 //0=商品  1=热搜
  price: number = 0
  specifications: string = ''
  picUrl: Resource = $r("app.media.img_product1")
}