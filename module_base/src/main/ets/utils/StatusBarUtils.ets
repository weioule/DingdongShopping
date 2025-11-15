import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

/**
 * 状态栏内容颜色枚举
 */
export enum StatusBarContentColor {
  WHITE = 'white',
  BLACK = 'black'
}

/**
 * 状态栏工具类
 * @author weioule
 * @date 2025-10-19
 */
export class StatusBarUtils {
  private static readonly TAG: string = 'StatusBarUtils';

  /**
   * 获取窗口实例
   */
  private static async getWindow(context: common.UIAbilityContext): Promise<window.Window> {
    try {
      const windowClass: window.Window = await window.getLastWindow(context);
      return windowClass;
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: getWindow failed, code: ${businessError.code}, message: ${businessError.message}`);
      throw new Error(`Get window failed: ${businessError.message}`);
    }
  }

  /**
   * 设置状态栏文字（图标）颜色
   * @param context UIAbilityContext
   * @param contentColor 文字颜色
   */
  static async setStatusBarTextColor(context: common.UIAbilityContext, contentColor: StatusBarContentColor): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);

      // 获取当前状态栏属性，保留背景色只修改文字颜色
      const currentProperties = await windowClass.getWindowSystemBarProperties();

      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: currentProperties.statusBarColor,
        isStatusBarLightIcon: contentColor === StatusBarContentColor.WHITE
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);
      console.info(`${StatusBarUtils.TAG}: setStatusBarTextColor success, text color: ${contentColor}`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setStatusBarTextColor failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 仅设置状态栏文字为白色
   * @param context UIAbilityContext
   */
  static async setStatusBarTextWhite(context: common.UIAbilityContext): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);

      const currentProperties = await windowClass.getWindowSystemBarProperties();

      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: currentProperties.statusBarColor,
        isStatusBarLightIcon: true
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);
      console.info(`${StatusBarUtils.TAG}: setStatusBarTextWhite success`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setStatusBarTextWhite failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 仅设置状态栏文字为黑色
   * @param context UIAbilityContext
   */
  static async setStatusBarTextBlack(context: common.UIAbilityContext): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);

      const currentProperties = await windowClass.getWindowSystemBarProperties();

      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: currentProperties.statusBarColor,
        isStatusBarLightIcon: false
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);
      console.info(`${StatusBarUtils.TAG}: setStatusBarTextBlack success`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setStatusBarTextBlack failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 设置状态栏内容颜色（包含背景色和文字颜色）
   * @param context UIAbilityContext
   * @param contentColor 内容颜色
   */
  static async setStatusBarContentColor(context: common.UIAbilityContext, contentColor: StatusBarContentColor): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);

      // 根据内容颜色设置状态栏属性
      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: contentColor === StatusBarContentColor.WHITE ? '#000000' : '#FFFFFF',
        isStatusBarLightIcon: contentColor === StatusBarContentColor.WHITE
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);
      console.info(`${StatusBarUtils.TAG}: setStatusBarContentColor success, color: ${contentColor}`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setStatusBarContentColor failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 设置状态栏样式（内容颜色 + 背景色）
   * @param context UIAbilityContext
   * @param contentColor 内容颜色
   * @param backgroundColor 背景颜色
   */
  static async setStatusBarStyle(
    context: common.UIAbilityContext,
    contentColor: StatusBarContentColor,
    backgroundColor: string
  ): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: backgroundColor,
        isStatusBarLightIcon: contentColor === StatusBarContentColor.WHITE
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);
      console.info(`${StatusBarUtils.TAG}: setStatusBarStyle success, contentColor: ${contentColor}, backgroundColor: ${backgroundColor}`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setStatusBarStyle failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 设置透明状态栏
   * @param context UIAbilityContext
   * @param contentColor 内容颜色
   */
  static async setTransparentStatusBar(context: common.UIAbilityContext, contentColor: StatusBarContentColor): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: '#00000000', // 完全透明
        isStatusBarLightIcon: contentColor === StatusBarContentColor.WHITE
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);
      console.info(`${StatusBarUtils.TAG}: setTransparentStatusBar success, contentColor: ${contentColor}`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setTransparentStatusBar failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 设置沉浸式状态栏（内容延伸到状态栏）
   * @param context UIAbilityContext
   * @param contentColor 内容颜色
   */
  static async setImmersiveStatusBar(context: common.UIAbilityContext, contentColor: StatusBarContentColor): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);

      // 设置状态栏属性
      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: '#00000000', // 透明背景
        isStatusBarLightIcon: contentColor === StatusBarContentColor.WHITE
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);

      // 设置窗口布局，允许内容延伸到状态栏
      await windowClass.setWindowLayoutFullScreen(true);

      console.info(`${StatusBarUtils.TAG}: setImmersiveStatusBar success`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setImmersiveStatusBar failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 隐藏状态栏
   * @param context UIAbilityContext
   */
  static async hideStatusBar(context: common.UIAbilityContext): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const systemBarEnable: Array<'status' | 'navigation'> = ['navigation'];
      await windowClass.setWindowSystemBarEnable(systemBarEnable);
      console.info(`${StatusBarUtils.TAG}: hideStatusBar success`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: hideStatusBar failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 显示状态栏
   * @param context UIAbilityContext
   */
  static async showStatusBar(context: common.UIAbilityContext): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const systemBarEnable: Array<'status' | 'navigation'> = ['status', 'navigation'];
      await windowClass.setWindowSystemBarEnable(systemBarEnable);
      console.info(`${StatusBarUtils.TAG}: showStatusBar success`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: showStatusBar failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 重置状态栏为默认样式
   * @param context UIAbilityContext
   */
  static async resetStatusBar(context: common.UIAbilityContext): Promise<void> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: '#000000',
        isStatusBarLightIcon: true // 白色图标
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);

      const systemBarEnable: Array<'status' | 'navigation'> = ['status', 'navigation'];
      await windowClass.setWindowSystemBarEnable(systemBarEnable);
      console.info(`${StatusBarUtils.TAG}: resetStatusBar success`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: resetStatusBar failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 根据背景色自动选择状态栏内容颜色
   * @param context UIAbilityContext
   * @param backgroundColor 背景颜色
   */
  static async setStatusBarAutoColor(context: common.UIAbilityContext, backgroundColor: string): Promise<void> {
    try {
      const isDarkBackground = StatusBarUtils.isDarkColor(backgroundColor);
      const contentColor = isDarkBackground ? StatusBarContentColor.WHITE : StatusBarContentColor.BLACK;

      await StatusBarUtils.setStatusBarStyle(context, contentColor, backgroundColor);
      console.info(`${StatusBarUtils.TAG}: setStatusBarAutoColor success, backgroundColor: ${backgroundColor}, contentColor: ${contentColor}`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setStatusBarAutoColor failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 根据背景色自动选择状态栏文字颜色
   * @param context UIAbilityContext
   * @param backgroundColor 背景颜色
   */
  static async setStatusBarTextAutoColor(context: common.UIAbilityContext, backgroundColor: string): Promise<void> {
    try {
      const isDarkBackground = StatusBarUtils.isDarkColor(backgroundColor);
      const contentColor = isDarkBackground ? StatusBarContentColor.WHITE : StatusBarContentColor.BLACK;

      await StatusBarUtils.setStatusBarTextColor(context, contentColor);
      console.info(`${StatusBarUtils.TAG}: setStatusBarTextAutoColor success, backgroundColor: ${backgroundColor}, text color: ${contentColor}`);
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: setStatusBarTextAutoColor failed, code: ${businessError.code}, message: ${businessError.message}`);
    }
  }

  /**
   * 切换状态栏文字颜色（白色/黑色切换）
   * @param context UIAbilityContext
   */
  static async toggleStatusBarTextColor(context: common.UIAbilityContext): Promise<StatusBarContentColor> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const currentProperties = await windowClass.getWindowSystemBarProperties();

      const newTextColor = currentProperties.isStatusBarLightIcon ? StatusBarContentColor.BLACK : StatusBarContentColor.WHITE;

      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: currentProperties.statusBarColor,
        isStatusBarLightIcon: !currentProperties.isStatusBarLightIcon
      };

      await windowClass.setWindowSystemBarProperties(systemBarProperties);
      console.info(`${StatusBarUtils.TAG}: toggleStatusBarTextColor success, new color: ${newTextColor}`);

      return newTextColor;
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: toggleStatusBarTextColor failed, code: ${businessError.code}, message: ${businessError.message}`);
      return StatusBarContentColor.WHITE;
    }
  }

  /**
   * 获取当前状态栏文字颜色
   * @param context UIAbilityContext
   */
  static async getStatusBarTextColor(context: common.UIAbilityContext): Promise<StatusBarContentColor> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const properties = await windowClass.getWindowSystemBarProperties();
      const textColor = properties.isStatusBarLightIcon ? StatusBarContentColor.WHITE : StatusBarContentColor.BLACK;

      console.info(`${StatusBarUtils.TAG}: getStatusBarTextColor success, current color: ${textColor}`);
      return textColor;
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: getStatusBarTextColor failed, code: ${businessError.code}, message: ${businessError.message}`);
      return StatusBarContentColor.WHITE;
    }
  }

  /**
   * 判断颜色是否为深色
   * @param color 颜色值
   * @returns 是否为深色
   */
  private static isDarkColor(color: string): boolean {
    // 移除 # 号
    let hex = color.replace('#', '');

    // 处理缩写形式
    if (hex.length === 3) {
      hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }

    // 确保是6位十六进制
    if (hex.length !== 6) {
      return true; // 默认返回深色
    }

    // 解析 RGB 值
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    // 计算亮度 (使用加权公式)
    const brightness = (r * 299 + g * 587 + b * 114) / 1000;

    return brightness < 128;
  }

  /**
   * 获取当前状态栏信息
   * @param context UIAbilityContext
   */
  static async getStatusBarInfo(context: common.UIAbilityContext): Promise<window.SystemBarProperties> {
    try {
      const windowClass = await StatusBarUtils.getWindow(context);
      const properties = await windowClass.getWindowSystemBarProperties();
      console.info(`${StatusBarUtils.TAG}: getStatusBarInfo success`);
      return properties;
    } catch (error) {
      const businessError = error as BusinessError;
      console.error(`${StatusBarUtils.TAG}: getStatusBarInfo failed, code: ${businessError.code}, message: ${businessError.message}`);
      // 返回符合 SystemBarProperties 接口的默认对象
      const defaultProperties: window.SystemBarProperties = {
        statusBarColor: '#000000',
        isStatusBarLightIcon: true
      };
      return defaultProperties;
    }
  }
}