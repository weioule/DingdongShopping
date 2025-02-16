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
 * limitations under the License.
 */
import { PullToRefreshConfigurator } from './MyPullToRefreshConfigurator';

const IS_FREE = 0;
const IS_PULL_DOWN_1 = 11;
const IS_PULL_DOWN_2 = 12;
const IS_REFRESHING = 2;
const IS_REFRESHED = 3;
const IS_PULL_UP_1 = 41;
const IS_PULL_UP_2 = 42;
const IS_LOADING = 5;

/**
 * @author weioule
 * @date 2025-02-01
 * 定制的下拉刷新组件
 */
@ComponentV2
export struct PullToRefresh {
  @Param refreshConfigurator?: PullToRefreshConfigurator = new PullToRefreshConfigurator();
  @Param data?: Object[] | undefined = undefined;
  @Param scroller: Scroller = new Scroller();
  @BuilderParam customList?: () => void;
  @Param mWidth?: Length = '100%';
  @Param mHeight?: Length = '100%';
  @Param refreshEnable?: boolean = true;
  @Param loadEnable?: boolean = true;
  @Param onRefresh?: () => Promise<string> = () => {
    return new Promise<string>((resolve, reject) => {
      setTimeout(() => {
        resolve('');
      }, 1000);
    });
  };
  @Param onLoadMore?: () => Promise<string> = () => {
    return new Promise<string>((resolve, reject) => {
      setTimeout(() => {
        resolve('');
      }, 1000);
    });
  };
  // 自定义下拉动画
  @BuilderParam customRefresh?: (() => void) | null;
  //开启自定义下拉动画
  @Param onAnimPullDown?: (value?: number, width?: number, height?: number) => void | undefined = undefined;
  @Param onAnimRefreshing?: (value?: number, width?: number, height?: number) => void | undefined = undefined;
  // 自定义上拉动画
  @BuilderParam customLoad?: (() => void) | null;
  @Param onAnimPullUp?: (value?: number, width?: number, height?: number) => void | undefined = undefined;
  @Param onAnimLoading?: (value?: number, width?: number, height?: number) => void | undefined = undefined;
  //-----------------------------以下为组件内自用属性-----------------------------//
  @Local private mHeightNumber?: number = 0;
  @Local private trYTop: number = 0;
  @Local private trYBottom?: number = 0;
  @Param state: number = IS_FREE;
  @Local private refreshText?: string = this.refreshConfigurator?.getRefreshTextPullUp1();
  @Local private loadText?: ResourceStr = this.refreshConfigurator?.getLoadTextPullUp1();
  @Local private angle1?: number | string = 0;
  @Local private angle2?: number | string = 180;
  @Local private angle3?: number | string = 0;
  @Local private angle4?: number | string = 0;
  private mWidthNumber?: number = 0;
  private touchYOld?: number = 0;
  private touchYNew?: number = 0;
  private listOffsetOld?: number = 0;
  private listOffsetNew?: number = 0;
  private value?: number = 0;
  private timer?: number;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Up | PanDirection.Down })
  @Event changeState: (state: number) => void

  aboutToAppear() {
  }

  build() {
    Column() {
      // 下拉刷新动画部分
      Column() {
        this.headerUI()
      }
      .width('100%')
      .height(this.trYTop !== undefined ? this.trYTop : 0)
      .visibility(this.trYTop !== undefined && this.trYTop > 0 ? Visibility.Visible : Visibility.Hidden)
      .backgroundColor(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getRefreshBackgroundColor() :
        0)

      // 主体列表部分
      Column() {
        if (this.customList !== undefined) {
          this.customList()
        }
      }
      .width('100%')
      .height((this.mHeightNumber !== undefined ? this.mHeightNumber : 0) -
        (this.trYTop !== undefined ? this.trYTop : 0)
        + (this.trYBottom !== undefined ? this.trYBottom : 0))

      // 上拉加载动画部分
      Stack() {
        this.footerUI()
      }
      .width('100%')
      //始终保持显示内容的最小高度=30，icon和文本居中显示
      .height(this.trYBottom !== undefined ? -this.trYBottom + (this.trYBottom > -30 ? 30 + this.trYBottom : 0) : 0)
      .backgroundColor(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadBackgroundColor() :
        0)
    }
    .width(this.mWidth === undefined ? '100%' : this.mWidth)
    .height(this.mHeight === undefined ? '100%' : this.mHeight)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.mWidthNumber = Math.round(newValue.width as number);
      this.mHeightNumber = Math.round(newValue.height as number);
    })
    .parallelGesture(
      PanGesture(this.panOption)
        .onActionStart((event?: GestureEvent) => {
          if (event !== undefined) {
            this.touchYOld = event.offsetY;
          }
        })
        .onActionUpdate((event?: GestureEvent) => {
          if (event !== undefined) {
            this.onActionUpdate(event);
          }
        })
        .onActionEnd(() => {
          this.onActionEnd();
        })
    )
  }

  @Builder
  private headerUI() {
    if (this.customRefresh !== undefined && this.customRefresh !== null) {
      Column() {
        this.customRefresh()
      }
      .width('100%')
      .height('100%')
    } else {
      Column() {
        Row() {
          Stack() {
            Image($r('app.media.icon_up'))
              .width(20)
              .height(this.trYTop != undefined && this.trYTop > 0 ? 20 : 0)//高度控制，否则外层父控件隐藏的情况下也会展示
              .objectFit(ImageFit.Contain)
              .visibility(this.state != IS_REFRESHING && this.state != IS_REFRESHED ? Visibility.Visible :
              Visibility.Hidden)
              .rotate({
                z: 1,
                angle: this.angle2 !== undefined ? this.angle2 : 0
              })

            Image($r('app.media.icon_load'))
              .width(20)
              .height(20)
              .objectFit(ImageFit.Contain)
              .visibility(this.state == IS_REFRESHING ? Visibility.Visible : Visibility.Hidden)
              .rotate({
                z: 1,
                angle: this.angle4 !== undefined ? this.angle4 : 0
              })
          }
          .width(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadImgHeight() : 0)
          .height(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadImgHeight() : 0)

          Text(this.refreshText)
            .height('100%')
            .textAlign(TextAlign.Center)
            .margin({ left: 5 })
            .fontColor(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadTextColor() : 0)
            .fontSize(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadTextSize() : 0)
            .height(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getRefreshHeight() : 0)
        }
        //始终保持显示内容的最小高度=30，icon和文本居中显示
        .height(this.trYTop !== undefined ? this.trYTop - (this.trYTop < 30 ? this.trYTop - 30 : 0) : 0)

      }
      .backgroundColor(this.refreshConfigurator?.getRefreshContentBgColor())
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  private footerUI() {
    if (this.customLoad !== undefined && this.customLoad !== null) {
      Column() {
        this.customLoad()
      }
      .width('100%')
      .height('100%')
    } else {
      Row() {
        Stack() {
          Image($r('app.media.icon_up'))
            .width(20)
            .height(this.trYBottom != undefined && this.trYBottom < 0 ? 20 : 0)//高度控制，否则外层父控件隐藏的情况下也会展示
            .objectFit(ImageFit.Contain)
            .visibility(this.state != IS_LOADING && this.state != IS_FREE ? Visibility.Visible : Visibility.Hidden)
            .rotate({
              z: 1,
              angle: this.angle1 !== undefined ? this.angle1 : 0
            })

          Image($r('app.media.icon_load'))
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
            .visibility(this.state == IS_LOADING ? Visibility.Visible : Visibility.Hidden)
            .rotate({
              z: 1,
              angle: this.angle3 !== undefined ? this.angle3 : 0
            })
        }
        .width(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadImgHeight() : 0)
        .height(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadImgHeight() : 0)

        Text(this.loadText)
          .height('100%')
          .textAlign(TextAlign.Center)
          .margin({ left: 5 })
          .fontColor(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadTextColor() : 0)
          .fontSize(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadTextSize() : 0)
          .height(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getRefreshHeight() : 0)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(this.refreshConfigurator?.getLoadContentBgColor())
    }
  }

  private onActionUpdate(event: GestureEvent): void {
    if (this.state !== undefined && this.refreshConfigurator !== undefined && this.touchYOld !== undefined) {
      if (this.state == IS_FREE ||
        this.state == IS_PULL_DOWN_1 || this.state == IS_PULL_DOWN_2 ||
        this.state == IS_PULL_UP_1 || this.state == IS_PULL_UP_2) {
        let maxTranslate = this.refreshConfigurator.getMaxTranslate()
        let loadImgHeight = this.refreshConfigurator.getLoadImgHeight()
        let refreshHeight = this.refreshConfigurator.getRefreshHeight()
        if (!this.scroller.currentOffset()) {
          return;
        }
        this.touchYNew = event.offsetY;

        // 当前手势是否下拉
        let distanceY = this.touchYNew - this.touchYOld;
        let isPullAction = distanceY > 0;

        //兼容页面滑动到顶部时，this.scroller.currentOffset().yOffset返回0.000000....的浮点数的情况
        let yOffset: number = this.scroller.currentOffset().yOffset;
        let isTop: boolean = yOffset == 0 ? true : false;
        if (yOffset > -0.0001 && yOffset < 0.001) {
          isTop = true;
        }

        if ((this.state == IS_FREE && isTop && isPullAction) || // 处于自由状态且列表处于顶部位置 并且 当前手势是下拉手势
          this.state == IS_PULL_DOWN_1 || this.state == IS_PULL_DOWN_2) { // 处于下拉状态中
          if (this.refreshEnable == true) {
            if (this.touchYOld !== undefined && refreshHeight !== undefined) {
              // 获取最新位移距离
              let trY = this.touchYNew - this.touchYOld;

              //防止下拉回滑时list组件底层跟着滑动
              if (trY < 0) {
                this.scroller.scrollTo({ xOffset: 0, yOffset: 0 })
              }

              // 计算当前需要位移的总距离
              this.trYTop = this.getTranslateYOfRefresh(trY);
              if (this.trYTop < refreshHeight) {
                this.changeState(IS_PULL_DOWN_1);
              } else {
                this.changeState(IS_PULL_DOWN_2);
              }
              // 如果没有自定义刷新动画，就执行内置动画下拉时的逻辑
              if (!this.customRefresh && maxTranslate !== undefined) {
                this.drawRefreshView(true, this.trYTop / maxTranslate);
              }
              // 如果有下拉中动画回调，就执行下拉中动画回调
              if (this.onAnimPullDown && maxTranslate !== undefined) {
                this.onAnimPullDown(this.trYTop / maxTranslate, this.mWidthNumber, this.trYTop);
              }
            }
          }
        } else if (this.loadEnable) {
          this.listOffsetNew = this.scroller.currentOffset().yOffset;
          // 列表处于底部位置且上滑时，2.已上滑时
          try {
            if (this.touchYOld !== undefined) {
              //注释掉this.listOffsetOld != 0，支持内容不满一屏时也可以上拉
              if ((this.state == IS_FREE && this.listOffsetOld == this.listOffsetNew && /*this.listOffsetOld != 0 &&*/
                this.touchYNew < this.touchYOld && this.scroller.isAtEnd()) ||
                this.state == IS_PULL_UP_1 || this.state == IS_PULL_UP_2) {
                // 获取最新的位移距离
                let trY = this.touchYNew - this.touchYOld;
                // 计算当前需要位移的总距离
                this.trYBottom = this.getTranslateYOfLoadMore(trY);
                if (loadImgHeight !== undefined && this.trYBottom > -loadImgHeight) {
                  this.changeState(IS_PULL_UP_1);
                } else {
                  this.changeState(IS_PULL_UP_2);
                }
                // 如果没有自定义加载更多动画，就执行内置动画上拉时的逻辑
                if (!this.customLoad && maxTranslate !== undefined) {
                  this.drawLoadView(true, -this.trYBottom / maxTranslate);
                }
                // 如果有上拉中动画回调，就执行上拉中动画回调
                if (this.onAnimPullUp) {
                  if (this.trYBottom !== undefined && maxTranslate !== undefined) {
                    this.onAnimPullUp(-this.trYBottom / maxTranslate, this.mWidthNumber, -this.trYBottom);
                  }
                }
              }
            }
          } catch (error) {
            if (this.touchYOld !== undefined) {
              if ((this.state == IS_FREE && this.listOffsetOld == this.listOffsetNew /*&& this.listOffsetOld != 0*/ &&
                this.touchYNew < this.touchYOld) ||
                this.state == IS_PULL_UP_1 || this.state == IS_PULL_UP_2) {
                if (this.touchYNew !== undefined && this.touchYOld !== undefined && loadImgHeight !== undefined) {
                  // 获取最新的位移距离
                  let trY = this.touchYNew - this.touchYOld;
                  // 计算当前需要位移的总距离
                  this.trYBottom = this.getTranslateYOfLoadMore(trY);
                  if (this.trYBottom > -loadImgHeight) {
                    this.changeState(IS_PULL_UP_1);
                  } else {
                    this.changeState(IS_PULL_UP_2);
                  }
                }
              }
            }
          }
          this.listOffsetOld = this.listOffsetNew;
        }
        this.touchYOld = this.touchYNew;
      }
    }
  }

  private onActionEnd(): void {
    if (this.refreshConfigurator !== undefined) {
      let maxTranslate = this.refreshConfigurator.getMaxTranslate()
      let refreshAnimDuration = this.refreshConfigurator.getRefreshAnimDuration();
      if (this.refreshConfigurator.getListIsPlacement()) {
        if (this.state !== undefined) {
          if (this.state == IS_PULL_DOWN_1 || this.state == IS_PULL_DOWN_2) {
            // 让列表归位到顶部
            this.scroller.scrollEdge(Edge.Top);
          } else if (this.state == IS_PULL_UP_1 || this.state == IS_PULL_UP_2) {
            // 让列表归位到底部
            this.scroller.scrollEdge(Edge.Bottom);
          }
        }
      }
      if (this.trYTop !== undefined) {
        if (this.trYTop > 0) { // 下拉结束
          if (this.state !== undefined && maxTranslate !== undefined) {
            if (this.state == IS_FREE || this.state == IS_PULL_DOWN_1 || this.state == IS_PULL_DOWN_2) {
              if (this.trYTop / maxTranslate < 0.7) {
                this.closeRefresh();
              } else {
                this.changeState(IS_REFRESHING);
                //抬手后回弹
                animateTo({ duration: 150 * (this.trYTop / maxTranslate) }, () => {
                  this.trYTop = maxTranslate!! * 0.7;
                });

                clearInterval(this.timer);
                this.timer = setInterval(() => {
                  if (this.value !== undefined) {
                    if (this.value >= 1) {
                      this.value -= 1;
                    } else {
                      if (refreshAnimDuration !== undefined && refreshAnimDuration !== 0) {
                        this.value += 10 / refreshAnimDuration;
                      }
                    }
                    // 保留3位小数
                    this.value = Math.round(this.value * 1000) / 1000;
                    // 如果没有自定义加载中动画，就执行内置加载中动画
                    if (!this.customRefresh) {
                      this.drawRefreshView(false, this.value);
                    }
                  }
                  //显示加载中动画
                  if (this.onAnimRefreshing) {
                    this.onAnimRefreshing(this.value, this.mWidthNumber, this.trYTop);
                  }
                }, 10);
                if (this.onRefresh !== undefined) {
                  this.onRefresh().then((refreshText) => {
                    //停止刷新中动画
                    setTimeout(() => {
                      if (refreshText.length == 0) {
                        this.closeRefresh();
                      } else {
                        //停止加载中动画
                        clearInterval(this.timer);
                        this.changeState(IS_REFRESHED);

                        if (!this.customRefresh) {
                          //显示刷新结果文案
                          this.refreshText = refreshText;
                        }
                        setTimeout(() => {
                          //定时结束刷新，用于期间显示刷新结果提示文案
                          this.closeRefresh();
                        }, this.refreshConfigurator?.getRefreshCompleteTextHoldTime());
                      }
                    }, this.refreshText == this.refreshConfigurator?.getRefreshTextLoading() ? 0 : 300)
                  });
                }
              }
            }
          }
        } else if (this.trYBottom !== undefined && this.trYBottom < 0) { // 上拉结束
          if (this.state !== undefined && maxTranslate !== undefined) {
            if (this.state == IS_FREE || this.state == IS_PULL_UP_1 || this.state == IS_PULL_UP_2) {
              if (-this.trYBottom / maxTranslate < 0.7) {
                this.closeLoad();
              } else {
                this.changeState(IS_LOADING);
                //抬手后回弹
                animateTo({ duration: 150 * (-this.trYBottom / maxTranslate) }, () => {
                  this.trYBottom = -maxTranslate!! * 0.7;
                });
                clearInterval(this.timer);
                this.timer = setInterval(() => {
                  if (this.value !== undefined) {
                    if (this.value >= 1) {
                      this.value -= 1;
                    } else {
                      this.value += 0.01;
                    }
                    // 保留2位小数
                    this.value = Math.round(this.value * 100) / 100;
                    // 如果没有自定义加载中动画，就执行内置加载中动画
                    if (!this.customLoad) {
                      this.drawLoadView(false, this.value);
                    }
                  }
                  // 如果有加载中动画回调，就执行加载中动画回调
                  if (this.onAnimLoading) {
                    if (this.trYBottom !== undefined) {
                      this.onAnimLoading(this.value, this.mWidthNumber, -this.trYBottom);
                    }
                  }
                }, 10);

                if (this.onLoadMore !== undefined) {
                  this.onLoadMore().then((loadText) => {
                    //停止加载中动画
                    setTimeout(() => {
                      if (loadText.length == 0) {
                        this.closeLoad();
                      } else {
                        //停止加载中动画
                        clearInterval(this.timer);
                        this.changeState(IS_FREE);
                        if (!this.customLoad) {
                          //更新提示文案
                          this.loadText = loadText;
                        }
                        setTimeout(() => {
                          this.closeLoad();
                        }, this.refreshConfigurator?.getRefreshCompleteTextHoldTime());
                      }
                    }, this.refreshText == this.refreshConfigurator?.getRefreshTextLoading() ? 0 : 300)
                  });
                }
              }
            }
          }
        } else {
          this.changeState(IS_FREE);
        }
      }
    }
  }

  private drawRefreshView(isPullDown: boolean, value: number): void {
    if (isPullDown) {
      if (this.refreshConfigurator !== undefined && this.trYTop !== undefined) {
        let refreshHeight = this.refreshConfigurator.getRefreshHeight()
        if (refreshHeight !== undefined && this.trYTop >= refreshHeight) {
          value = value >= 0.7 ? 0.7 : value;
          this.refreshText = value >= 0.7 ? this.refreshConfigurator?.getRefreshTextPullUp2() :
          this.refreshConfigurator?.getRefreshTextPullUp1()
          this.angle2 = value >= 0.7 ? 0 : 180
        }
      }
    } else {
      this.angle4 = value * 360;
      if (this.refreshConfigurator !== undefined && this.state == IS_REFRESHING) {
        this.refreshText = this.refreshConfigurator?.getRefreshTextLoading()
      }
    }
  }

  private drawLoadView(isPullUp: boolean, value: number): void {
    if (isPullUp) {
      if (this.refreshConfigurator !== undefined) {
        let loadImgHeight = this.refreshConfigurator.getLoadImgHeight()
        if (loadImgHeight !== undefined && this.trYBottom !== undefined) {
          if (this.trYBottom <= -loadImgHeight) {
            if (value < 0.7) {
              this.angle1 = 0;
              if (this.refreshConfigurator !== undefined) {
                this.loadText = this.refreshConfigurator?.getLoadTextPullUp1();
              }
            } else {
              this.angle1 = 180;
              if (this.refreshConfigurator !== undefined) {
                this.loadText = this.refreshConfigurator?.getLoadTextPullUp2();
              }
            }
          }
        }
      }
    } else {
      this.angle3 = value * 360;
      if (this.refreshConfigurator !== undefined && this.state == IS_LOADING) {
        this.loadText = this.refreshConfigurator?.getLoadTextLoading();
        ;
      }
    }
  }

  public closeRefresh(): void {
    clearInterval(this.timer);
    this.timer = setInterval(() => {
      if (this.trYTop !== undefined && this.trYTop > 0) {
        if (this.trYTop >= 3) {
          this.trYTop -= 3;
        } else {
          this.trYTop = 0
        }
      } else {
        clearInterval(this.timer);
        this.changeState(IS_FREE);
        this.trYTop = 0;
        this.angle2 = 180;
        this.angle4 = 0;
        this.refreshText = this.refreshConfigurator?.getRefreshTextPullUp1();
        ;
      }
    }, 5);
  }

  public closeLoad(): void {
    clearInterval(this.timer);
    this.timer = setInterval(() => {
      if (this.trYBottom !== undefined && this.trYBottom < 0) {
        if (this.trYBottom <= -3) {
          this.trYBottom += 3;
        } else {
          this.trYBottom = 0
        }
      } else {
        clearInterval(this.timer);
        this.changeState(IS_FREE);
        this.trYBottom = 0;
        this.angle1 = 0;
        this.angle3 = 0;
        this.loadText = this.refreshConfigurator?.getLoadTextPullUp1();
      }
    }, 5);
  }

  private getTranslateYOfRefresh(newTranslateY: number): number {
    if (this.refreshConfigurator !== undefined) {
      let maxTranslateY = this.refreshConfigurator.getMaxTranslate();
      let sensitivity = this.refreshConfigurator.getSensitivity();
      if (maxTranslateY !== undefined && sensitivity !== undefined && this.trYTop !== undefined) {
        // 阻尼值计算
        if (this.trYTop / maxTranslateY < 0.2) {
          newTranslateY = newTranslateY * 1 * sensitivity;
        } else if (this.trYTop / maxTranslateY < 0.4) {
          newTranslateY = newTranslateY * 0.8 * sensitivity;
        } else if (this.trYTop / maxTranslateY < 0.6) {
          newTranslateY = newTranslateY * 0.6 * sensitivity;
        } else if (this.trYTop / maxTranslateY < 0.8) {
          newTranslateY = newTranslateY * 0.4 * sensitivity;
        } else {
          newTranslateY = newTranslateY * 0.2 * sensitivity;
        }
        // 下拉值计算
        if (this.trYTop + newTranslateY > maxTranslateY) {
          return maxTranslateY;
        } else if (this.trYTop + newTranslateY < 0) {
          return 0;
        } else {
          return this.trYTop + newTranslateY;
        }
      }
    }
    return 0;
  }

  private getTranslateYOfLoadMore(newTranslateY: number): number {
    if (this.refreshConfigurator !== undefined) {
      let maxTranslateY = this.refreshConfigurator.getMaxTranslate();
      let sensitivity = this.refreshConfigurator.getSensitivity();
      if (maxTranslateY !== undefined && sensitivity !== undefined && this.trYBottom !== undefined) {
        // 阻尼值计算
        if (this.trYBottom / maxTranslateY > -0.2) {
          newTranslateY = newTranslateY * 1 * sensitivity;
        } else if (this.trYBottom / maxTranslateY > -0.4) {
          newTranslateY = newTranslateY * 0.8 * sensitivity;
        } else if (this.trYBottom / maxTranslateY > -0.6) {
          newTranslateY = newTranslateY * 0.6 * sensitivity;
        } else if (this.trYBottom / maxTranslateY > -0.8) {
          newTranslateY = newTranslateY * 0.4 * sensitivity;
        } else {
          newTranslateY = newTranslateY * 0.2 * sensitivity;
        }
        // 上拉值计算
        if (this.trYBottom + newTranslateY < -maxTranslateY) {
          return -maxTranslateY;
        } else if (this.trYBottom + newTranslateY > 0) {
          return 0;
        } else {
          return this.trYBottom + newTranslateY;
        }
      }
    }
    return 0;
  }
}