/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitati
 * ons under the License.
 */

/**
 * @author weioule
 * @date 2025-02-01
 * 定制的下拉刷新组件配置器
 */
export class PullToRefreshConfigurator {
  private hasRefresh?: boolean = true; // 是否具有下拉刷新功能
  private hasLoadMore?: boolean = true; // 是否具有上拉加载功能
  private maxTranslate?: number = 100; // 可下拉上拉的最大距离
  private sensitivity?: number = 0.7; // 下拉上拉灵敏度
  private listIsPlacement?: boolean = true; // 滑动结束后列表是否归位
  private animDuration?: number = 150; // 滑动结束后，回弹动画执行时间
  private refreshHeight?: number = 30; // 下拉动画高度
  private refreshBackgroundColor?: ResourceColor = 'rgba(0,0,0,0)'; // 下拉动画区域背景色
  private refreshContentBgColor?: ResourceColor = '#F0F0F0'; // 下拉内容区域背景色
  private refreshTextColor?: ResourceColor = '#999999'; // 下拉加载完毕后提示文本的字体颜色
  private refreshTextSize?: number | string | Resource = 18; // 下拉加载完毕后提示文本的字体大小
  private refreshAnimDuration?: number = 1000; // 下拉动画执行一次的时间
  private refreshCompleteTextHoldTime?: number = 700; //下拉刷新完毕后, 刷新成功文本停留的时间
  private loadImgHeight?: number = 30; // 上拉图片高度
  private loadBackgroundColor?: ResourceColor = 'rgba(0,0,0,0)'; // 上拉动画区域背景色
  private loadContentBgColor?: ResourceColor = '#F0F0F0'; // 上拉内容区域背景色
  private loadTextColor?: ResourceColor = '#999999'; // 上拉文本的字体颜色
  private loadTextSize?: number | string | Resource = 18; // 上拉文本的字体大小
  private refreshTextPullUp1?: string = '下拉刷新...'; // 上拉1阶段文本
  private refreshTextPullUp2?: string = '释放刷新'; // 上拉2阶段文本
  private refreshTextLoading?: string = '正在加载中...'; // 上拉加载更多中时的文本
  private loadTextPullUp1?: string = '上拉刷新...'; // 上拉1阶段文本
  private loadTextPullUp2?: string = '释放刷新'; // 上拉2阶段文本
  private loadTextLoading?: string = '正在加载中...'; // 上拉加载更多中时的文本

  setHasRefresh(hasRefresh: boolean) {
    this.hasRefresh = hasRefresh;
    return this;
  }

  getHasRefresh() {
    return this.hasRefresh;
  }

  setHasLoadMore(hasLoadMore: boolean) {
    this.hasLoadMore = hasLoadMore;
    return this;
  }

  getHasLoadMore() {
    return this.hasLoadMore;
  }

  setMaxTranslate(maxTranslate: number) {
    this.maxTranslate = maxTranslate;
    return this;
  }

  getMaxTranslate() {
    return this.maxTranslate;
  }

  setSensitivity(sensitivity: number) {
    this.sensitivity = sensitivity;
    return this;
  }

  getSensitivity() {
    return this.sensitivity;
  }

  setListIsPlacement(listIsPlacement: boolean) {
    this.listIsPlacement = listIsPlacement;
    return this;
  }

  getListIsPlacement() {
    return this.listIsPlacement;
  }

  setAnimDuration(animDuration: number) {
    this.animDuration = animDuration;
    return this;
  }

  getAnimDuration() {
    return this.animDuration;
  }

  setRefreshCompleteTextHoldTime(refreshCompleteTextHoldTime: number) {
    this.refreshCompleteTextHoldTime = refreshCompleteTextHoldTime;
    return this;
  }

  getRefreshCompleteTextHoldTime(): number {
    return this.refreshCompleteTextHoldTime !== undefined ? this.refreshCompleteTextHoldTime : 700;
  }

  getRefreshWidth(): number {
    if (this.refreshHeight !== undefined) {
      return this.refreshHeight / 3 * 4;
    }
    return 0;
  }

  setRefreshHeight(refreshHeight: number) {
    this.refreshHeight = refreshHeight;
    return this;
  }

  getRefreshHeight(): number {
    return this.refreshHeight !== undefined ? this.refreshHeight : 0;
  }

  setRefreshBackgroundColor(refreshBackgroundColor: ResourceColor) {
    this.refreshBackgroundColor = refreshBackgroundColor;
    return this;
  }

  getRefreshBackgroundColor(): ResourceColor {
    return this.refreshBackgroundColor !== undefined ? this.refreshBackgroundColor : 0;
  }

  setRefreshContentBgColor(refreshContentBgColor: ResourceColor) {
    this.refreshContentBgColor = refreshContentBgColor;
    return this;
  }

  getRefreshContentBgColor(): ResourceColor {
    return this.refreshContentBgColor !== undefined ? this.refreshContentBgColor : 0;
  }

  setRefreshTextColor(refreshTextColor: ResourceColor) {
    this.refreshTextColor = refreshTextColor;
    return this;
  }

  getRefreshTextColor(): ResourceColor {
    return this.refreshTextColor !== undefined ? this.refreshTextColor : 0;
  }

  setRefreshTextSize(refreshTextSize: number | string | Resource) {
    this.refreshTextSize = refreshTextSize;
    return this;
  }

  getRefreshTextSize(): number | string | Resource {
    return this.refreshTextSize !== undefined ? this.refreshTextSize : 0;
  }

  setRefreshAnimDuration(refreshAnimDuration: number) {
    this.refreshAnimDuration = refreshAnimDuration;
    return this;
  }

  getRefreshAnimDuration() {
    return this.refreshAnimDuration;
  }

  setLoadImgHeight(loadImgHeight: number) {
    this.loadImgHeight = loadImgHeight;
    return this;
  }

  getLoadImgHeight(): number {
    return this.loadImgHeight !== undefined ? this.loadImgHeight : 0;
  }

  setLoadBackgroundColor(loadBackgroundColor: ResourceColor) {
    this.loadBackgroundColor = loadBackgroundColor;
    return this;
  }

  getLoadBackgroundColor(): ResourceColor {
    if (this.loadBackgroundColor !== undefined) {
      return this.loadBackgroundColor;
    }
    return 0;
  }

  setLoadContentBgColor(loadContentBgColor: ResourceColor) {
    this.loadContentBgColor = loadContentBgColor;
    return this;
  }

  getLoadContentBgColor(): ResourceColor {
    if (this.loadContentBgColor !== undefined) {
      return this.loadContentBgColor;
    }
    return 0;
  }

  setLoadTextColor(loadTextColor: ResourceColor) {
    this.loadTextColor = loadTextColor;
    return this;
  }

  getLoadTextColor(): ResourceColor {
    if (this.loadTextColor !== undefined) {
      return this.loadTextColor;
    }
    return 0;
  }

  setLoadTextSize(loadTextSize: number | string | Resource) {
    this.loadTextSize = loadTextSize;
    return this;
  }

  getLoadTextSize(): number | string | Resource {
    if (this.loadTextSize !== undefined) {
      return this.loadTextSize;
    }
    return 0;
  }

  setRefreshTextPullUp1(refreshTextPullUp1: string) {
    this.refreshTextPullUp1 = refreshTextPullUp1;
    return this;
  }

  getRefreshTextPullUp1() {
    return this.refreshTextPullUp1;
  }

  setRefreshTextPullUp2(refreshTextPullUp2: string) {
    this.refreshTextPullUp2 = refreshTextPullUp2;
    return this;
  }

  getRefreshTextPullUp2() {
    return this.refreshTextPullUp2;
  }

  setRefreshTextLoading(refreshTextLoading: string) {
    this.refreshTextLoading = refreshTextLoading;
    return this;
  }

  getRefreshTextLoading(): string {
    return this.refreshTextLoading !== undefined ? this.refreshTextLoading : "";
  }

  setLoadTextPullUp1(loadTextPullUp1: string) {
    this.loadTextPullUp1 = loadTextPullUp1;
    return this;
  }

  getLoadTextPullUp1() {
    return this.loadTextPullUp1;
  }

  setLoadTextPullUp2(loadTextPullUp2: string) {
    this.loadTextPullUp2 = loadTextPullUp2;
    return this;
  }

  getLoadTextPullUp2() {
    return this.loadTextPullUp2;
  }

  setLoadTextLoading(loadTextLoading: string) {
    this.loadTextLoading = loadTextLoading;
    return this;
  }

  getLoadTextLoading(): string {
    return this.loadTextLoading !== undefined ? this.loadTextLoading : "";
  }
}