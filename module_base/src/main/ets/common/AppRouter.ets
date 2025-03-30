import { router } from '@kit.ArkUI';
import { PopularSearchesBean } from '../bean/PopularSearchesBean';
import { MyApp } from './Application';

/**
 * @author weioule
 * @date 2025-02-02
 * 路由
 */
export namespace AppRouter {
  //搜索关键字页面
  export function toSearchPage(keyword?: string, popularSearches?: PopularSearchesBean,
    finishSelf?: boolean) {
    if (finishSelf) {
      router.replaceUrl({
        url: MyApp.getPageUrl(MyApp.Module.module_search, MyApp.Pages.popularSearchesPage),
        params: { keyword: keyword, popularSearches: popularSearches }
      }, router.RouterMode.Single)
    } else {
      router.pushUrl({
        url: MyApp.getPageUrl(MyApp.Module.module_search, MyApp.Pages.popularSearchesPage),
        params: { keyword: keyword, popularSearches: popularSearches }
      }, router.RouterMode.Single)
    }
  }

  //搜索商品列表页面
  export function toSearchListPage(searchKey: string) {
    router.pushUrl({
      url: MyApp.getPageUrl(MyApp.Module.module_search, MyApp.Pages.searchListPage),
      params: { keyword: searchKey }
    }, router.RouterMode.Single)
  }

  //商品详情页
  export function toCommodityDetailPage(commodityId: string) {
    router.pushUrl({
      url: MyApp.getPageUrl(MyApp.Module.module_classify, MyApp.Pages.commodityDetailPage),
      params: {
        commodityId: commodityId
      }
    });
  }

  //购物车
  export function toCartPage() {
    router.pushUrl({
      url: MyApp.getPageUrl(MyApp.Module.module_shopping_cart, MyApp.Pages.shoppingCartPage),
      params: {
        isTabPage: false,
      }
    });
  }

}