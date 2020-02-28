import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '../../utils/FuckingDioUtil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:dio/dio.dart';
import '../../utils/HttpGo.dart';

class StudyOnlineDetail extends StatefulWidget {
  final int id;
  final String title;
  final String intro;
  StudyOnlineDetail(this.id, this.title, this.intro);

  State<StatefulWidget> createState() => _StudyOnlineDetailState();
}

class _StudyOnlineDetailState extends State<StudyOnlineDetail>
    with WidgetsBindingObserver {
  File files;
  VideoPlayerController _controller;
  VoidCallback listener;
  String strings;
  String imgsrcPrefix;
  String url;
  String WorkURL;

  /**
   * 计时器，用来记录今日学习时长
   */
  int time = 0;
  Timer _timer;

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
    print('启动initState');
    listener = () {
      setState(() {});
    };
    HttpGo().post('/ss/api.teach_video/count', (data) {},
        params: FormData.from({'id': widget.id}));
    WidgetsBinding.instance.addObserver(this);
    startTime();
    _ContentCompile();
  }

  /**
   * 从拿到的content
   */
  _ContentCompile() {
    strings = HtmlUnescape().convert(widget.intro);
    imgsrcPrefix = "<img src=";
    url = HttpGo.URL;
    WorkURL = strings;
    for (int i = 0; i < WorkURL.length - imgsrcPrefix.length; i++) {
      if ((WorkURL.substring(i, i + imgsrcPrefix.length)) == imgsrcPrefix) {
        print('1111111111');
        WorkURL = WorkURL.substring(0, i + imgsrcPrefix.length + 1) +
            url +
            WorkURL.substring(i + imgsrcPrefix.length + 1, WorkURL.length);
      }
    }
    print(WorkURL);
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
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final TitleText = Center(
        child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Text(
        widget.title,
        style: TextStyle(fontSize: 16.0),
      ),
    ));

    final Introduction = Container(
        child: Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
//      child: Text(
//        widget.intro,
//        style: TextStyle(fontSize: 15.0),
//      ),
      child: Html(data: WorkURL),
    ));

    final InputText = Container(
        child: Padding(
          padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.message),
                border: InputBorder.none,
                hintText: '发表你的感受'),
            autofocus: false,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
        ),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 0.2))));

    final CommentArea = Container(
        child: Padding(
          padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person_pin_circle),
                    Text('  XX')
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '老师讲的很好',
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 0.2))));

    final testWidget = FutureBuilder(
        future: _appDocumentsDirectory(), builder: _buildDirectory);

    final listView = Padding(
      padding: EdgeInsets.all(6.0),
      child: ListView(
        children: <Widget>[
//          TitleText,
          testWidget,
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                '————— 视频简介 —————',
                style: TextStyle(color: Colors.blue, fontSize: 16.0),
              ),
            ),
          ),
          Introduction,
//          InputText,
//          CommentArea,
//          CommentArea
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listView,
    );
  }

  Future<Directory> _appDocumentsDirectory() async {
    return getExternalStorageDirectory();
  }

  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<Directory> snapshot) {
    return Chewie(_controller = VideoPlayerController.asset("video/video.mp4"),
        aspectRatio: 3 / 2, autoPlay: false, looping: false);
  }
}
