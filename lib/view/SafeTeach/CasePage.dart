import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/navigateUtil.dart';
import 'CaseDetail.dart';
import '../../utils/HttpGo.dart';
import '../../model/TeachCaseModel.dart';
import '../../UI/LoadingWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter_refresh/flutter_refresh.dart';

class SafetyCasePage extends StatefulWidget {
  State<StatefulWidget> createState() => _SafetyCaseState();
}

class _SafetyCaseState extends State<SafetyCasePage> {
  TeachCaseModel teachCaseModel;
  var _futureBuilderFuture;
  bool isGet = true;
  int page = 1; //获取的页数

  @override
  void initState() {
    super.initState();
    ///用_futureBuilderFuture来保存_gerData()的结果，以避免不必要的ui重绘
    _futureBuilderFuture =
        HttpGo().post("/ss/api.teach_case/find.html", (data) {
            setState(() {
              teachCaseModel = TeachCaseModel.fromJson(data);
            });
        }, params: FormData.from({'page': 1}));
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {
    Response response;
    page = 1;
    FormData formData1 = FormData.from({'page': page});
    try {
      response = await HttpGo().dio.post("/ss/api.teach_case/find.html",data: formData1);
      setState(() {
        teachCaseModel = TeachCaseModel.fromJson(response.data);
        HttpGo().showToast('刷新成功');
      });
    } on DioError catch (e) {
      HttpGo().showToast('刷新成功');
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
      response = await HttpGo().dio.post("/ss/api.teach_case/find.html",data: formData1);
      setState(() {
        TeachCaseModel teachCaseMode2 = TeachCaseModel.fromJson(response.data);
        teachCaseModel.data += teachCaseMode2.data;
        HttpGo().showToast('加载成功');
      });
    } on DioError catch (e) {
      HttpGo().showToast('加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final listView = Center(
        child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (teachCaseModel == null) {
                if (isGet) {
                  return LoadingWidget().childWidget();
                } else {
                  return LoadingWidget().defeatWidget();
                }
              }
              return Refresh(
                onHeaderRefresh: _onRefresh,
                onFooterRefresh: _getdata,
                child: ListView.builder(
                    itemCount: teachCaseModel.data.length,
                    itemBuilder: (context, item) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2, color: Colors.black26),
                            color: Colors.white),
                        child: ListTile(
                          leading: Image.network(
                            HttpGo.URL + '/upload'+
                                teachCaseModel.data[item].pic,
                            height: 60,
                            width: ScreenUtil().setWidth(220),
                          ),
                          title: Text(teachCaseModel.data[item].title),
                          subtitle: Text(
                              teachCaseModel.data[item].browse_count.toString() +
                                  '浏览'),
                          onTap: () {
                            navigate().navigateToMain(
                                context,
                                StudyCaseDetail(
                                    teachCaseModel.data[item].id,
                                    teachCaseModel.data[item].title,
                                    teachCaseModel.data[item].user.name,
                                    teachCaseModel.data[item].ctime,
                                    teachCaseModel.data[item].browse_count,
                                    teachCaseModel.data[item].content,
                                    teachCaseModel.data[item].user.avatar,
                                ));
                          },
                        ),
                      );
                    }),
              );
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text('安全案例'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listView,
    );
  }
}
