import { Observable } from 'rxjs/internal/Observable';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { AssociativeWordsBean } from '../bean/AssociativeWordsBean';
import { LeaderboardBean } from '../bean/LeaderboardBean';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';

/**
 * @author weioule
 * @date 2025-02-22
 */
export class PopularSearchesPageModel {
  rx_associativeWordsList: Observable<AssociativeWordsBean[]>
  declare associativeWordsList: (list: AssociativeWordsBean[]) => void;
  rx_popularSearchesList: Observable<PopularSearchesBean[]>
  declare popularSearchesList: (list: PopularSearchesBean[]) => void;
  rx_leaderboardList: Observable<LeaderboardBean[]>
  declare leaderboardList: (list: LeaderboardBean[]) => void;

  constructor() {
    this.rx_associativeWordsList = new Observable<AssociativeWordsBean[]>((observer) => {
      this.associativeWordsList = (list) => {
        observer.next(list);
      }
    });
    this.rx_popularSearchesList = new Observable<PopularSearchesBean[]>((observer) => {
      this.popularSearchesList = (list) => {
        observer.next(list);
      }
    });
    this.rx_leaderboardList = new Observable<LeaderboardBean[]>((observer) => {
      this.leaderboardList = (list) => {
        observer.next(list);
      }
    });
  }

  queryAssociativeWords(str: string): Promise<string> {
    return new Promise((resolve, reject) => {
      let list: AssociativeWordsBean[] = []
      for (let i = 0; i < 10; i++) {
        let bean = new AssociativeWordsBean()
        bean.name = str + i
        bean.highlight = str
        bean.highlightList = this.findKeyword(bean.name, str)
        list.push(bean)
      }

      this.associativeWordsList(list);
      resolve('')
    })
  }

  queryHotSearch(): Promise<string> {
    return new Promise((resolve, reject) => {
      let list: PopularSearchesBean[] = []

      let bean = new PopularSearchesBean()
      bean.name = '鲜奶吐司'
      bean.isHot = true
      list.push(bean)

      let bean2 = new PopularSearchesBean()
      bean2.name = '黑砖世家黑猪'
      bean2.isHot = true
      list.push(bean2)

      let bean3 = new PopularSearchesBean()
      bean3.name = '基围虾'
      list.push(bean3)

      let bean4 = new PopularSearchesBean()
      bean4.name = '榴莲'
      list.push(bean4)

      let bean5 = new PopularSearchesBean()
      bean5.name = '猪蹄髈'
      list.push(bean5)

      let bean6 = new PopularSearchesBean()
      bean6.name = '车厘子'
      list.push(bean6)

      let bean7 = new PopularSearchesBean()
      bean7.name = '蓝莓'
      list.push(bean7)

      let bean8 = new PopularSearchesBean()
      bean8.name = '青团上新'
      list.push(bean8)

      let bean9 = new PopularSearchesBean()
      bean9.name = '三文鱼'
      list.push(bean9)

      let bean10 = new PopularSearchesBean()
      bean10.name = '香椿'
      list.push(bean7)

      let bean11 = new PopularSearchesBean()
      bean11.name = '黑芝麻汤圆'
      list.push(bean11)

      let bean12 = new PopularSearchesBean()
      bean12.name = '时令蔬菜'
      list.push(bean12)

      let bean13 = new PopularSearchesBean()
      bean13.name = '酒酿'
      list.push(bean13)

      this.popularSearchesList(list);
      resolve('')
    })
  }

  queryLeaderboardList(): Promise<string> {
    return new Promise((resolve, reject) => {
      let list: LeaderboardBean[] = []
      for (let i = 0; i < 4; i++) {
        let bean = new LeaderboardBean()
        bean.name =
          i == 0 ? '咚咚热搜' : 1 == i ? '6月时令水果榜' : 2 == i ? '附近人都在买' : '6月时令蔬菜榜'

        let detailList: Commodity[] = []
        for (let j = Math.floor(Math.random() * 5) + 6; j >= 0; j--) {
          let bean = new Commodity()
          if (i == 0) {
            bean.itemType = 6
            bean.commodityName = '咚咚热搜' + j
            bean.heat = 30000 + j * 10000 + j * 1000 + j * 100
            bean.hasStock = false
          } else {
            bean.itemType = 0
            bean.hasStock = true
            bean.commodityName = '时令时蔬时' + j
            bean.price = j * 10 + j + j * 0.1
            bean.commodityUnit = j % 2 == 0 ? '份' : '盒'
            bean.commoditySpec = '约' + j * 100 + 'g'
          }

          if (i % 4 == 0) {
            bean.commodityPic = $r("app.media.img_product1")
          } else if (i % 4 == 1) {
            bean.commodityPic = $r("app.media.img_product2")
          } else if (i % 4 == 2) {
            bean.commodityPic = $r("app.media.img_product3")
          } else {
            bean.commodityPic = $r("app.media.img_product4")
          }

          detailList.push(bean)
        }
        bean.list = detailList
        list.push(bean)
      }

      this.leaderboardList(list);
      resolve('')
    })
  }

  //查找关键字，允许存在多个
  findKeyword(originalText: string, keyword: string): string[] {
    if (keyword === "") {
      return [originalText];
    }
    let result: string[] = [];
    let lastIndex: number = 0;
    while (true) {
      const index = originalText.indexOf(keyword, lastIndex);
      if (index === -1) {
        //当没有找到更多搜索文本时，将剩余部分添加到结果数组
        if (lastIndex < originalText.length) {
          result.push(originalText.slice(lastIndex));
        }
        break;
      }
      //如果'index'大于'lastIndex'，说明有非搜索字符串的文本存在
      if (index > lastIndex) {
        result.push(originalText.slice(lastIndex, index));
      }
      //将搜索文本本身添加到结果数组
      result.push(originalText.slice(index, index + keyword.length));
      //更新下次查找的起始位置
      lastIndex = index + keyword.length;
    }
    return result;
  }
}