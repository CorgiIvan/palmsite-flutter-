import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/FuckingDioUtil.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:dio/dio.dart';
import '../../utils/HttpGo.dart';


class StudyCaseDetail extends StatefulWidget {
  StudyCaseDetail(this.id, this.title, this.name, this.ctime, this.browse_count,
      this.content, this.avator);
  final int id;
  final String title;
  final String name;
  final String ctime;
  final int browse_count;
  final String content;
  final String avator;

  @override
  _StudyCaseState createState() => _StudyCaseState();
}

class _StudyCaseState extends State<StudyCaseDetail>
    with WidgetsBindingObserver {
  /**
   * 计时器，用来记录今日学习时长
   */
  int time = 0;
  Timer _timer;
  var prefix = "data:image/jpeg;base64,";
  String strings;
  String imgsrcPrefix;
  String url;
  String WorkURL;

  /**
   * 开始计时
   */
  void startTime() {
    print('开始计时');
    _timer = new Timer.periodic(const Duration(seconds: 1), (timer) {
      time++;
      print(time);
    });
  }

  /**
   * 停止计时
   */
  void stopTime() {
    print('停止计时');
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startTime();
    HttpGo().post('/ss/api.teach_case/count', (data){},params: FormData.from({'id': widget.id}));
    _ContentCompile();
  }
  /**
   * 从拿到的content中提取图片
   */
  _ContentCompile() {
    strings = HtmlUnescape().convert(widget.content);
    imgsrcPrefix = "<img src=";
    url = HttpGo.URL;
    WorkURL = strings;
    for (int i = 0; i < WorkURL.length - imgsrcPrefix.length; i++) {
      if ((WorkURL.substring(i, i + imgsrcPrefix.length)) == imgsrcPrefix) {
        WorkURL = WorkURL.substring(0, i + imgsrcPrefix.length + 1) +
            url +
            WorkURL.substring(i + imgsrcPrefix.length + 1, WorkURL.length);
      }
    }
  }

  @override
  void dispose() {
    HttpGo().post('/ss/api.learn_assess/count', (data) {},
        params: FormData.from({'today_time': time}));
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();

    super.dispose();
  }

  AppLifecycleState _lastLifecyleState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      print(state);
      if (state == AppLifecycleState.paused) {
        stopTime();
      } else if (state == AppLifecycleState.resumed) {
        startTime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: ListView(
              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.only(bottom: 6.0),
//                  child: Center(
//                      child: Text(
//                    widget.title,
//                    style: TextStyle(fontSize: 20.0),
//                  )),
//                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Image.memory(
                              base64.decode(
                                  widget.avator.substring(prefix.length)),
                              height: 50,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                  widget.ctime +
                                      '   ' +
                                      widget.browse_count.toString() +
                                      '浏览',
                                  style: TextStyle(fontSize: 15.0))
                            ],
                          )
                        ],
                      ),
//                      Padding(
//                        padding: EdgeInsets.only(right: 12.0),
//                        child: Icon(Icons.favorite_border),
//                      )
                    ],
                  ),
                ),
//                Text(
//                  widget.content,
//                  softWrap: true,
//                  textAlign: TextAlign.left,
//                  style: TextStyle(fontSize: 16.0),
//                ),
                Html(data:WorkURL),
//                Center(
//                  child: Column(
//                    children: <Widget>[
//                      Padding(
//                          padding: EdgeInsets.all(6.0),
//                          child: Image.asset(
//                              'images/main/safecase/detail/z001.png')),
//                      Padding(
//                          padding: EdgeInsets.all(6.0),
//                          child: Image.asset(
//                              'images/main/safecase/detail/z002.png')),
//                      Padding(
//                          padding: EdgeInsets.all(6.0),
//                          child: Image.asset(
//                              'images/main/safecase/detail/z003.png')),
//                      Padding(
//                          padding: EdgeInsets.all(6.0),
//                          child: Image.asset(
//                              'images/main/safecase/detail/z004.png')),
//                      Padding(
//                          padding: EdgeInsets.all(6.0),
//                          child: Image.asset(
//                              'images/main/safecase/detail/z005.png')),
//                      Padding(
//                          padding: EdgeInsets.all(6.0),
//                          child: Image.asset(
//                              'images/main/safecase/detail/z006.png')),
//                      Padding(
//                          padding: EdgeInsets.all(6.0),
//                          child: Image.asset(
//                              'images/main/safecase/detail/z007.png'))
//                    ],
//                  ),
//                )
              ],
            ),
          ),
        ));
  }
}
