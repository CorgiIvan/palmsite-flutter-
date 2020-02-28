//import 'dart:async';
//import 'dart:isolate';
//import 'FuckingDioUtil.dart';
//import '../model/origin/UploadModel.dart';
//import 'dart:io';
//import 'package:dio/dio.dart';
//
//class isoUtils {
////  final File file;
////  const isoUtils(this.file);
////  main() async {
////    var receivePort = new ReceivePort();
////    await Isolate.spawn(echo, receivePort.sendPort);
////
////    // 'echo'发送的第一个message，是它的SendPort
////    var sendPort = await receivePort.first;
////
////    var msg = await sendReceive(sendPort, "foo");
////    print('received $msg');
////  }
////
////  /// 对某个port发送消息，并接收结果
////  ///
////  Future sendReceive(SendPort port, msg) async {
////    ReceivePort response = new ReceivePort();
////    port.send([msg, response.sendPort]);
////    print(file);
//////    });
////  }
////
////  echo(SendPort sendPort) async {
////    // 实例化一个ReceivePort 以接收消息
////    var port = new ReceivePort();
////
////    // 把它的sendPort发送给宿主isolate，以便宿主可以给它发送消息
////    sendPort.send(port.sendPort);
////  }
//
////这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
//  Future<dynamic> asyncFibonacci(File file) async {
//    //首先创建一个ReceivePort，为什么要创建这个？
//    //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
//    final response = new ReceivePort();
//    //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
//    //_isolate是创建isolate必须要的参数。
//    await Isolate.spawn(_isolate, response.sendPort);
//    //获取sendPort来发送数据
//    final sendPort = await response.first as SendPort;
//    //接收消息的ReceivePort
//    final answer = new ReceivePort();
//    //发送数据
//    sendPort.send([file, answer.sendPort]);
//    //获得数据并返回
//    return answer.first;
//  }
//}
//
////创建isolate必须要的参数
//void _isolate(SendPort initialReplyTo) {
//  final port = new ReceivePort();
//  //绑定
//  initialReplyTo.send(port.sendPort);
//  //监听
//  port.listen((message) {
//    //获取数据并解析
//    final data = message[0] as File;
//    final send = message[1] as SendPort;
//    //返回结果
//    send.send(syncFibonacci(data));
//  });
//}
//
//Future<dynamic> syncFibonacci(File file) async {
//  FuckingDioUtil()
//      .postOneWithFile(
//          '/origin/api.file/upload.html',
//          FormData.from(
//              {"type": 'avatar', "file": UploadFileInfo(file, 'PalmVideo')}))
//      .then((response) {
//    UploadBean uploadBean = UploadBean.fromJson(response.data);
//  });
////  Options options = Options(baseUrl: "http://www.feebird.cn:21105");
////  options.connectTimeout = 5000;
////  Dio dio = new Dio(options);
////  Response response;
////  print(file);
////  try {
////    response = await dio.post('/origin/api.file/upload.html',
////        data: FormData.from(
////            {"type": 'avatar', "file": UploadFileInfo(file, 'PalmVideo')}));
////    print(response.data);
////  } on DioError catch (e) {
////    print(e);
////    bool False = false;
////    return False;
////  }
////  return response;
//}
