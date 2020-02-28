import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../UI/LoadingDialog.dart';
import 'package:dio/dio.dart';
import 'package:palm_sitt_for_flutter/model/origin/UploadModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../model/origin//UserModel.dart';
import '../../UI/LoadingWidget.dart';
import '../../bloc/count_provider.dart';
import '../../UI/HeaderWidget.dart';
import '../../utils/HttpGo.dart';

import 'package:palm_sitt_for_flutter/UI/PopupBtn.dart';

class HiddenPushPage extends StatefulWidget {
  State<StatefulWidget> createState() => _HiddenPushState();
}

class _HiddenPushState extends State<HiddenPushPage> {
  var value;
  Future<File> _image;
  bool HasImage = false;
  FormData formData;
  UploadBean upload;
  var encoded1;
  Uint8List bytes;
  var _futureViewbuilder;
  Map<String, dynamic> user;
  UserBean userBean;
  FilterData filterData;
  bool isGet = false;
  String FilterList = '';
  String TrueFilterList;

  /**
   * TextController
   */
  TextEditingController _MobileController = TextEditingController();
  TextEditingController _TitleController = TextEditingController();
  TextEditingController _ContentController = TextEditingController();
  TextEditingController _RecordtimeController = TextEditingController();
  TextEditingController _WorkpointController = TextEditingController();
  TextEditingController _ConstructionunitController = TextEditingController();
  TextEditingController _LeaderController = TextEditingController();

  /**
   * 初始化数据
   */
  @override
  void initState() {
    super.initState();
    _futureViewbuilder = HttpGo().post("/origin/api.user/find.html", (data) {
      setState(() {
        isGet = true;
        userBean = UserBean.fromJson(data);
        for (int i = 0; i < userBean.data.length; i++) {
          if (i == (userBean.data.length - 1)) {
            FilterList += '{"id":' +
                userBean.data[i].id.toString() +
                ""","active":false,"disable":true,"name":""" +
                '"' +
                userBean.data[i].name +
                '"'
                ''
                '}';
          } else {
            FilterList += '{"id":' +
                userBean.data[i].id.toString() +
                ""","active":false,"disable":true,"name":""" +
                '"' +
                userBean.data[i].name +
                '"'
                ''
                '},';
          }
        }
      });
    }, errorCallBack: (error) {
      setState(() {
        isGet = false;
      });
    }, params: FormData.from({'page': 1}));
  }

  /**
   * 销毁页面时执行的函数
   */
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);
    final bloc = BlocProvider.of(context);
    /**
     * 退出执行的操作
     */
    Future<bool> _requestPop() {
      bloc.init();
      Navigator.pop(context);
      return new Future.value(false);
    }

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
     * post上传数据
     */
    void post() {
      print(bloc.getId());
      if (_MobileController.text.isEmpty) {
        _showdialog('请输入联系电话');
      } else if (_TitleController.text.isEmpty) {
        _showdialog('请输入标题');
      } else if (_ContentController.text.isEmpty) {
        _showdialog('请输入内容');
      } else if (_RecordtimeController.text.isEmpty) {
        _showdialog('请输入录制时间');
      } else if (_WorkpointController.text.isEmpty) {
        _showdialog('请输入工点');
      } else if (_ConstructionunitController.text.isEmpty) {
        _showdialog('请输入施工单位');
      } else if (_LeaderController.text.isEmpty) {
        _showdialog('请输入负责人');
      } else if (bloc.getId() == null) {
        _showdialog('请选择推送人');
      } else {
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
         * 请求接口
         */
        HttpGo.getInstance().post('/origin/api.file/upload.html', (data) {
          upload = UploadBean.fromJson(data);
          //TODO 后端需要改成根据当前用户ID发送，这里用的是当前定值1
          Map<String, dynamic> data1 = {
            'push_user_id': bloc.getId(),
            'perambulate_user_id': 1,
            'mobile': _MobileController.text,
            'title': _TitleController.text,
            'content': _ContentController.text,
            'record_time': _RecordtimeController.text,
            'work_point': _WorkpointController.text,
            'construction_unit': _ConstructionunitController.text,
            'leader': _LeaderController.text,
            'evidence': upload.data.url,
          };
          HttpGo().post("/ss/api.safe_hidden/add.html", (data) {
            Navigator.pop(context);
            _showdialog(data['msg']);
            if (data['code'] == 0) {
              Navigator.pop(context);
            }
          }, errorCallBack: (error) {
            Navigator.pop(context);
            HttpGo().showToast(error);
          },params: FormData.from(data1));
        }, errorCallBack: (error) {
          Navigator.pop(context);
          HttpGo().showToast(error);
        }, params: formData);

//        FuckingDioUtil()
//            .postOneWithFile('/origin/api.file/upload.html', formData)
//            .then((response1) {
//          upload = UploadBean.fromJson(response1.data);
//          if (upload.code == 0) {
//            Map<String, dynamic> data = {
//              'push_user_id': bloc.getId(),
//              'perambulate_user_id': user['id'],
//              'mobile': _MobileController.text,
//              'title': _TitleController.text,
//              'content': _ContentController.text,
//              'record_time': _RecordtimeController.text,
//              'work_point': _WorkpointController.text,
//              'construction_unit': _ConstructionunitController.text,
//              'leader': _LeaderController.text,
//              'evidence': upload.data.url,
//            };
//            FuckingDioUtil()
//                .postTwoNoMap1withCookie("/origin/api.user/login.html",
//                    "/ss/api.safe_hidden/add.html", data)
//                .then((response) {
//              Navigator.pop(context);
//              _showdialog(response.data['msg']);
//              if (response.data['code'] == 0) {
//                Navigator.pop(context);
//              }
//            });
//          } else {
//            Navigator.pop(context);
//            _showdialog(response1.data['msg']);
//          }
//        });
      }
    }

    final WidgetSubmitBtn = Padding(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
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

    Widget _previewImage() {
      return FutureBuilder<File>(
          future: _image,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              formData = FormData.from({
                "type": 'avatar',
                "file": UploadFileInfo(snapshot.data, 'HiddenPic')
              });
              return Image.file(
                snapshot.data,
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setWidth(200),
                fit: BoxFit.cover,
              );
            } else {
              return Container();
            }
//            else if (snapshot.error != null) {
//              return const Text(
//                'Error picking image.',
//                textAlign: TextAlign.center,
//              );
//            } else {
//              return const Text(
//                'You have not yet picked an image.',
//                textAlign: TextAlign.center,
//              );
//            }
          });
    }

    final WidgetImagePicker = Container(
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
              child: Row(
                children: <Widget>[
                  Container(
                    width: 126,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/main/HiddenPushPage/a_qz@3x.png',
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          '  取证',
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: InkWell(
                          onTap: () {
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
                                          getCamera();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      new ListTile(
                                        leading: new Icon(Icons.photo_library),
                                        title: new Text("从相册中选择"),
                                        onTap: () async {
                                          getImage();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Image.asset(
                            'images/main/zengjiatupian.png',
                            width: ScreenUtil().setWidth(200),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Container(
                          child: HasImage ? _previewImage() : Container(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));

    final WidgetLXR = Container(
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
              child: Row(
                children: <Widget>[
                  Container(
                    width: 110,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/main/HiddenPushPage/a_tsr@3x.png',
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          '  推送人',
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _futureViewbuilder,
                    builder: (context, snapshot) {
                      print(FilterList);
                      try {
                        if (!isGet) {
                          return LoadingWidget().childWidget();
                        } else {
                          return PopupTypeButton(
                            originData: FilterData.fromJson(
                                """{"list":[$FilterList]}"""),
                            home_tab_type: '请选择联系人',
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));

    /**
     * 表单填写数据
     */
    Widget listView = Column(children: <Widget>[
      MyTextField(
        imageStr: 'images/main/SafeRecord/a_lxdh@3x.png',
        TextStr: '  联系电话',
        hintStr: '请输入联系电话',
        controller: _MobileController,
      ),
      MyTextField(
        imageStr: 'images/main/SafeRecord/a_bt@3x.png',
        TextStr: '  标题',
        hintStr: '请输入标题',
        controller: _TitleController,
      ),
      MyTextField(
        imageStr: 'images/main/SafeRecord/a_nr@3x.png',
        TextStr: '  内容',
        hintStr: '请输入内容',
        controller: _ContentController,
      ),
      MyTextField(
        imageStr: 'images/main/HiddenPushPage/a_lzsj@3x.png',
        TextStr: '  录制时间',
        hintStr: '请输入录制时间',
        controller: _RecordtimeController,
      ),
      MyTextField(
        imageStr: 'images/main/HiddenPushPage/a_gd@3x.png',
        TextStr: '  工点',
        hintStr: '请输入工点',
        controller: _WorkpointController,
      ),
      MyTextField(
        imageStr: 'images/main/HiddenPushPage/a_sgdw@3x.png',
        TextStr: '  施工单位',
        hintStr: '请输入施工单位',
        isNecesarry: false,
        controller: _ConstructionunitController,
      ),
      MyTextField(
        imageStr: 'images/main/HiddenPushPage/a_fzr@3x.png',
        TextStr: '  负责人',
        hintStr: '请输入负责人',
        isNecesarry: false,
        controller: _LeaderController,
      ),
      WidgetImagePicker,
      WidgetLXR
    ]);

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('隐患推送'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[HeaderWidget().head(), listView, WidgetSubmitBtn],
        ),
      ),
      onWillPop: _requestPop,
    );
  }

  /**
   * 调用选择图片接口
   */
  Future getImage() async {
    setState(() {
      _image = ImagePicker.pickImage(source: ImageSource.gallery);
      HasImage = true;
    });
  }

  /**
   * 调用摄像机接口
   */
  Future getCamera() async {
    setState(() {
      _image = ImagePicker.pickImage(source: ImageSource.camera);
      HasImage = true;
    });
  }
}

/**
 * 每一行的widget格式
 */
class MyTextField extends StatefulWidget {
  final String imageStr;
  final String TextStr;
  final String hintStr;
  final isNecesarry;
  final TextEditingController controller;

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
                    controller: widget.controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Container(
                          width: 110,
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
          )),
    );
  }
}
