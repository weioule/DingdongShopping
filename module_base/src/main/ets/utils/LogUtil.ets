import hilog from '@ohos.hilog';

/**
 * @author weioule
 * @date 2025-02-02
 * 日志工具类
 */
const Log: string = "LogUtil";

type BasicType = null | number | string | boolean;
type InputType = null | number | string | boolean | Array<number> | Array<string> | Map<String, BasicType>
  | Array<Map<String, BasicType>>;

export namespace LogUtil {

  export function debug(format: string = '%{public}s', ...args: InputType[]): void {
    hilog.debug(0xFF00, Log, format, ...args);
  }

  export function info(format: string = '%{public}s', ...args: InputType[]): void {
    hilog.info(0xFF00, Log, format, ...args);
  }

  export function warn(format: string = '%{public}s', ...args: InputType[]): void {
    hilog.warn(0xFF00, Log, format, ...args);
  }

  export function error(format: string = '%{public}s', ...args: InputType[]): void {
    hilog.error(0xFF00, Log, format, ...args);
  }

  export function fatal(format: string = '%{public}s', ...args: InputType[]): void {
    hilog.fatal(0xFF00, Log, format, ...args);
  }

}
