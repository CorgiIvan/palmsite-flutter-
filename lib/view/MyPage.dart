import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../UI/HeaderWidget.dart';
import '../cookie/cookie.dart';

class MyPage extends StatefulWidget {
  State<StatefulWidget> createState() => _MyState();
}

class _MyState extends State<MyPage> {
  var encoded1;
  Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final listWidget = Container(
      child: ListView(
        children: <Widget>[
          HeaderWidget().head(),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.black26),
                color: Colors.white),
            child: InkWell(
              onTap: () {
                cookie().initUser();
                Navigator.pushNamedAndRemoveUntil(
                    context, 'loginRoute', (route) => route == null);
              },
              child: ListTile(
                  leading: Image.asset(
                    'images/main/a_sz@3x.png',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('退出登录'),
                  trailing: Image.asset(
                    'images/main/a_fhw@3x.png',
                    height: 15,
                  )),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listWidget,
    );
  }
}
