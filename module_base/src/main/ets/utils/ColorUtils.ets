/**
 * @author weioule
 * @date 2025-10-18
 */
export interface RgbColor {
  r: number;
  g: number;
  b: number;
}

export class ColorUtils {
  /**
   * 颜色渐变（从颜色A到颜色B）
   * @param colorA 起始颜色
   * @param colorB 结束颜色
   * @param ratio 渐变比例 0-1
   */
  static colorGradient(colorA: string, colorB: string, ratio: number): string {
    const rgbA = ColorUtils.parseColor(colorA);
    const rgbB = ColorUtils.parseColor(colorB);

    if (!rgbA || !rgbB) {
      console.error('Invalid color format');
      return colorA;
    }

    const r = Math.round(rgbA.r + (rgbB.r - rgbA.r) * ratio);
    const g = Math.round(rgbA.g + (rgbB.g - rgbA.g) * ratio);
    const b = Math.round(rgbA.b + (rgbB.b - rgbA.b) * ratio);

    return `rgb(${r},${g},${b})`;
  }

  /**
   * 生成颜色渐变数组（用于线性渐变）
   * @param color 目标颜色
   * @param steps 渐变步数
   */
  static generateGradientSteps(color: string, steps: number = 10): string[] {
    const gradient: string[] = [];
    for (let i = 0; i < steps; i++) {
      const ratio = i / (steps - 1);
      gradient.push(ColorUtils.transparentToColor(color, ratio));
    }
    return gradient;
  }

  /**
   * 生成透明到指定颜色的渐变值
   */
  static transparentToColor(color: string, ratio: number): string {
    if (ratio <= 0) {
      return 'rgba(0,0,0,0)';
    }

    if (ratio >= 1) {
      return color;
    }

    const rgb = ColorUtils.parseColor(color);
    if (!rgb) {
      console.error('Invalid color format:', color);
      return 'rgba(0,0,0,0)';
    }

    return `rgba(${rgb.r},${rgb.g},${rgb.b},${ratio})`;
  }

  /**
   * 解析颜色字符串为 RGB 对象
   */
  private static parseColor(color: string): RgbColor | null {
    color = color.trim();

    if (color.startsWith('#')) {
      return ColorUtils.parseHexColor(color);
    }

    if (color.startsWith('rgb(')) {
      return ColorUtils.parseRgbColor(color);
    }

    if (color.startsWith('rgba(')) {
      return ColorUtils.parseRgbaColor(color);
    }

    return null;
  }

  private static parseHexColor(hex: string): RgbColor | null {
    hex = hex.replace('#', '');

    let r = 0, g = 0, b = 0;

    if (hex.length === 3) {
      r = parseInt(hex[0] + hex[0], 16);
      g = parseInt(hex[1] + hex[1], 16);
      b = parseInt(hex[2] + hex[2], 16);
    } else if (hex.length === 6) {
      r = parseInt(hex.substring(0, 2), 16);
      g = parseInt(hex.substring(2, 4), 16);
      b = parseInt(hex.substring(4, 6), 16);
    } else if (hex.length === 8) {
      r = parseInt(hex.substring(0, 2), 16);
      g = parseInt(hex.substring(2, 4), 16);
      b = parseInt(hex.substring(4, 6), 16);
    } else {
      return null;
    }

    // 直接返回对象字面量
    return { r, g, b };
  }

  private static parseRgbColor(rgb: string): RgbColor | null {
    const match = rgb.match(/rgb\((\d+),\s*(\d+),\s*(\d+)\)/);
    if (match) {
      // 直接返回对象字面量
      return {
        r: parseInt(match[1]),
        g: parseInt(match[2]),
        b: parseInt(match[3])
      };
    }
    return null;
  }

  private static parseRgbaColor(rgba: string): RgbColor | null {
    const match = rgba.match(/rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)/);
    if (match) {
      // 直接返回对象字面量
      return {
        r: parseInt(match[1]),
        g: parseInt(match[2]),
        b: parseInt(match[3])
      };
    }
    return null;
  }
}