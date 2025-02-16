import { router } from '@kit.ArkUI';
import { MyApp } from './Application';

/**
 * @author weioule
 * @date 2025-02-02
 * 路由
 */
export namespace AppRouter {

  //搜索关键字页面
  export function toSearchPage() {
    router.pushUrl({
      url: MyApp.getPageUrl(MyApp.Module.module_search, MyApp.Pages.searchCommodityPage),
    }, router.RouterMode.Single)
  }

  // 普通商品详情页
  export function toCommodityDetailPage(commodityId: string) {
    router.pushUrl({
      url: MyApp.getPageUrl(MyApp.Module.module_classify, MyApp.Pages.commodityDetailPage),
      params: {
        commodityId: commodityId
      }
    });
  }

}