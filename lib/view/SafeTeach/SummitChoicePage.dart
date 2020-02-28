import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palm_sitt_for_flutter/utils/navigateUtil.dart';
import 'SummitExamPage.dart';
import 'SummitWrongPage.dart';
import 'SummitTextPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../model/TeachOnlineModel.dart';
import '../../UI/LoadingDialog.dart';
import '../../model/TeachResultModel.dart';
import '../../utils/HttpGo.dart';

class SummitExamChoicePage extends StatefulWidget {
  State<StatefulWidget> createState() => _SummitExamChoice();
}

class _SummitExamChoice extends State<SummitExamChoicePage> {
  var _List = List();
  var _ListPic = List();
  Teachonline teachonline;
  TeachResultBean teachResultBean;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final listWidget = ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: Colors.black26),
              color: Colors.white),
          child: ListTile(
            leading: Image.asset(
              _ListPic[0],
              height: 25,
              width: 25,
            ),
            title: Text(_List[0]),
            trailing: Image.asset(
              'images/main/a_fhw@3x.png',
              height: 15,
            ),
            onTap: () {
              /**
               * 先进行网络请求看是否有可以进行的考试
               */
              Map<String, dynamic> data = {
                'order': 'asc',
                'sort': 'stime',
                'status': 1
              };
              FormData formdataText = FormData.from(data);
              showDialog<Null>(
                  context: context, //BuildContext对象
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return new LoadingDialog(
                      //调用对话框
                      text: '请稍等...',
                    );
                  });
              /**
               * 请求接口查看是否可以进行考试
               * 第一个请求查看是否有考试
               */
              HttpGo().post(
                  "/ss/api.teach_online/find.html",
                  (data) {
                    setState(() {
                      teachonline = Teachonline.fromJson(data);
                      // TODO 最好让后端写一个查询当前用户的考试结果，App调用还要在进行一步异步操作，这里直接传入了一个定值1
                      FormData formdata = FormData.from({
                        'teach_online_id': teachonline.data[0].id,
                        'user_id': 1
                      });
                      /**
                       * count>0 表示存在考试
                       */
                      if (teachonline.count > 0) {
                        /**
                         * 第二个接口查看是否存在考试结果，存在考试结果表明已经考试
                         */
                        HttpGo().post("/ss/api.teach_result/find", (data) {
                          teachResultBean = TeachResultBean.fromJson(data);
                          if (teachResultBean.count == 0) {
                            navigate().navigateToMain(
                                context,
                                SummitExamPage(teachonline.data[0].id,
                                    DateTime.now().millisecondsSinceEpoch));
                          } else {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: '已考试',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white);
                          }
                        }, errorCallBack: (error) {
                          Navigator.pop(context);
                        }, params: formdata);
                      } else {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: '暂无考试',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white);
                      }
                    });
                  },
                  params: formdataText,
                  errorCallBack: (error) {
                    Navigator.pop(context);
                  });
              /**
               * 原来的网络请求方法
               */
//              FuckingDioUtil()
//                  .postTwoNoMap1withCookie("/origin/api.user/login.html",
//                      "/ss/api.teach_online/find.html", data)
//                  .then((response) {
//                teachonline = Teachonline.fromJson(response.data);
//                Navigator.pop(context);
//                if (teachonline.count > 0) {
//                  FuckingDioUtil()
//                      .FindTeachResult(teachonline.data[0].id)
//                      .then((response) {
//                    teachResultBean = TeachResultBean.fromJson(response.data);
//                    if (teachResultBean.count == 0) {
//                      navigate().navigateToMain(
//                          context,
//                          SummitExamPage(teachonline.data[0].id,
//                              DateTime.now().millisecondsSinceEpoch));
//                    } else {
//                      Fluttertoast.showToast(
//                          msg: '已考试',
//                          toastLength: Toast.LENGTH_SHORT,
//                          gravity: ToastGravity.BOTTOM,
//                          timeInSecForIos: 1,
//                          backgroundColor: Colors.blue,
//                          textColor: Colors.white);
//                    }
//                  });
//                } else {
//                  Fluttertoast.showToast(
//                      msg: '暂无考试',
//                      toastLength: Toast.LENGTH_SHORT,
//                      gravity: ToastGravity.BOTTOM,
//                      timeInSecForIos: 1,
//                      backgroundColor: Colors.blue,
//                      textColor: Colors.white);
//                }
//              });
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: Colors.black26),
              color: Colors.white),
          child: ListTile(
            leading: Image.asset(
              _ListPic[1],
              height: 25,
              width: 25,
            ),
            title: Text(_List[1]),
            trailing: Image.asset(
              'images/main/a_fhw@3x.png',
              height: 15,
            ),
            onTap: () {
              navigate().navigateToMain(context, SummitWrongPage());
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey[300]),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                navigate().navigateToMain(context,
                    SummitTextPage(DateTime.now().millisecondsSinceEpoch));
              },
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black26, width: 0.2))),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'images/main/summitExam/a_jdpc@3x.png',
                              height: 20,
                              width: 20,
                            ),
                            Text('  阶段测评')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset(
                              'images/main/summitExam/a_dlan@3x.png',
                              width: 50,
                              height: 50,
                            ),
                            Text('道路安全')
                          ],
                        ),
                        Container(
                          width: ScreenUtil().setWidth(80),
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset(
                              'images/main/summitExam/a_sdaq@3x.png',
                              width: 50,
                              height: 50,
                            ),
                            Text('隧道安全')
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('在线考试'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listWidget,
    );
  }

  @override
  void initState() {
    super.initState();
    _List = ['在线考试', '我的错题'];
    _ListPic = [
      'images/main/summitExam/a_zxks@3x.png',
      'images/main/summitExam/a_wdct@3x.png'
    ];
  }
}
