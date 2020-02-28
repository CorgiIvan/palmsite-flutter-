//import 'package:dio/dio.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter/material.dart';
/**
 * 以前自己封装的dio网络请求，是个垃圾已经抛弃了，现在使用的是Httpgo的网络请求，
 */
//class FuckingDioUtil {
//
//  Future postTwoNoMap2(
//      String uri1, Map<String, dynamic> map1, String url2) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    FormData formData1 = FormData.from(map1);
//    try {
//      response = await dio.post(uri1, data: formData1);
//      print(response);
//      response = await dio.post(url2);
//      print(response);
//    } on DioError catch (e) {
//      print(e);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  Future postListTwoNoMap2(String uri1, Map<String, dynamic> map1, String url2,
//      BuildContext context) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    Response response1;
//    Response response2;
//    List<Response> ListResponse = List();
//    FormData formData1 = FormData.from(map1);
//    try {
//      response = await dio.post(uri1, data: formData1);
//      response1 = response;
//      response = await dio.post(url2);
//      response2 = response;
//      ListResponse.add(response1);
//      ListResponse.add(response2);
//      print(ListResponse[0]);
//      print(ListResponse[1]);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return ListResponse;
//  }
//
//  Future postTwoNoMap2withCookie(String uri1, String url2) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    try {
//      response = await dio.post(uri1, data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      response = await dio.post(url2);
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  /**
//   * 通过cookie查找错题
//   */
//  Future postTwoWithCookieAndId(String uri1, String url2) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    int id = prefs.getInt('id');
//    try {
//      response = await dio.post(uri1, data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      response = await dio.post(url2, data: {'user_id': id});
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  /**
//   * 通过cookie增加错题
//   */
//  Future AddErrorList(int teach_exam_id) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    int id = prefs.getInt('id');
//    try {
//      response = await dio.post('/origin/api.user/login.html', data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      response = await dio.post('/ss/api.errors_list/add', data: {
//        'user_id': id,
//        'teach_exam_id': teach_exam_id,
//        'error_time': DateTime.now().millisecondsSinceEpoch
//      });
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  /**
//   * 通过cookie增加考试结果
//   */
//  Future AddTeachResult(
//    int teach_online_id,
//    int stime,
//    double score,
//    int total,
//    int errors_count,
//    int pass_count,
//  ) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    int id = prefs.getInt('id');
//    try {
//      /**
//       * 登陆
//       */
//      response = await dio.post('/origin/api.user/login.html', data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      /**
//       * 上传成绩
//       */
//      response = await dio.post('/ss/api.teach_result/add', data: {
//        'user_id': id,
//        'teach_online_id': teach_online_id,
//        'stime': stime,
//        'etime': DateTime.now().millisecondsSinceEpoch,
//        'score': score,
//        'exam_time': DateTime.now().millisecondsSinceEpoch - stime,
//      });
//      print(response);
//      /**
//       * 上传错题数以及是否及格
//       */
//      response = await dio.post('/ss/api.Teach_Online_Statis/count', data: {
//        'total': total,
//        'errors_count': errors_count,
//        'pass_count': pass_count,
//      });
//      print(response);
//      /**
//       * 修改后评估数据
//       */
//      response = await dio.post('/ss/api.learn_assess/count');
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  /**
//   * 通过cookie增加训练结果
//   */
//  Future AddLearnResult(
//      int stime, String score, int total, int errors_count) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    int id = prefs.getInt('id');
//    try {
//      /**
//       * 登陆
//       */
//      response = await dio.post('/origin/api.user/login.html', data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      /**
//       * 上传本次测试的结果
//       */
//      response = await dio.post('/ss/api.learn_result/add', data: {
//        'user_id': id,
//        'classify_id': 1,
//        'score': score,
//        'learn_time': DateTime.now().millisecondsSinceEpoch - stime,
//      });
//      print(response);
//      /**
//       * 上传错题数以及是否及格
//       */
//      response = await dio.post('/ss/api.learn_result/count',
//          data: {'total': total, 'errors_count': errors_count});
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  /**
//   * 通过cookie查找在线考试结果
//   */
//  Future FindTeachResult(int teach_online_id) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    int id = prefs.getInt('id');
//    try {
//      response = await dio.post('/origin/api.user/login.html', data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      response = await dio.post('/ss/api.teach_result/find', data: {
//        'teach_online_id': teach_online_id,
//        'user_id': id,
//      });
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  /**
//   * 通过cookie增加在线时长
//   */
//  Future AddTodayTime(int time) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    try {
//      response = await dio.post('/origin/api.user/login.html', data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      response = await dio
//          .post('/ss/api.learn_assess/count', data: {'today_time': time});
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  /**
//   * 通过cookie的用户ID去查询目标API
//   */
//  Future FindData(String url2,String Param,String keyword) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    int id = prefs.getInt('id');
//    try {
//      response = await dio.post('/origin/api.user/login.html', data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      response = await dio
//          .post(url2, data: {Param: id,'keyword':keyword});
//      print(response);
//    } on DioError catch (e) {
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  Future postTwoNoMap1withCookie(
//      String uri1, String url2, Map<String, dynamic> map) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    FormData formData1 = FormData.from(map);
//    try {
//      response = await dio.post(uri1, data: {
//        'username': username,
//        'password': password,
//      });
//      print(response);
//      response = await dio.post(url2, data: formData1);
//      print(response);
//    } on DioError catch (e) {
//      print(e);
//      Fluttertoast.showToast(
//          msg: '请检查网络',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//
//  Future postThreeNoMap1withCookie(
//      String uri1, String url2, String url3, Map<String, dynamic> map) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    Response response1;
//    Response response2;
//    List<Response> ListResponse = List();
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String username = prefs.getString('username');
//    String password = prefs.getString('password');
//    FormData formData1 = FormData.from(map);
//    try {
//      response = await dio.post(uri1, data: {
//        'username': username,
//        'password': password,
//      });
//      response = await dio.post(url2);
//      response1 = response;
//      response = await dio.post(url3, data: formData1);
//      print(123333);
//      response2 = response;
//      ListResponse.add(response1);
//      ListResponse.add(response2);
//      print(123333);
//      print(ListResponse);
//    } on DioError catch (e) {
//      bool False = false;
//      Fluttertoast.showToast(
//          msg: '加载失败',
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.blue,
//          textColor: Colors.white);
//      return False;
//    }
//    return ListResponse;
//  }
//
//  Future postTwo(String uri1, Map<String, dynamic> map1, String url2,
//      Map<String, dynamic> map2) async {
//    Dio dio = new Dio();
//    Response response;
//    FormData formData1 = FormData.from(map1);
//    FormData formData2 = FormData.from(map2);
//    try {
//      response = await dio.post(uri1, data: formData1);
//      print(response);
//      response = await dio.post(url2, data: formData2);
//      print(response);
//    } on DioError catch (e) {
//      print(e);
//      bool False = false;
//      return False;
//    }
//  }
//
//  postOneWithFile(String uri1, FormData formdata) async {
//    Options options = Options(baseUrl: "http://www.feebird.cn:21105");
//    options.connectTimeout = 5000;
//    Dio dio = new Dio(options);
//    Response response;
//    try {
//      response = await dio.post(uri1, data: formdata);
//      print(response.data);
//    } on DioError catch (e) {
//      print(e);
//      bool False = false;
//      return False;
//    }
//    return response;
//  }
//}