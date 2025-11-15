import { ResultParams } from '../pages/HomePage';
import { HomeInfoBean } from '../bean/HomeInfoBean';
import { Observable } from 'rxjs/internal/Observable';
import { systemDateTime } from '@kit.BasicServicesKit';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { CategoryBean as CategoryBean } from 'module_base/src/main/ets/bean/CategoryBean';

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
      let categoryList: CategoryBean[] = []
      for (let i = 0; i < 15; i++) {
        let bean = new CategoryBean()
        bean.categoryId = i.toString()
        bean.categoryName = '品类' + i
        if (i % 4 == 0) {
          bean.picUrl = $r("app.media.img_product1")
        } else if (i % 4 == 1) {
          bean.picUrl = $r("app.media.img_product2")
        } else if (i % 4 == 2) {
          bean.picUrl = $r("app.media.img_product3")
        } else {
          bean.picUrl = $r("app.media.img_product4")
        }
        categoryList.push(bean)
      }

      let commodityList = this.getList()

      resolve('')

      this.homeInfo({
        address: '上海市人民广场',
        msgCount: 88,
        banners: categoryList,
        icons: categoryList,
        diversion: categoryList.slice(0, 2),
        snapped: commodityList,
        commodityList: commodityList
      })
    })
  }

  loadMore(pageNo: number): Promise<string> {
    return new Promise((resolve, reject) => {

      resolve('')

      this.commodityList({
        list: this.getList(),
        currentPage: pageNo,
        hasNextPage: pageNo < 3
      })
    })
  }

  getPopularSearches(): Promise<PopularSearchesBean[]> {
    return new Promise((resolve, reject) => {
      let list: PopularSearchesBean[] = []
      let bean = new PopularSearchesBean()
      bean.name = '芒果三明治，大块水仙芒'
      bean.picUrl = $r('[module_base].media.ic_hot01')
      list.push(bean)

      let bean2 = new PopularSearchesBean()
      bean2.name = '西瓜'
      list.push(bean2)

      let bean3 = new PopularSearchesBean()
      bean3.name = '草莓'
      list.push(bean3)

      let bean4 = new PopularSearchesBean()
      bean4.name = '三文鱼厚切，软糯鲜甜'
      bean4.picUrl = $r('[module_base].media.ic_hot02')
      list.push(bean4)

      let bean5 = new PopularSearchesBean()
      bean5.name = '小番茄'
      list.push(bean5)

      let bean6 = new PopularSearchesBean()
      bean6.name = '免蒸煮青团粉，软糯香甜'
      bean6.picUrl = $r('[module_base].media.ic_hot03')
      list.push(bean6)

      resolve(list)
    })
  }

  private getList() {
    let list: Commodity[] = []
    for (let i = 0; i < this.pageSize; i++) {
      let c = new Commodity()
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
}
