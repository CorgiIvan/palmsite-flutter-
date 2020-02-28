import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/navigateUtil.dart';
import 'HiddenConfirmPage.dart';
import '../../model/SafeHiddenModel.dart';
import '../../UI/LoadingDialog.dart';
import '../../UI/LoadingWidget.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import '../../utils/HttpGo.dart';
import '../../cookie/cookie.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<ListPage> {
  SafeHidden safeHidden;
  var _futureBuilderFuture;
  TextEditingController _TextController = TextEditingController();
  bool isGet = true;
  int page = 1; //获取的页数

  @override
  void initState() {
    super.initState();
    cookie().getUser().then((user) {
      print(user['id']);
      _futureBuilderFuture = HttpGo().post("/ss/api.safe_hidden/find.html",
          (data) {
        setState(() {
          isGet = true;
          safeHidden = SafeHidden.fromJson(data);
        });
      }, errorCallBack: (error) {
        setState(() {
          isGet = false;
        });
      },
          params: FormData.from(
              {'page': 1, 'limit': 10, 'push_user_id': user['id']}));
    });
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {
    Response response;
    page = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id');
    FormData formData1 =
        FormData.from({'page': page, 'limit': 10, 'push_user_id': id});
    try {
      response = await HttpGo()
          .dio
          .post("/ss/api.safe_hidden/find.html", data: formData1);
      setState(() {
        safeHidden = SafeHidden.fromJson(response.data);
        print(safeHidden);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id');
    FormData formData1 =
        FormData.from({'page': page, 'limit': 10, 'push_user_id': id});
    try {
      response = await HttpGo()
          .dio
          .post("/ss/api.safe_hidden/find.html", data: formData1);
      setState(() {
        SafeHidden safeHidden2 = SafeHidden.fromJson(response.data);
        if (safeHidden2.data.isEmpty) {
          page -= 1;
          HttpGo().showToast('没有更多数据了');
        } else {
          safeHidden.data += safeHidden2.data;
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
          if (safeHidden == null) {
            if (isGet) {
              return LoadingWidget().childWidget();
            } else {
              return LoadingWidget().defeatWidget();
            }
          } else {
            return Center(
                child: Refresh(
              onHeaderRefresh: _onRefresh,
              onFooterRefresh: _getdata,
              child: ListView.builder(
                  itemCount: safeHidden.data.length,
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
                              title: Text(safeHidden.data[item].title),
                              subtitle: Text(safeHidden.data[item].ctime),
                              onTap: () {
                                navigate().navigateToStateless(
                                    context,
                                    HiddenConfirmPage(
                                        safeHidden.data[item].id,
                                        safeHidden.data[item].title,
                                        safeHidden.data[item].content,
                                        safeHidden.data[item].ctime,
                                        safeHidden.data[item].work_point,
                                        safeHidden.data[item].perambulate.name,
                                        safeHidden.data[item].mobile,
                                        safeHidden.data[item].construction_unit,
                                        safeHidden.data[item].leader,
                                        safeHidden.data[item].evidence));
                              },
                            ),
                          ),
                        ));
                  }),
            ));
          }
        });

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
//                icon: leftLogoPass,
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
                        text: '正在查询...',
                      );
                    });
                cookie().getUser().then((user) {
                  _futureBuilderFuture =
                      HttpGo().post("/ss/api.safe_hidden/find.html", (data) {
                    Navigator.pop(context);
                    HttpGo().showToast(data['msg']);
                    setState(() {
                      isGet = true;
                      safeHidden = SafeHidden.fromJson(data);
                    });
                  }, errorCallBack: (error) {
                    Navigator.pop(context);
                  },
                          params: FormData.from({
                            'page': 1,
                            'limit': 10,
                            'push_user_id': user['id'],
                            'keyword': _TextController.text
                          }));
                });
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
