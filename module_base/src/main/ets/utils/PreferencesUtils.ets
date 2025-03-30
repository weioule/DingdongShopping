import preferences from '@ohos.data.preferences';
import { MyApp } from '../common/Application';

/**
 * @author weioule
 * @date 2025-02-23
 */
export namespace PreferencesKey {
  export const searchRecordsLocallyKey: string = "search_records_locally"; //本地搜索记录
}

type BasicType = null | number | string | boolean;
type ValueType = BasicType | Array<number> | Array<string> | Array<boolean> | Map<String, BasicType>
  | Array<Map<String, BasicType>>;

export class PreferencesUtils {
  prefMap: Map<string, preferences.Preferences> = new Map()

  async loadPreferences(context: Context, name: string) {
    try {
      const pref = await preferences.getPreferences(context, name)
      this.prefMap.set(name, pref)
    } catch (e) {
    }
  }

  async save(key: string, value: preferences.ValueType, name: string = MyApp.AppUtil.bundleName) {
    if (!this.prefMap.has(name)) {
      return
    }
    try {
      const pref = this.prefMap.get(name)
      await pref?.put(key, value)
      await pref?.flush()
    } catch (e) {
    }
  }

  async get(key: string, defaultValue: ValueType, name: string = MyApp.AppUtil.bundleName): Promise<ValueType> {
    let result: ValueType = defaultValue ?? null;
    if (!this.prefMap.has(name)) {
      return result
    }

    try {
      const pref = this.prefMap.get(name);
      let value = await pref?.get(key, defaultValue)
      if (value != null) {
        result = value as ValueType;
      }

      return result;
    } catch (e) {
      return result
    }
  }

  async delete(name: string = MyApp.AppUtil.bundleName, key: string) {
    // 先判断是否存在该名称的键值对
    if (!this.prefMap.has(name)) {
    }
    try {
      const pref = this.prefMap.get(name)
      await pref?.delete(key)
    } catch (e) {
    }
  }
}

const preferenceUtils = new PreferencesUtils()

export default preferenceUtils as PreferencesUtils
