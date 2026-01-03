import { ResultParams } from '../pages/HomePage';
import { HomeInfoBean } from '../bean/HomeInfoBean';
import { Observable } from 'rxjs/internal/Observable';
import { systemDateTime } from '@kit.BasicServicesKit';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { CategoryBean } from 'module_base/src/main/ets/bean/CategoryBean';

/**
 * @author weioule
 * @date 2025-10-01
 */
export class HomeModel {
  readonly pageSize: number = 20
  rx_homeInfo: Observable<HomeInfoBean>
  declare homeInfo: (data: HomeInfoBean) => void
  rx_commodityList: Observable<ResultParams>
  declare commodityList: (data: ResultParams) => void

  constructor() {
    this.rx_homeInfo = new Observable<HomeInfoBean>((observer) => {
      this.homeInfo = (data) => {
        observer.next(data)
      }
    })
    this.rx_commodityList = new Observable<ResultParams>((observer) => {
      this.commodityList = (data) => {
        observer.next(data)
      }
    })
  }

  refresh(): Promise<string> {
    return new Promise((resolve, reject) => {
      let categoryList: CategoryBean[] = this.getCategoryList()
      let commodityList = this.getCommodityList()

      resolve('')

      this.homeInfo({
        address: '上海市人民广场',
        msgCount: 88,
        banners: categoryList,
        icons: categoryList,
        diversion: this.getDiversionBeanList(),
        snapped: commodityList,
        commodityList: commodityList
      })
    })
  }

  loadMore(pageNo: number): Promise<string> {
    return new Promise((resolve, reject) => {

      resolve('')

      this.commodityList({
        list: this.getCommodityList(),
        currentPage: pageNo,
        hasNextPage: pageNo < 3
      })
    })
  }

  getPopularSearches(): Promise<PopularSearchesBean[]> {
    return new Promise((resolve, reject) => {
      let list: PopularSearchesBean[] = []
      let bean = new PopularSearchesBean()
      bean.name = '芒果三明治，大块水仙芒0'
      bean.picUrl = $r('[module_base].media.ic_hot01')
      list.push(bean)

      let bean2 = new PopularSearchesBean()
      bean2.name = '西瓜1'
      list.push(bean2)

      let bean3 = new PopularSearchesBean()
      bean3.name = '草莓2'
      list.push(bean3)

      let bean4 = new PopularSearchesBean()
      bean4.name = '三文鱼厚切，软糯鲜甜3'
      bean4.picUrl = $r('[module_base].media.ic_hot02')
      list.push(bean4)

      let bean5 = new PopularSearchesBean()
      bean5.name = '小番茄4'
      list.push(bean5)

      let bean6 = new PopularSearchesBean()
      bean6.name = '免蒸煮青团粉，软糯香甜5'
      bean6.picUrl = $r('[module_base].media.ic_hot03')
      list.push(bean6)

      resolve(list)
    })
  }

  private getCommodityList() {
    let list: Commodity[] = []
    for (let i = 0; i < this.pageSize; i++) {
      let c = new Commodity()
      if (i == 0) {
        c.itemType = 8
        let banners: Commodity[] = [...this.getDiversionBeanList()[0], ...this.getDiversionBeanList()[1]]
        c.commodityList = banners
      }

      c.commodityId = i + ' ' + systemDateTime.getTime()
      c.price = 88
      c.oldPrice = 100
      c.commodityName = '查询商品 500g ' + i
      c.commoditySubName = '非常新鲜，值得推荐'
      if (i % 4 == 0) {
        c.discountTag = i + '.5折'
        c.commodityPic = $r("app.media.img_product1")
      } else if (i % 4 == 1) {
        c.commodityPic = $r("app.media.img_product2")
      } else if (i % 4 == 2) {
        c.commodityPic = $r("app.media.img_product3")
      } else {
        c.commodityPic = $r("app.media.img_product4")
      }

      list.push(c)
    }
    return list
  }

  private getCategoryList() {
    let categoryList: CategoryBean[] = [];
    for (let i = 0; i < 15; i++) {
      let bean = new CategoryBean();
      bean.categoryId = i.toString();
      bean.categoryName = '品类' + i;
      if (i % 4 == 0) {
        bean.picUrl = $r("app.media.img_product1");
      } else if (i % 4 == 1) {
        bean.picUrl = $r("app.media.img_product2");
      } else if (i % 4 == 2) {
        bean.picUrl = $r("app.media.img_product3");
      } else {
        bean.picUrl = $r("app.media.img_product4");
      }
      categoryList.push(bean);
    }
    return categoryList;
  }

  private getDiversionBeanList(): Commodity[][] {
    // 直接初始化二维数组
    return [
      [
        this.createCommodity('去根冬笋 约500g', '野生挖采', '相聚好时光', 22.9, 'app.media.img_diversion1', '#fc741f'),
        this.createCommodity('深海皮皮虾 450g', '膏满肉肥', '相聚好时光', 39.9, 'app.media.img_diversion4', '#fc741f'),
      ],
      [
        this.createCommodity('红颜草莓 300g', '脆硬香甜', '厘想冬日莓好陪伴', 19.9, 'app.media.img_diversion2',
          '#dd312e'),
        this.createCommodity('砂糖橘 250g', '甜蜜爆汁', '厘想冬日莓好陪伴', 9.9, 'app.media.img_diversion3', '#dd312e'),
      ]
    ]
  }

  // 创建商品对象的辅助方法
  private createCommodity(
    name: string,
    subName: string,
    tag: string,
    price: number,
    picResource: string,
    maskColor: string
  ): Commodity {
    let commodity = new Commodity()
    commodity.commodityId = systemDateTime.getTime().toString()
    commodity.commodityName = name
    commodity.commoditySubName = subName
    commodity.discountTag = tag
    commodity.price = price
    commodity.commodityPic = $r(picResource)
    commodity.maskColor = maskColor
    return commodity
  }
}
