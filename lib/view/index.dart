import 'package:flutter/material.dart';
import 'home_page.dart';
import 'MyPage.dart';
import 'ServicePage.dart';

class NavigationIconView {
  // 创建两个属性，一个是 用来展示 icon， 一个是动画处理
  final BottomNavigationBarItem item;
  final AnimationController controller;

  // 类似于 java 中的构造方法
  // 创建 NavigationIconView 需要传入三个参数， icon 图标，title 标题， TickerProvider
  NavigationIconView({Widget icon, Widget title, TickerProvider vsync})
      : item = new BottomNavigationBarItem(
          icon: icon,
          title: title,
        ),
        controller = new AnimationController(
            duration: kThemeAnimationDuration, // 设置动画持续的时间
            vsync: vsync // 默认属性和参数
            );
}

class index extends StatefulWidget {
  State<StatefulWidget> createState() => new _IndexState();
}

class _IndexState extends State<index> with TickerProviderStateMixin {
  int _currentIndex = 0; // 当前界面的索引值
  List<NavigationIconView> _navigationViews; // 底部图标按钮区域
  List<StatefulWidget> _pageList; // 用来存放我们的图标对应的页面
  StatefulWidget _currentPage;

  void _rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 将我们 bottomBar 上面的按钮图标对应的页面存放起来，方便我们在点击的时候
    _pageList = <StatefulWidget>[HomePage(), MyPage(), ServicePage()];
    _currentPage = _pageList[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    // 初始化导航图标
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: Image.asset(
            (_currentIndex == 0)
                ? 'images/main/Fragment_icon/sy_c@3x.png'
                : 'images/main/Fragment_icon/sy_n.png',
            height: 20.0,
            width: 20.0,
          ),
          title: Text("首页",
              style: TextStyle(
                  color: (_currentIndex == 0) ? Colors.blue : Colors.black)),
          vsync: this), // vsync 默认属性和参数
      new NavigationIconView(
          icon: Image.asset(
            (_currentIndex == 1)
                ? 'images/main/Fragment_icon/wd_c@3x.png'
                : 'images/main/Fragment_icon/wd_n@3x.png',
            height: 20.0,
            width: 20.0,
          ),
          title: new Text("我的",
              style: TextStyle(
                  color: (_currentIndex == 1) ? Colors.blue : Colors.black)),
          vsync: this),
      new NavigationIconView(
          icon: Image.asset(
            (_currentIndex == 2)
                ? 'images/main/Fragment_icon/ff_c@3x.png'
                : 'images/main/Fragment_icon/ff_n@3x.png',
            height: 20.0,
            width: 20.0,
          ),
          title: new Text("服务",
              style: TextStyle(
                  color: (_currentIndex == 2) ? Colors.blue : Colors.black)),
          vsync: this)
    ];

    // 给每一个按钮区域加上监听
    for (NavigationIconView view in _navigationViews) {
//      view.controller.addListener(_rebuild);
    }

    // 声明定义一个 底部导航的工具栏
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationIconView) =>
              navigationIconView.item)
          .toList(), // 添加 icon 按钮
      currentIndex: _currentIndex, // 当前点击的索引值
      type: BottomNavigationBarType.fixed, // 设置底部导航工具栏的类型：fixed 固定
      onTap: (int index) {
        // 添加点击事件
        setState(() {
          // 点击之后，需要触发的逻辑事件
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
          _currentPage = _pageList[_currentIndex];
        });
      },
    );

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pageList,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}