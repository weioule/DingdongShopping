/**
 * @author weioule
 * @date 2025-02-02
 * 金额工具类
 */
export namespace MoneyUtils {
  export function formattedAmount(amount: number) {
    if (amount == 0) {
      return '0.00'
    }
    return amount.toLocaleString("zh-CN", {
      style: "currency",
      currency: "CNY",
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).replace('¥', '');
  }
}

