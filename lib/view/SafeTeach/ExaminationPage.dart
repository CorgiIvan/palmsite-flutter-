import 'package:flutter/material.dart';
import '../../model/ExamModel.dart';
import 'dart:convert';
import 'ExaminationItem.dart';
import '../../model/TeachExamModel.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../UI/LoadingWidget.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import '../../utils/HttpGo.dart';
import '../../cookie/cookie.dart';

class examinationPage extends StatefulWidget {
  State<StatefulWidget> createState() => _examinationState();
}

class _examinationState extends State<examinationPage>
    with WidgetsBindingObserver {
  TeachExamModel examModel;
  bool isGet = true;
  int page = 1; //获取的页数

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

  var _futurebuilder;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ///用_futureBuilderFuture来保存_gerData()的结果，以避免不必要的ui重绘
    _futurebuilder = HttpGo().post("/ss/api.teach_exam/find.html", (data) {
      setState(() {
        examModel = TeachExamModel.fromJson(data);
      });
    }, params: FormData.from({'page': 1}));
    startTime();
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

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {
    Response response;
    page = 1;
    FormData formData1 = FormData.from({'page': page});
    try {
      response = await HttpGo()
          .dio
          .post("/ss/api.teach_exam/find.html", data: formData1);
      setState(() {
        examModel = TeachExamModel.fromJson(response.data);
        print(examModel);
        HttpGo().showToast('刷新成功');
      });
    } on DioError catch (e) {
      HttpGo().showToast('刷新失败');
    }
  }

  /**
   * 上拉增加,为list重新赋值
   */
  Future<Null> _getdata() async {
    Response response;
    page += 1;
    FormData formData1 = FormData.from({'page': page});
    try {
      response = await HttpGo()
          .dio
          .post("/ss/api.teach_case/find.html", data: formData1);
      setState(() {
        TeachExamModel examModel2 = TeachExamModel.fromJson(response.data);
        examModel.data += examModel2.data;
        print(examModel2);
        HttpGo().showToast('加载成功');
      });
    } on DioError catch (e) {
      HttpGo().showToast('加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    final listView = Center(
        child: FutureBuilder(
            future: _futurebuilder,
            builder: (context, snapshot) {
              if (examModel == null) {
                if (isGet) {
                  return LoadingWidget().childWidget();
                } else {
                  return LoadingWidget().defeatWidget();
                }
              } else {
                return Refresh(
                  onHeaderRefresh: _onRefresh,
                  onFooterRefresh: _getdata,
                  child: ListView.builder(
                      itemCount: examModel.data.length,
                      itemBuilder: (context, item) {
                        return ExaminationItem(
                          id: examModel.data[item].id,
                          quesiotn: examModel.data[item].topic,
                          answer: examModel.data[item].answer,
                        );
                      }),
                );
              }
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text('考试题库'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listView,
    );
  }
}
