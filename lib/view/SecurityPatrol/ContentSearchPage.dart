import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ContentSearchDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/navigateUtil.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../model/SafeRecordModel.dart';
import '../../UI/LoadingDialog.dart';
import '../../UI/LoadingWidget.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import '../../utils/HttpGo.dart';

class ContentSearchPage extends StatefulWidget {
  State<StatefulWidget> createState() => _ContentSearchState();
}

class _ContentSearchState extends State<ContentSearchPage> {
  SafeRecordModel safeRecordModel;
  var _futureBuilderFuture;
  TextEditingController _TextController = TextEditingController();
  bool isGet = true;
  int page = 1; //获取的页数

  @override
  void initState() {
    super.initState();

    ///用_futureBuilderFuture来保存_gerData()的结果，以避免不必要的ui重绘
    _futureBuilderFuture =
        HttpGo().post("/ss/api.safe_record/find.html", (data) {
      setState(() {
        isGet = true;
        safeRecordModel = SafeRecordModel.fromJson(data);
      });
    }, errorCallBack: (error) {
      setState(() {
        isGet = false;
      });
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
          .post("/ss/api.safe_record/find.html", data: formData1);
      setState(() {
        safeRecordModel = SafeRecordModel.fromJson(response.data);
        print(safeRecordModel);
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
          .post("/ss/api.safe_record/find.html", data: formData1);
      setState(() {
        SafeRecordModel safeRecordModel2 =
            SafeRecordModel.fromJson(response.data);
        if (safeRecordModel2.data.isEmpty) {
          page -= 1;
          HttpGo().showToast('没有更多数据了');
        } else {
          safeRecordModel.data += safeRecordModel2.data;
          print(safeRecordModel2);
          HttpGo().showToast('加载成功');
        }
      });
    } on DioError catch (e) {
      HttpGo().showToast('加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final listView = FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (safeRecordModel == null) {
          if (isGet) {
            return LoadingWidget().childWidget();
          } else {
            return LoadingWidget().defeatWidget();
          }
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Refresh(
              onHeaderRefresh: _onRefresh,
              onFooterRefresh: _getdata,
              child: ListView.builder(
                  itemCount: safeRecordModel.data.length,
                  itemBuilder: (context, item) {
                    return Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, bottom: 0.0, right: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 0.2, color: Colors.black26)),
                                color: Colors.white),
                            child: ListTile(
                              trailing: Image.asset(
                                'images/main/a_fhw@3x.png',
                                height: 15,
                              ),
                              title: Text(safeRecordModel.data[item].title),
                              subtitle: Text('2018-12.0.3'),
                              onTap: () {
                                navigate().navigateToMain(
                                    context,
                                    ContentSearchDetail(
                                        safeRecordModel.data[item].user.id
                                            .toString(),
                                        safeRecordModel.data[item].user.name,
                                        safeRecordModel.data[item].mobile,
                                        safeRecordModel.data[item].title,
                                        safeRecordModel.data[item].content,
                                        safeRecordModel.data[item].result));
                              },
                            ),
                          ),
                        ));
                  }),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 35,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 0.5, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(6.0),
                hintText: "关键字搜索",
                border: InputBorder.none),
            autofocus: false,
            textAlign: TextAlign.center,
            controller: _TextController,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {
                showDialog<Null>(
                    context: context, //BuildContext对象
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new LoadingDialog(
                        //调用对话框
                        text: '正在查找...',
                      );
                    });
                _futureBuilderFuture =
                    HttpGo().post("/ss/api.safe_record/find.html", (data) {
                  Navigator.pop(context);
                  HttpGo().showToast(data['msg']);
                  setState(() {
                    isGet = true;
                    safeRecordModel = SafeRecordModel.fromJson(data);
                  });
                }, errorCallBack: (error) {
                  isGet = false;
                  Navigator.pop(context);
                }, params: FormData.from({'keyword': _TextController.text}));
              },
              child: Image.asset(
                'images/main/a_ss@3x.png',
                width: 20,
                height: 20,
              ),
            ),
          )
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listView,
    );
  }
}
