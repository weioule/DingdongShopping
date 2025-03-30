import { Observable } from 'rxjs/internal/Observable';
import { SearchCategoryBean as SearchCategoryBean } from '../bean/SearchCategoryBean';
import { ResultParams } from '../pages/SearchListPage';
import { Commodity } from 'module_base/src/main/ets/bean/ClassifyBean';
import { systemDateTime } from '@kit.BasicServicesKit';

/**
 * @author weioule
 * @date 2025-02-23
 */
export class SearchListModel {
  rx_searchCategoryList: Observable<SearchCategoryBean[]>
  declare searchCategoryList: (list: SearchCategoryBean[]) => void;
  rx_searchList: Observable<ResultParams>
  declare searchList: (data: ResultParams) => void;

  constructor() {
    this.rx_searchCategoryList = new Observable<SearchCategoryBean[]>((observer) => {
      this.searchCategoryList = (list) => {
        observer.next(list);
      }
    });
    this.rx_searchList = new Observable<ResultParams>((observer) => {
      this.searchList = (data) => {
        observer.next(data);
      }
    });
  }

  querySearchCategoryList(kw: string): Promise<string> {
    return new Promise((resolve, reject) => {
      let list: SearchCategoryBean[] = []
      for (let i = 0; i < 15; i++) {
        let bean = new SearchCategoryBean()
        bean.classifyId = i.toString()
        bean.classifyName = '品类' + i
        if (i % 4 == 0) {
          bean.picUrl = $r("app.media.img_product1")
        } else if (i % 4 == 1) {
          bean.picUrl = $r("app.media.img_product2")
        } else if (i % 4 == 2) {
          bean.picUrl = $r("app.media.img_product3")
        } else {
          bean.picUrl = $r("app.media.img_product4")
        }
        list.push(bean)
      }
      this.searchCategoryList(list);
    })
  }

  querySearchList(params: SearchListParams): Promise<string> {
    return new Promise((resolve, reject) => {
      let searchList: Commodity[] = []
      let guessYouLikeList: Commodity[] = []

      if (params.pageNo <= 2) {
        //假设前面3页都有搜索的数据
        searchList = this.getList(params);
      }
      if (params.pageNo >= 2) {
        //假设从第3页开始(也就是搜索数据的最后一页)有猜你喜欢的数据，搜索的数据跟猜你喜欢分两个列表，要做衔接展示
        guessYouLikeList = this.getList(params);
      }

      resolve('')

      this.searchList({
        searchList: searchList,
        currentPage: params.pageNo,
        guessYouLikeList: guessYouLikeList,
        hasNextPage: params.pageNo < 6 ? true : false
      });
    })
  }

  private getList(params: SearchListParams) {
    let list: Commodity[] = [];
    for (let i = 0; i < params.pageSize; i++) {
      let c = new Commodity();
      c.commodityId = ((params.pageNo - 1) * params.pageSize) + i + '' + systemDateTime.getTime();
      c.price = 88;
      c.oldPrice = 100;
      c.commodityName = '查询商品 500g ' + i;
      c.commoditySubName = '非常新鲜，值得推荐';
      if (i % 4 == 0) {
        c.discountTag = i + '.5折';
        c.commodityPic = $r("app.media.img_product1");
      } else if (i % 4 == 1) {
        c.commodityPic = $r("app.media.img_product2");
      } else if (i % 4 == 2) {
        c.commodityPic = $r("app.media.img_product3");
      } else {
        c.commodityPic = $r("app.media.img_product4");
      }

      list.push(c);
    }
    return list;
  }
}

export interface SearchListParams {
  pageNo: number;
  keyword: string;
  pageSize: number;
  searchType: number;
  classifyId: string;
  priceSortType: number;
}