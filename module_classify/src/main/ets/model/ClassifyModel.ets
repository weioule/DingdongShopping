import { Classify, Commodity } from '../bean/ClassifyBean';

// 创建一个简单的内存缓存
const cache: Map<string, number> = new Map;

/**
 * @author weioule
 * @date 2025-02-01
 */
export class ClassifyModel {
  getFirstClassify(): Promise<Classify[]> {
    return new Promise((resolve, reject) => {
      let list: Classify[] = []
      for (let i = 0; i < 20; i++) {
        let fc = new Classify()
        fc.classifyName = '水果蔬菜' + i % 10
        fc.classifyId = '' + i
        if (i % 4 == 0) {
          fc.classifyPic = $r("app.media.product_images1")
        } else if (i % 4 == 1) {
          fc.classifyPic = $r("app.media.product_images2")
        } else if (i % 4 == 2) {
          fc.classifyPic = $r("app.media.product_images3")
        } else {
          fc.classifyPic = $r("app.media.product_images4")
        }
        list.push(fc)
      }
      resolve(list)
    })
  }

  getSecondClassify(firstClassifyId: string): Promise<Classify[] | string> {
    return new Promise((resolve, reject) => {
      const cachedTimestamp = cache.get(firstClassifyId)
      let t = Date.now()
      if (cachedTimestamp && t - cachedTimestamp < 300000) {
        //缓存在时间内就不请求
        resolve('useCache')
      } else {
        let list: Classify[] = []
        for (let i = 0; i < 15; i++) {
          let sc = new Classify()
          sc.classifyName = '二级分类' + i
          sc.classifyId = '' + i

          let cList: Commodity[] = []
          for (let j = 0; j < 15; j++) {
            let c = new Commodity()
            c.price = 88
            c.oldPrice = 100
            c.commodityName = '商品名称 500g' + j
            c.commoditySubName = '非常好吃，值得推荐'
            if (j % 4 == 0) {
              c.commodityPic = $r("app.media.product_images1")
            } else if (j % 4 == 1) {
              c.commodityPic = $r("app.media.product_images2")
            } else if (j % 4 == 2) {
              c.commodityPic = $r("app.media.product_images3")
            } else {
              c.commodityPic = $r("app.media.product_images4")
            }
            cList.push(c)
          }

          sc.commodityList = cList
          list.push(sc)
        }

        cache.set(firstClassifyId, Date.now())
        resolve(list)
      }
    })
  }

  //按销量排序
  sortBySalesVolume(classify: Classify): Classify {
    classify.commodityList.sort((c1: Commodity, c2: Commodity) => c1.salesVolume - c2.salesVolume)
    classify.sort = 1;
    return classify;
  }

  //按价格，升序
  sortByPriceUp(classify: Classify): Classify {
    classify.commodityList.sort((c1: Commodity, c2: Commodity) => c1.price - c2.price)
    classify.sort = 2;
    return classify;
  }

  //按价格，降序
  sortByPriceDown(classify: Classify): Classify {
    classify.commodityList.sort((c1: Commodity, c2: Commodity) => c2.price - c1.price)
    classify.sort = 3;
    return classify;
  }
}



