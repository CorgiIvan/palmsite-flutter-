import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../UI/LoadingDialog.dart';
import '../../UI/HeaderWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/HttpGo.dart';
import 'package:dio/dio.dart';

class SecurityPatrolPage extends StatefulWidget {
  State<StatefulWidget> createState() => _SecurityPatrolState();
}

class _SecurityPatrolState extends State<SecurityPatrolPage> {
  String groupValue;

  TextEditingController _MobileController = TextEditingController();
  TextEditingController _TitleController = TextEditingController();
  TextEditingController _ContentController = TextEditingController();
  TextEditingController _ResultController = TextEditingController();
  Map<String, dynamic> data = {
    'id': '',
    'name': '',
    'phone': '',
    'title': '',
    'content': ''
  };

  @override
  Widget build(BuildContext context) {
    /**
     * 性别选择按钮
     */
    Widget WidgetGenderRadio = Container(
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.2, color: Colors.black26)),
                color: Colors.white),
            child: Row(
              children: <Widget>[
                Container(
                  width: 110,
                  child: Wrap(
                    children: <Widget>[
                      Image.asset(
                        'images/main/SafeRecord/a_xb@3x.png',
                        width: 25,
                        height: 25,
                      ),
                      RichText(
                        text: TextSpan(
                            text: '  性别',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red))
                            ]),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '男',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                            value: '男',
                            groupValue: groupValue,
                            onChanged: (T) {
                              updateGroupValue(T);
                            }),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '女',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                            value: '女',
                            groupValue: groupValue,
                            onChanged: (T) {
                              updateGroupValue(T);
                            })
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );

    /**
     * 电话输入框
     */
    Widget WidgetPhoneInput = Container(
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.2, color: Colors.black26)),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: TextField(
                    controller: _MobileController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Container(
                          width: 110,
                          child: Wrap(
                            children: <Widget>[
                              Image.asset(
                                'images/main/SafeRecord/a_lxdh@3x.png',
                                width: 25,
                                height: 25,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: '  联系电话',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red))
                                    ]),
                              )
                            ],
                          ),
                        ),
                        hintText: '请输入您的联系电话',
                        hintStyle: TextStyle(fontSize: 16.0)),
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      data['phone'] = text;
                    }),
              ),
            ),
          )),
    );

    /**
     * 标题输入框
     */
    Widget WidgetTitleInput = Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.2, color: Colors.black26)),
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.0),
              child: TextField(
                  controller: _TitleController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Container(
                        width: 110,
                        child: Wrap(
                          children: <Widget>[
                            Image.asset(
                              'images/main/SafeRecord/a_bt@3x.png',
                              width: 25,
                              height: 25,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: '  标题',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red))
                                  ]),
                            )
                          ],
                        ),
                      ),
                      hintText: '请输入标题',
                      hintStyle: TextStyle(fontSize: 16.0)),
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    data['title'] = text;
                  }),
            ),
          ),
        ));

    /**
     * 内容输入框
     */
    Widget WidgetContentInput = Container(
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.2, color: Colors.black26)),
                  color: Colors.white),
              child: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: TextField(
                      controller: _ContentController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Container(
                            width: 110,
                            child: Wrap(
                              children: <Widget>[
                                Image.asset(
                                  'images/main/SafeRecord/a_nr@3x.png',
                                  width: 25,
                                  height: 25,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: '  内容',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '*',
                                            style: TextStyle(color: Colors.red))
                                      ]),
                                )
                              ],
                            ),
                          ),
                          hintText: '请输入内容',
                          hintStyle: TextStyle(fontSize: 16.0)),
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        data['content'] = text;
                      })),
            ),
          )),
    );

    /**
     * 结论输入框
     */
    Widget WidgetConclusionInput = Container(
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.2, color: Colors.black26)),
                  color: Colors.white),
              child: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: TextField(
                    controller: _ResultController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Container(
                          width: 110,
                          child: Wrap(
                            children: <Widget>[
                              Image.asset(
                                'images/main/SafeRecord/a_xcjl@3x.png',
                                width: 25,
                                height: 25,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: '  结论',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red))
                                    ]),
                              )
                            ],
                          ),
                        ),
                        hintText: '请输入巡查结论',
                        hintStyle: TextStyle(fontSize: 16.0)),
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    keyboardType: TextInputType.text,
                  )),
            ),
          )),
    );

    /**
     * 显示底部弹窗
     */
    _showdialog(String str) {
      Fluttertoast.showToast(
          msg: str,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    }

    /**
     * post请求
     */
    void post() async {
      if (_MobileController.text.isEmpty) {
        _showdialog('请输入联系电话');
      } else if (_TitleController.text.isEmpty) {
        _showdialog('请输入标题');
      } else if (_ContentController.text.isEmpty) {
        _showdialog('请输入内容');
      } else if (_ResultController.text.isEmpty) {
        _showdialog('请输入结论');
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int user_id = prefs.getInt('id');
        Map<String, dynamic> ParamData = {
          'user_id': user_id,
          'mobile': _MobileController.text,
          'title': _TitleController.text,
          'content': _ContentController.text,
          'result': _ResultController.text,
        };
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new LoadingDialog(
                //调用对话框
                text: '正在上传...',
              );
            });

        HttpGo.getInstance().post("/ss/api.safe_record/add", (data) {
          Navigator.pop(context);
          Navigator.pop(context);
          HttpGo().showToast(data['msg']);
        }, errorCallBack: (error) {
          Navigator.pop(context);
        }, params: FormData.from(ParamData));

//        FuckingDioUtil()
//            .postTwoNoMap1withCookie(
//                "/origin/api.user/login.html", "/ss/api.safe_record/add", data)
//            .then((response) {
//          Navigator.pop(context);
//          Fluttertoast.showToast(
//              msg: response.data['msg'],
//              toastLength: Toast.LENGTH_SHORT,
//              gravity: ToastGravity.BOTTOM,
//              timeInSecForIos: 1,
//              backgroundColor: Colors.blue,
//              textColor: Colors.white);
//          if (response.data['code'] == 0) {
//            Navigator.pop(context);
//          }
//        });
      }
    }

    /**
     * 提交按钮
     */
    Widget WidgetSubmitBtn = Padding(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 20.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Row(
          children: <Widget>[
            new Expanded(
              child: MaterialButton(
                onPressed: () {
                  post();
                },
                child: Text(
                  "提交",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );

    final listView = Column(
      children: <Widget>[
//        WidgetGenderRadio,
        WidgetPhoneInput,
        WidgetTitleInput,
        WidgetContentInput,
        WidgetConclusionInput,
      ],
//      shrinkWrap: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('安全记录'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[HeaderWidget().head(), listView, WidgetSubmitBtn],
      ),
    );
  }

  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }
}
