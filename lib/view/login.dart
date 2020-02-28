import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Ui/LoadingDialog.dart';
import '../cookie/cookie.dart';
import '../utils/FuckingDioUtil.dart';
import '../utils/md5Util.dart';
import '../utils/HttpGo.dart';
import 'package:dio/dio.dart';
import '../model/origin/UserLoggedBean.dart';

class login extends StatefulWidget {
  State<StatefulWidget> createState() => _loginState();
}

class _loginState extends State<login> {
  Map<String, dynamic> user = {
    'username': '账号名称',
    'password': '密码',
  };
  final TextEditingController _usercontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  Widget leftLogo = new Container(
    width: 10,
    height: double.infinity,
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.email,color: Colors.black,),
          SizedBox(
            width: 1.0,
            height: double.infinity,
            child: Container(
              decoration: new BoxDecoration(color: Colors.blue[300]),
            ),
          )
        ]),
  );

  Widget leftLogoPass = new Container(
    width: 10,
    height: double.infinity,
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.lock,color: Colors.black,),
          SizedBox(
            width: 1.0,
            height: double.infinity,
            child: Container(
              decoration: new BoxDecoration(color: Colors.blue[300]),
            ),
          )
        ]),
  );

  @override
  void initState() {
    print('启动initState');
    _usercontroller.text = '用户名';
    _passwordcontroller.text = '密码';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 56.0),
              child: new Image.asset(
                'images/main/m_logo.png',
                height: 85,
                fit: BoxFit.cover,
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.blue[300]),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: TextField(
                  controller: _usercontroller,
                  decoration: InputDecoration(
                      prefixIcon: leftLogo,
                      contentPadding: EdgeInsets.all(5.0),
                      hintText: '用户名/邮箱/手机号',
                      border: InputBorder.none),
                  autofocus: false,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.blue[300]),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: TextField(
                  controller: _passwordcontroller,
                  decoration: InputDecoration(
                      prefixIcon: leftLogoPass,
                      contentPadding: EdgeInsets.all(5.0),
                      hintText: '密码',
                      border: InputBorder.none),
                  autofocus: false,
                  obscureText: true,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        /**
                         * 弹出等待窗口
                         */
                        showDialog<Null>(
                            context: context, //BuildContext对象
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return LoadingDialog(
                                //调用对话框
                                text: '正在登录...',
                              );
                            });
                        /**
                         * 验证
                         */
                        if ((user['username'].isEmpty) ||
                            (user['password'].isEmpty)) {
                          /**
                           * 弹出toast提示
                           */
                          Fluttertoast.showToast(
                              msg: "账号密码不能为空",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white);
                          Navigator.pop(context);
                        } else {
                          login();
                        }
                      },
                      child: Text(
                        "登录",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              Text(
//                '立即注册'
//              ),
//              Text(
//                '忘记密码'
//              )
//            ],
//          )
        ],
      ),
    ));
  }

  /**
   * 登录
   */
  void login() {
    user['username'] = _usercontroller.text;
    user['password'] = md5Util().generateMd5(_passwordcontroller.text);
    var postUrl = '/origin/api.user/login.html';
    FormData formData = FormData.from(user);
    HttpGo.getInstance().post(
        postUrl,
        (data) {
          HttpGo.getInstance().post("/origin/api.user/logged.html", (data) {
            UserLoggedBean userLoggedBean = UserLoggedBean.fromJson(data);
//            保存cookie,保存账号和密码
            cookie()
                .setUser(
                    _usercontroller.text,
                    md5Util().generateMd5(_passwordcontroller.text),
                    userLoggedBean.data.avatar,
                    userLoggedBean.data.name,
                    userLoggedBean.data.mobile,
                    userLoggedBean.data.id)
                .then((m) {
              /**
           * 跳转页面
           */
              Navigator.pushNamedAndRemoveUntil(
                  context, 'homeRoute', (route) => route == null);
            });
          },errorCallBack: (error){
            Navigator.pop(context);
          });
        },
        params: formData,
        errorCallBack: (error) {
          Navigator.pop(context);
        });
//    FuckingDioUtil()
//        .postListTwoNoMap2("/origin/api.user/login.html", user,
//            "/origin/api.user/logged.html", context)
//        .then((ListResponse) {
//      if (ListResponse[0].data['code'] == 0) {
//        /**
//         *保存cookie
//         */
//        cookie()
//            .setUser(
//                _usercontroller.text,
//                md5Util().generateMd5(_passwordcontroller.text),
//                ListResponse[1].data['data']['avatar'],
//                ListResponse[1].data['data']['name'],
//                ListResponse[1].data['data']['mobile'],
//                ListResponse[1].data['data']['id'])
//            .then((m) {
//          /**
//           * 跳转页面
//           */
//          Navigator.pushNamedAndRemoveUntil(
//              context, 'homeRoute', (route) => route == null);
//        });
//      } else {
//        Navigator.pop(context);
//        Fluttertoast.showToast(
//            msg: ListResponse[0].data['msg'],
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            timeInSecForIos: 1,
//            backgroundColor: Colors.blue,
//            textColor: Colors.white);
//      }
//    });

//    FormData formData = FormData.from(user);
//    try {
//      response = await dio.post(
//          "http://www.feebird.cn:21105/origin/api.user/login.html",
//          data: formData);
//      print('拿到的API数据是===============' + response.data['msg'].toString());
//      if (response.data['msg'].toString() == '登录成功') {
//        /**
//         *保存cookie
//         */
//        cookie().setUser(user['username'], user['password']);
//        /**
//         * 跳转页面
//         */
//        Navigator.pushNamedAndRemoveUntil(
//            context, 'homeRoute', (route) => route == null);
//      } else {
//        Navigator.pop(context);
//        Fluttertoast.showToast(
//            msg: response.data['msg'],
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            timeInSecForIos: 1,
//            backgroundColor: Colors.blue,
//            textColor: Colors.white);
//      }
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      Navigator.pop(context);
//    }
  }
}
