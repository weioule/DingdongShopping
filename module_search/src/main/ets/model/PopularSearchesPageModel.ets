import { Observable } from 'rxjs/internal/Observable';
import { PopularSearchesBean } from 'module_base/src/main/ets/bean/PopularSearchesBean';
import { AssociativeWordsBean } from '../bean/AssociativeWordsBean';

/**
 * @author weioule
 * @date 2025-02-22
 */
export class PopularSearchesPageModel {
  rx_associativeWordsList: Observable<AssociativeWordsBean[]>
  declare associativeWordsList: (list: AssociativeWordsBean[]) => void;
  rx_popularSearchesList: Observable<PopularSearchesBean[]>
  declare popularSearchesList: (list: PopularSearchesBean[]) => void;

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