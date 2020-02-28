import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/FuckingDioUtil.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../utils/HttpGo.dart';
import 'package:dio/dio.dart';

class knowledgeDetail extends StatefulWidget {
  knowledgeDetail(this.id, this.title, this.content, this.browse_count,
      this.classify, this.name, this.ctime, this.avator);
  final int id;
  final String title;
  final String content;
  final int browse_count;
  final String classify;
  final String name;
  final String ctime;
  final String avator;

  @override
  _knowledgeDetailState createState() => _knowledgeDetailState();
}

class _knowledgeDetailState extends State<knowledgeDetail>
    with WidgetsBindingObserver {
  /**
   * 计时器，用来记录今日学习时长
   */
  int time = 0;
  Timer _timer;
  var prefix;
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
//      setState(() {
      time++;
      print(time);
//      });
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
    print('启动initState');
    WidgetsBinding.instance.addObserver(this);
    prefix = "data:image/jpeg;base64,";
    startTime();
    HttpGo().post('/ss/api.teach_know/count', (data){},params: FormData.from({'id': widget.id}));
    _ContentCompile();
  }

  /**
   * 拿到的content
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

  /**
   * 销毁时候的操作
   */
  @override
  void dispose() {
    HttpGo().post('/ss/api.learn_assess/count', (data) {},
        params: FormData.from({'today_time': time}));
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
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

  /**
   * 构建树
   */
  @override
  Widget build(BuildContext context) {
    print("调试一下:" + strings.indexOf(imgsrcPrefix).toString());
    print("尝试一下构建新的字符串" + WorkURL);
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
//                    style: TextStyle(fontSize: 18.0),
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
                Html(data: WorkURL),
                Padding(
                  padding: EdgeInsets.only(top: 35.0),
                  child: Row(
                    children: <Widget>[
                      Text('相关标签    '),
                      Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              border:
                                  Border.all(width: 1.0, color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 6.0, right: 6.0),
                              child: Text(
                                widget.classify,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
