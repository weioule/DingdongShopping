import { promptAction } from '@kit.ArkUI';

/**
 * @author weioule
 * @date 2025-02-02
 * Toast工具类
 */
export namespace ToastUtil {

  export function show(msg: string) {
    if (msg == null || msg.length == 0) {
      return;
    }
    promptAction.showToast({
      message: msg,
      duration: 1500,
      bottom: 56,
      showMode: 0,
      textColor: Color.White,
      backgroundColor: 'rgba(0, 0, 0, 0.6)',
      backgroundBlurStyle: BlurStyle.NONE
    })
  }
}
