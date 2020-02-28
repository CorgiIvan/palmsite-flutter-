import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/LoadingDialog.dart';
import '../../UI/HeaderWidget.dart';
import 'package:palm_sitt_for_flutter/model/origin/UploadModel.dart';
import '../../model/SiteSupervisionModel.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:isolate';
import '../../utils/HttpGo.dart';

class PalmInformationPage extends StatefulWidget {
  State<StatefulWidget> createState() => _PalmInformationState();
}

class _PalmInformationState extends State<PalmInformationPage> {
  var value;
  bool HasImage = false;
//  VideoPlayerController _controller;
  VoidCallback listener;
  UploadBean uploadBean;
  UploadFileInfo uploadFileInfo;
  File _file;
  Map<String, dynamic> ParamData;

  /**
   * TextController
   */
  TextEditingController _RecordtimeController = TextEditingController();
  TextEditingController _RecordpositionController = TextEditingController();
  TextEditingController _VideotitleController = TextEditingController();
  TextEditingController _VideoController = TextEditingController();
  TextEditingController _WpnameController = TextEditingController();
  TextEditingController _AcceptancerequirementsController =
      TextEditingController();
  TextEditingController _SupervisorstaffController = TextEditingController();
  TextEditingController _TimeController = TextEditingController();
  TextEditingController _ConstructionunitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
  }

  //返回的值是Future，因为是异步的
  postWithIsolate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    String password = prefs.getString('password');
    print(username);
    //首先创建一个ReceivePort，为什么要创建这个？
    //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
    final response = new ReceivePort();
    //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
    //_isolate是创建isolate必须要的参数。
    await Isolate.spawn(_isolate, response.sendPort);
    //获取sendPort来发送数据
    final sendPort = await response.first as SendPort;
    //接收消息的ReceivePort
    final answer = new ReceivePort();
    //发送数据
    sendPort.send([ParamData, _file, username, password, answer.sendPort]);
    //获得数据并返回
    return answer.first;
  }

  /**
   * 显示底部弹窗
   */
  _showdialog(String str){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    /**
     * 确认按钮
     */
    final WidgetSubmitBtn = Padding(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Row(
          children: <Widget>[
            new Expanded(
              child: MaterialButton(
                onPressed: () async {
                  if (_RecordtimeController.text.isEmpty) {
                    _showdialog('请输入录制时间');
                  } else if (_RecordpositionController.text.isEmpty) {
                    _showdialog('请输入录制位置');
                  } else if (_VideotitleController.text.isEmpty) {
                    _showdialog('请输入视频名称');
                  } else if (_WpnameController.text.isEmpty) {
                    _showdialog('请输入工点名称');
                  } else if (_AcceptancerequirementsController.text.isEmpty) {
                    _showdialog('请输入验收要求');
                  } else if (_SupervisorstaffController.text.isEmpty) {
                    _showdialog('请输入监理人员');
                  } else if (_TimeController.text.isEmpty) {
                    _showdialog('请输入监理时间');
                  } else if (_ConstructionunitController.text.isEmpty) {
                    _showdialog('请输入施工单位');
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int user_id = prefs.getInt('id');
                    ParamData = {
                      'user_id': user_id,
                      'video_title': _VideotitleController.text,
                      'record_position': _RecordpositionController.text,
                      'record_time': _RecordtimeController.text,
                      'wp_name': _WpnameController.text,
                      'video': '',
                      'acceptance_requirements':
                          _AcceptancerequirementsController.text,
                      'supervisor_staff': _SupervisorstaffController.text,
                      'time': _TimeController.text,
                      'construction_unit': _ConstructionunitController.text,
                    };

                    /**
                   * 弹出loading
                   */
                    showDialog<Null>(
                        context: context, //BuildContext对象
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new LoadingDialog(
                            //调用对话框
                            text: '正在上传...',
                          );
                        });
                    /**
                   * 使用isolate+dio的形式上传，不占用界面内存
                   */
                    postWithIsolate().then((data) {
                      HttpGo().post('/ss/api.site_supervision/add', (response) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        HttpGo().showToast(response['msg']);
                      },errorCallBack: (error){
                        Navigator.pop(context);
                      }, params: FormData.from(data));
                    });
                  }
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

    final WidgetImagePicker = Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.2, color: Colors.black26)),
              color: Colors.white),
          child: Padding(
            padding: EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Container(
                    width: ScreenUtil().setWidth(400),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/main/pangzhanjianli/a_sp@3x.png',
                          width: 25,
                          height: 25,
                        ),
                        RichText(
                          text: TextSpan(
                              text: '  视频',
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
                ),
                Row(
                  children: <Widget>[
                    HasImage
                        ? Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text('视频已上传'))
                        : Container(),
                    Container(
                        child: InkWell(
                      onTap: () {
                        HasImage = true;

                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new ListTile(
                                    leading: new Icon(Icons.photo_camera),
                                    title: new Text("拍摄"),
                                    onTap: () async {
                                      getImage(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  new ListTile(
                                    leading: new Icon(Icons.photo_library),
                                    title: new Text("从相册中选取"),
                                    onTap: () async {
                                      getImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Image.asset(
                        'images/main/zengjiatupian.png',
                        width: 80,
                        height: 80,
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    final listView = Column(children: <Widget>[
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_lzsj@3x.png',
        TextStr: '  录制时间',
        hintStr: '请输入录制时间',
        controller: _RecordtimeController,
      ),
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_lzwz@3x.png',
        TextStr: '  录制位置',
        hintStr: '请输入录制位置',
        controller: _RecordpositionController,
      ),
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_spmc@3x.png',
        TextStr: '  视频名称',
        hintStr: '请输入视频名称',
        controller: _VideotitleController,
      ),
      WidgetImagePicker,
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_gd@3x.png',
        TextStr: '  工点名称',
        hintStr: '请输入工点名称',
        controller: _WpnameController,
      ),
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_ysyq@3x.png',
        TextStr: '  验收要求',
        hintStr: '请输入验收要求',
        controller: _AcceptancerequirementsController,
      ),
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_jlry@3x.png',
        TextStr: '  监理人员',
        hintStr: '请输入监理人员',
        isNecesarry: false,
        controller: _SupervisorstaffController,
      ),
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_jrxxsc@3x.png',
        TextStr: '  监理时间',
        hintStr: '请输入监理时间',
        controller: _TimeController,
      ),
      MyTextField(
        imageStr: 'images/main/pangzhanjianli/a_sgdw@3x.png',
        TextStr: '  施工单位',
        hintStr: '请输入施工单位',
        controller: _ConstructionunitController,
      ),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text('工点信息'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[HeaderWidget().head(), listView, WidgetSubmitBtn],
      ),
    );
  }

  Future getImage(ImageSource style) async {
    setState(() {
      ImagePicker.pickVideo(source: style).then((File file) {
        if (file != null && mounted) {
          _file = file;
        }
      });
    });
  }
}

//创建isolate必须要的参数
void _isolate(SendPort initialReplyTo) {
  SiteSupervision siteSupervision;
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    final data = message[0] as Map<String, dynamic>;
    final data2 = message[1] as File;
    final username = message[2] as String;
    final password = message[3] as String;
    final send = message[4] as SendPort;

    HttpGo().post("/origin/api.file/upload.html", (response) {
      UploadBean uploadBean = UploadBean.fromJson(response);
      data['video'] = uploadBean.data.url;
      send.send(data);
    },
        params: FormData.from(
            {"type": 'avatar', "file": UploadFileInfo(data2, 'PalmVideo')}));
  });
}

class MyTextField extends StatefulWidget {
  final String imageStr;
  final String TextStr;
  final String hintStr;
  final TextEditingController controller;
  final isNecesarry;

  const MyTextField(
      {@required this.imageStr,
      @required this.TextStr,
      @required this.hintStr,
      this.isNecesarry = true,
      this.controller});

  State<StatefulWidget> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.2, color: Colors.black26)),
              color: Colors.white),
          child: Padding(
              padding: EdgeInsets.only(bottom: 6.0),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Container(
                      width: ScreenUtil().setWidth(400),
                      child: Wrap(
                        children: <Widget>[
                          Image.asset(
                            widget.imageStr,
                            width: 25,
                            height: 25,
                          ),
                          RichText(
                            text: TextSpan(
                                text: widget.TextStr,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: widget.isNecesarry ? '*' : '',
                                      style: TextStyle(color: Colors.red))
                                ]),
                          )
                        ],
                      ),
                    ),
                    hintText: widget.hintStr,
                    hintStyle: TextStyle(fontSize: 16.0)),
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                keyboardType: TextInputType.text,
              )),
        ),
      ),
    );
  }
}