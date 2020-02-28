import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/TeachAssessModel.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../UI/LoadingWidget.dart';
import 'dart:convert';
import '../../utils/HttpGo.dart';

class StudyEvaluationPage extends StatefulWidget {
  State<StatefulWidget> createState() => _StudyEvaluationState();
}

class _StudyEvaluationState extends State<StudyEvaluationPage> {
  var _List = List();
  var _List2 = List();
  var _List3 = List();
  TeachAssessModel teachAssessModel;
  bool isGet = true;
  var prefix = "data:image/jpeg;base64,";
  var _futurebuilder;

  @override
  void initState() {
    super.initState();
    _List = ['今日学习时常', '总学习时长', '评测正确率', '考试正确率', '考试及格率'];
    _List3 = [
      'images/main/studyevaluation/a_jrxxsc@3x.png',
      'images/main/studyevaluation/a_lzsj@3x.png',
      'images/main/studyevaluation/a_pczql@3x.png',
      'images/main/studyevaluation/a_kszql@3x.png',
      'images/main/studyevaluation/a_ksjgl@3x.png'
    ];
    _futurebuilder = HttpGo().post("/ss/api.learn_assess/find_", (data) {
      setState(() {
        teachAssessModel = TeachAssessModel.fromJson(data);
        _List2 = [
          teachAssessModel.data[0].today_time.toString(),
          teachAssessModel.data[0].total_time.toString(),
          (teachAssessModel.data[0].grade * 100).toString() + '%',
          (teachAssessModel.data[0].accuracy * 100).toString() + '%',
          (teachAssessModel.data[0].pass * 100).toString() + "%"
        ];
      });
    },errorCallBack: (error){
      setState(() {
        isGet = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final listWidget = Container(
        child: FutureBuilder(
            future: _futurebuilder,
            builder: (context, snapshot) {
              if (teachAssessModel == null) {
                if (isGet) {
                  return LoadingWidget().childWidget();
                } else {
                  return LoadingWidget().defeatWidget();
                }
              } else {
                return ListView.builder(
                    itemCount: _List.length,
                    itemBuilder: (context, item) {
                      if (item == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                  height: 100,
                                  decoration: new BoxDecoration(
                                    gradient: new LinearGradient(
                                      begin: const Alignment(-1.0, 0.0),
                                      end: const Alignment(0.6, 0.0),
                                      colors: <Color>[
                                        const Color(0xff67b1CC),
                                        const Color(0xff79CECB)
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 12.0, right: 12.0),
                                        //TODO 这里需要改成数据库里面的图片
                                        child: Image.memory(
                                          base64.decode(teachAssessModel
                                              .data[0].user.avatar
                                              .substring(prefix.length)),
                                          height: 70,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            teachAssessModel.data[0].user.name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                          Text(
                                              teachAssessModel
                                                  .data[0].user.mobile,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0))
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 0.2,
                                                color: Colors.black26)),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 6.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 150,
                                            child: Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  _List3[item],
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 6.0, right: 6.0),
                                                  child: Text(_List[item]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            _List2[item],
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        );
                      } else {
                        return Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 8.0, bottom: 8.0, right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.2, color: Colors.black26)),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 6.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 150,
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              _List3[item],
                                              height: 25,
                                              width: 25,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6.0, right: 6.0),
                                              child: Text(_List[item]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        _List2[item],
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      }
                    });
              }
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text('学习评估'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listWidget,
    );
  }
}
