import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starfish/route/route_path.dart';

///路由注册管理类
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //首页tab
      case RoutePath.tab:
        return pageRoute(const TabPage(), settings: settings);
      //资讯分类页
      case RoutePath.newsTypePage:
        return pageRoute(const NewsTypePage(), settings: settings);
      //登录页
      case RoutePath.auth:
        return pageRoute(const AuthPage(), settings: settings);
      //房源明细页
      case RoutePath.houseResourceDetailPage:
        return pageRoute(const HouseResDetailPage(), settings: settings);
      //品牌公寓页面
      case RoutePath.apartmentPage:
        return pageRoute(const ApartmentPage(), settings: settings);
      //房源预定页
      case RoutePath.subscribeHousePage:
        return pageRoute(SubscribeHousePage(), settings: settings);
      //房源收藏页
      case RoutePath.myCollectHousePage:
        return pageRoute(MyCollectHousePage(), settings: settings);
      //资讯收藏页
      case RoutePath.myCollectNewsPage:
        return pageRoute(MyCollectNewsPage(), settings: settings);
      //关于我们
      case RoutePath.aboutUsPage:
        return pageRoute(AboutUsPage(), settings: settings);
      //反馈页面
      case RoutePath.feedbackPage:
        return pageRoute(FeedbackPage(), settings: settings);
      //设置页面
      case RoutePath.settingsPage:
        return pageRoute(SettingsPage(), settings: settings);
      //扫码页面
      case RoutePath.scanPage:
        return pageRoute(ScanPage(), settings: settings);
      //消息通知页面
      case RoutePath.messagePage:
        return pageRoute(MessagePage(), settings: settings);
      //IM会话页面
      case RoutePath.conversationPage:
        return pageRoute(ConversationPage(), settings: settings);
    }
    return MaterialPageRoute(
        builder: (context) =>
            Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))));
  }

  static MaterialPageRoute pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
        builder: (context) => page,
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}
