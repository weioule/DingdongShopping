import { common } from '@kit.AbilityKit';
import display from '@ohos.display';
import deviceInfo from '@ohos.deviceInfo';
import bundleManager from '@ohos.bundle.bundleManager';
import { PullToRefreshConfigurator } from '../refresh/MyPullToRefreshConfigurator';
import PreferencesUtils from '../utils/PreferencesUtils';

/**
 * @author weioule
 * @date 2025-02-01
 * Application
 */
export namespace MyApp {

  export class AppUtil {
    static declare bundleName: string; //包名：com.weioule.hmos
    static declare projectName: string; //项目名称
    static declare versionName: string; //版本号
    static declare versionCode: number; //版本code

    static declare isDebug: boolean;
    static declare appId: string;
    static declare appIdentifier: string;
    static declare context: common.UIAbilityContext;

    static async setup(context: common.UIAbilityContext) {
      AppUtil.context = context;
      await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO)
        .then((bundleInfo) => {
          AppUtil.bundleName = bundleInfo.name;
          let parts = AppUtil.bundleName.split(".");
          AppUtil.projectName = parts[parts.length - 1];
          AppUtil.versionName = bundleInfo.versionName;
          AppUtil.versionCode = bundleInfo.versionCode;

          //isDebug: 判断 AppUtil 是否是 Debug 模式
          let appProvisionType = bundleInfo.appInfo.appProvisionType;
          if (appProvisionType === "debug") {
            AppUtil.isDebug = true;
          }

          AppUtil.appId = bundleInfo.signatureInfo.appId;
          AppUtil.appIdentifier = bundleInfo.signatureInfo.appIdentifier;
        });

      // 初始化preference
      PreferencesUtils.loadPreferences(context, AppUtil.bundleName)
    }
  }


  export class Device {
    static readonly systemVersion: string = deviceInfo.osFullName; //OpenHarmony-5.0.1.110
    static readonly type: string = deviceInfo.deviceType; //phone
    static readonly brand: string = deviceInfo.brand; //HUAWEI
    static readonly model: string = deviceInfo.marketName; //HUAWEI Pura 70


    /*
    设备唯一Id, 使用 deviceInfo.ODID: 开发者匿名设备标识符。不能使用 deviceInfo.serial、 deviceInfo.udid; 原因: Udid(deviceInfo.udid)、设备序列号(deviceInfo.serial) 需要ohos.permission.sec.ACCESS_UDID权限才能获取, 该权限为系统权限, 仅对系统应用开放.

    * ODID值会在以下场景重新生成：
    1、手机恢复出厂设置。
    2、同一设备上同一个开发者的应用全部卸载后重新安装时。

    ODID生成规则：
    同一设备上运行的同一个开发者的应用，ODID相同。
    同一个设备上不同开发者的应用，ODID不同。
    不同设备上同一个开发者的应用，ODID不同。
    不同设备上不同开发者的应用，ODID不同。
     */

    static readonly deviceId: string = deviceInfo.ODID;
  }


  export class Screen {
    static readonly breakPoints: Array<string> = ['320vp', '600vp', '840vp'];
    static readonly pixelWidth: number = display.getDefaultDisplaySync().width;
    static readonly pixelHeight: number = display.getDefaultDisplaySync().height;
    static readonly width: number = px2vp(Screen.pixelWidth);
    static readonly height: number = px2vp(Screen.pixelHeight);
  }


  export class Font {
    // 单位: fp
    static readonly descTextSize: number = 12; //描述
    static readonly smallTextSize: number = 10; //小文字
    static readonly minimumTextSize: number = 7; //最小文字
  }


  export class Size {
    // 单位: vp
    static readonly screenWidth = Screen.width; //屏幕宽
    static readonly screenHeight = Screen.height; //屏幕高
    static statusBar: number = 36; //状态栏高度 (初始设置为36, 可能用不着, onWindowStageCreate 后获取到 StatusBar 的真实高度。)
    static readonly naviBar: number = 44; //导航栏高度
    static readonly safeArea: number = 24; //底部安全区域高
  }


  export namespace Refresh {

    export const height: number = MyApp.Size.statusBar;

    export function configurator(): PullToRefreshConfigurator {
      let configurator = new PullToRefreshConfigurator();
      configurator.setHasRefresh(true);
      configurator.setHasLoadMore(false);
      configurator.setRefreshHeight(Refresh.height);
      configurator.setRefreshBackgroundColor($r('app.color.white'));
      configurator.setRefreshContentBgColor($r('app.color.white'));
      configurator.setRefreshTextColor($r('app.color.txt_color_999'));
      configurator.setLoadContentBgColor($r('app.color.white'));
      configurator.setLoadTextColor($r('app.color.txt_color_999'));
      configurator.setRefreshTextSize(MyApp.Font.descTextSize);
      configurator.setLoadTextSize(MyApp.Font.descTextSize);
      return configurator;
    }
  }


  export function getPageUrl(moduleName: string, pageName: string): string {
    return `@bundle:${MyApp.AppUtil.bundleName}/${moduleName}/ets/${pageName}`;
  }


  export class Module {
    static readonly module_classify: string = 'module_classify';
    static readonly module_search: string = 'module_search';
    static readonly module_shopping_cart: string = 'module_shopping_cart';
  }


  export class Pages {
    //ClassifyModule
    static readonly classifyPage: string = 'pages/ClassifyPage';
    static readonly commodityDetailPage: string = 'pages/CommodityDetailPage';
    //SearchModule
    static readonly popularSearchesPage: string = 'pages/PopularSearchesPage';
    static readonly searchListPage: string = 'pages/SearchListPage';
    //CartModule
    static readonly shoppingCartPage: string = 'pages/ShoppingCartPage';
  }
}
