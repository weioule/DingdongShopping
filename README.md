# DingdongShopping
这是一个原生鸿蒙版的仿叮咚买菜APP项目

鸿蒙Next发布至今已经有一年多的时间了，但有时候我们想要实现一些复杂的功能或者效果，在开发文档上查阅一些资料还是比较费时的，有可能还找不到我们想要的内容。而社会层面上分享的资料也比较有限，毕竟推出的时间相对安卓和苹果来说还是太短了，但一点也不妨碍大家学习鸿蒙的热情，因为鸿蒙生态大势已成，未来也会有更多的开发者相续分享出自己学习鸿蒙的一些技术与经验。

今天来说一说我在学习鸿蒙的时候遇到的一个小问题，在使用鸿蒙版PullToRefresh框架的时候发现当内容不满一屏时不能上拉加载更多，可能是我想要的效果特殊吧，在不满一屏的时候其实无需上拉。我根据源码定制了自己想要的效果，也是安卓版本的PullToRefresh用惯了，按照安卓的效果做了样式，也支持了内容不满一屏时可以上拉加载。

另外也仿着叮咚买菜搭了一个应用架子，并实现了分类页的效果，以及从上往下弹出的类似半模态转场弹框，后续有时间的时候再往里写一些其他的功能。

下面是分类页实现的效果动图：

![gif1](https://github.com/user-attachments/assets/45ac1ba6-9ed8-463e-90d5-1b45b6e3c6b6)


30/3.<br>
1.新增搜索商品功能<br>
2.分类页输入框新增热门搜索滚动组件

商品搜索功能有搜索关键字和搜索结果页两个页面，搜索关键字页面主要展示搜索记录、搜索推荐、搜索联想关键字。<br>
搜索结果页面比较复杂一些，它涉及到了List的吸顶并与下拉刷新PullToRefresh以及瀑布流WaterFlow的嵌套滚动处理，
瀑布流WaterFlow使用sections实现了单、多列布局并存的跨列布局分组效果。<br><br>
基本实现了叮咚买菜苹果版app的商品搜索功能，目前他们的鸿蒙原生app的商品搜索功能还是比较粗糙的，还没有实现苹果版的效果，当然也有可能是原本就设计如此。<br><br>
下面看下效果图：

![img-ezgif com-resize](https://github.com/user-attachments/assets/4fa7cd76-5eac-4425-b0f8-a6fe8daf0522)

github有时不稳定，若动图打不开的话，可以到简书上看效果：<br>
https://www.jianshu.com/p/86b08aba8d60



