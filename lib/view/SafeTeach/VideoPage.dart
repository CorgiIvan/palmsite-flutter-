import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/navigateUtil.dart';
import 'VideoDetail.dart';
import '../../model/TeachVideoModel.dart';
import '../../UI/LoadingWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import '../../utils/HttpGo.dart';

class StudyOnlinePage extends StatefulWidget {
  State<StatefulWidget> createState() => _StudyOnlineState();
}

class _StudyOnlineState extends State<StudyOnlinePage> {
  TeachVideoModel teachVideoModel;
  var _futureBuilderFuture;
  bool isGet = true;
  int page = 1; //获取的页数

  @override
  void initState() {
    super.initState();
    ///用_futureBuilderFuture来保存_gerData()的结果，以避免不必要的ui重绘
    _futureBuilderFuture =
        HttpGo().post("/ss/api.teach_video/find.html", (data) {
          setState(() {
            teachVideoModel = TeachVideoModel.fromJson(data);
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
      response = await HttpGo().dio.post("/ss/api.teach_video/find.html",data: formData1);
      setState(() {
        teachVideoModel = TeachVideoModel.fromJson(response.data);
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
      response = await HttpGo().dio.post("/ss/api.teach_video/find.html",data: formData1);
      setState(() {
        TeachVideoModel teachVideoModel2 = TeachVideoModel.fromJson(response.data);
        teachVideoModel.data += teachVideoModel2.data;
        HttpGo().showToast('加载成功');
      });
    } on DioError catch (e) {
      HttpGo().showToast('加载失败');
    }
  }

  /**
   * 绘制界面
   */
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final listView = Center(
        child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (teachVideoModel == null) {
                if (isGet) {
                  return LoadingWidget().childWidget();
                } else {
                  return LoadingWidget().defeatWidget();
                }
              } else {
                return Refresh(
                  onHeaderRefresh: _onRefresh,
                  onFooterRefresh: _getdata,
                  child: ListView.builder(
                      itemCount: teachVideoModel.data.length,
                      itemBuilder: (context, item) {
                        return Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.2, color: Colors.black26),
                              color: Colors.white),
                          child: ListTile(
                            leading: Image.network(
                              HttpGo.URL + '/upload'+
                                  teachVideoModel.data[item].pic,
                              width: ScreenUtil().setWidth(210),
                              height: 60,
                            ),
                            title: Text(teachVideoModel.data[item].name),
                            subtitle: Text('2018-12.0.3'),
                            onTap: () {
                              navigate().navigateToMain(
                                  context,
                                  StudyOnlineDetail(
                                      teachVideoModel.data[item].id,
                                      teachVideoModel.data[item].name,
                                      teachVideoModel.data[item].intro));
                            },
                          ),
                        );
                      }),
                );
              }
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text('安全视频'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listView,
    );
  }
}
