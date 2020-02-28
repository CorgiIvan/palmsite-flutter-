import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class HttpGo {
  static final String GET = "get";
  static final String POST = "post";
  static final String DATA = "data";
  static final String CODE = "code";
  static String USERNMAE;
  static String PASSWORD;
  static int ID;
  static final String URL = 'ip地址';
  static final Options options = Options(
    baseUrl: URL,
    headers: {'platform': 'android', 'version': 11.0},
    connectTimeout: 5000,
    receiveTimeout: 100000,
  );

  Dio dio;
  static HttpGo _instance;

  static HttpGo getInstance() {
    if (_instance == null) {
      _instance = HttpGo();
    }
    return _instance;
  }

  HttpGo() {
    dio = Dio(options);
  }

  //get请求
  get(String url, Function successCallBack,
      {params, Function errorCallBack}) async {
    _requstHttp(url, successCallBack, GET, params, errorCallBack);
  }

  //post请求
  post(String url, Function successCallBack,
      {params, Function errorCallBack}) async {
    _requstHttp(url, successCallBack, POST, params, errorCallBack);
  }

  //先登录再做后面的请求
  postWithCookie(Function successCallBack, {Function errorCallBack}) {
    getCookie().then((_) {
      _requstHttp(
          '/origin/api.user/login.html',
          successCallBack,
          POST,
          FormData.from({'username': USERNMAE, 'password': PASSWORD}),
          errorCallBack);
    });
  }

  //增加考试结果
  AddTeachResult(Function successCallBack, int teach_online_id, int stime,
      double score, int total, int errors_count, int pass_count,
      {Function errorCallBack}) {
    getCookie().then((_){
      _requstHttp(
          '/ss/api.Teach_Online_Statis/count',
          successCallBack,
          POST,
          FormData.from({
            'user_id': ID,
            'teach_online_id': teach_online_id,
            'stime': stime,
            'etime': DateTime.now().millisecondsSinceEpoch,
            'score': score,
            'exam_time': DateTime.now().millisecondsSinceEpoch - stime,
          }),
          errorCallBack);
    });
  }

  //  获取cookie
  Future getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    USERNMAE = prefs.getString('username');
    PASSWORD = prefs.getString('password');
    ID = prefs.getInt('id');
  }

  _requstHttp(String url, Function successCallBack,
      [String method, FormData params, Function errorCallBack]) async {
    String errorMsg = '';
    int code;

    try {
      Response response;
      _addStartHttpInterceptor(dio); //添加请求之前的拦截器
      if (method == GET) {
        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, data: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == POST) {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }

      code = response.statusCode;
      if (code != 200) {
        errorMsg = '错误码：' + code.toString() + '，' + response.data.toString();
        _error(errorCallBack, response.data['msg']);
        return;
      }
      print(response);
      String dataStr = json.encode(response.data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      print(dataMap);
      if (dataMap != null && dataMap[CODE] != 0 && dataMap['msg'] != '已经存在') {
        errorMsg =
            '错误码：' + dataMap[CODE].toString() + '，' + response.data.toString();
        _error(errorCallBack, response.data['msg']);
        return;
      }

      if (successCallBack != null) {
        successCallBack(dataMap);
        return;
      }
    } catch (exception) {
      print('dio连接出现错误================' + exception.toString());
      _error(errorCallBack, '网络连接错误');
    }
  }

  _error(Function errorCallBack, String error) {
    Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }

  _addStartHttpInterceptor(Dio dio) {
    dio.interceptor.request.onSend = (Options options) {
      // 在请求被发送之前做一些事情   比如加密的一些操作 或者添加token等参数 对head 或者请求参数进行加工处理
      Map<String, dynamic> headers = options.headers;
      Map<String, dynamic> body = options.data;
      /*request['token'] = '1111111111';
      headers['addParam'] = 'aaaaaaaaaaaaaaa';*/
      return options;
    };
  }

  showToast(String str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }
}
