import { window } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'

/**
 * @author weioule
 * @date 2025-02-09
 * 公共弹框
 */
export class CommonDialog {
  static show(attributes: DialogAttributes) {
    DialogWindowProvider.instance().show(attributes)
  }

  static dismiss(complete?: (() => void)) {
    DialogWindowProvider.instance().dismiss(complete)
  }
}

class DialogWindowProvider {
  private static windowProvider: DialogWindowProvider
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  windowName: string = "DialogEntryWindow"

  static instance() {
    if (!DialogWindowProvider.windowProvider) {
      DialogWindowProvider.windowProvider = new DialogWindowProvider();
    }
    return DialogWindowProvider.windowProvider;
  }

  show(attribute: DialogAttributes) {
    let windowClass: window.Window
    window.createWindow({
      name: this.windowName,
      windowType: window.WindowType.TYPE_DIALOG,
      ctx: this.context
    }, (err, data) => {
      if (err.code == 0) {
        windowClass = data
        windowClass.setWindowLayoutFullScreen(true)
        let storage: LocalStorage = new LocalStorage()
        storage.setOrCreate('attribute', attribute)
        windowClass.loadContent('pages/CommonDialogPage', storage, err => {
          if (err.code == 0) {
            windowClass.setWindowBackgroundColor('#11000000')
          }
        })
        windowClass.showWindow(() => {
        })
      }
    })
  }

  dismiss(complete?: (() => void)) {
    window.findWindow(this.windowName).destroyWindow((err, e) => {
      if (err.code == 0 && complete) {
        complete()
      }
    })
  }
}

export class DialogAttributes {
  msg: string = ''
  title: string = '提示'
  confirm: string = '确认'
  cancel: string = '取消'
  onCancelClick?: () => void
  onConfirmClick?: () => void
}

