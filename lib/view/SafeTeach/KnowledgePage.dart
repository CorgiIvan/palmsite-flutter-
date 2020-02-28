import 'package:flutter/material.dart';
import 'KnowledgeItem.dart';
import '../../model/TeachKnowledgeModel.dart';
import '../../model/CarouselModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../UI/LoadingWidget.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import '../../utils/HttpGo.dart';

class knowledgePage extends StatefulWidget {
  State<StatefulWidget> createState() => _knowledgeState();
}

class _knowledgeState extends State<knowledgePage> {
  KnowledgeBean knowledgeData; //知识列表bean
  CarouselBean carouselBean; //轮播列表bean
  var _futureBuilderFuture; //页面启动请求数据
  bool isGet = true; //是否获取到数据
  int page = 1; //获取的页数

  @override
  void initState() {
    super.initState();

    ///用_futureBuilderFuture来保存_gerData()的结果，以避免不必要的ui重绘
    _futureBuilderFuture =
        HttpGo().post("/ss/api.teach_know/find.html", (data1) {
      HttpGo().post("/ss/api.carousel/find", (data2) {
        setState(() {
          knowledgeData = KnowledgeBean.fromJson(data1);
          carouselBean = CarouselBean.fromJson(data2);
        });
      }, params: FormData.from({'advertisement': 2}));
    }, params: FormData.from({'page': 1}));
//    _futureBuilderFuture = FuckingDioUtil().postThreeNoMap1withCookie(
//        "/origin/api.user/login.html",
//        "/ss/api.teach_know/find.html",
//        "/ss/api.carousel/find",
//        {'page': 1, 'advertisement': 2}).then((ListResponse) {
//      if (ListResponse == false) {
//        isGet = false;
//      } else {
//        isGet = true;
//        knowledgeData = KnowledgeBean.fromJson(ListResponse[0].data);
//        carouselBean = CarouselBean.fromJson(ListResponse[1].data);
//      }
//    });
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {
    Response response;
    page = 1;
    FormData formData1 = FormData.from({'page': page});
    try {
      response = await HttpGo().dio.post("/ss/api.teach_know/find.html",data: formData1);
      setState(() {
        knowledgeData = KnowledgeBean.fromJson(response.data);
        print(knowledgeData);
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
      response = await HttpGo().dio.post("/ss/api.teach_know/find.html",data: formData1);
      setState(() {
        KnowledgeBean knowledgeData2 = KnowledgeBean.fromJson(response.data);
        knowledgeData.data += knowledgeData2.data;
        print(knowledgeData);
        HttpGo().showToast('加载成功');
      });
    } on DioError catch (e) {
      HttpGo().showToast('加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    Widget _swiperBuilder(BuildContext context, int index) {
      return (Image.network(
        HttpGo.URL + '/upload'+ carouselBean.data[index].pic,
        fit: BoxFit.fill,
      ));
    }

    final listView = Center(
        child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if ((knowledgeData == null) || (carouselBean == null)) {
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
                    itemCount: knowledgeData.data.length,
                    itemBuilder: (context, item) {
                      if (item == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: ScreenUtil().setHeight(400),
                                  child: Swiper(
                                      itemBuilder: _swiperBuilder,
                                      itemCount: carouselBean.data.length,
                                      pagination: new SwiperPagination(
                                          builder: DotSwiperPaginationBuilder(
                                        color: Colors.black54,
                                        activeColor: Colors.white,
                                      )),
//                                  control: new SwiperControl(),
                                      scrollDirection: Axis.horizontal,
                                      autoplay: true,
                                      onTap: (index) => print('点击了第$index个'))),
                            ),
                            knowledgeItem(
                              imgStr: HttpGo.URL + '/upload'+
                                  knowledgeData.data[item].pic,
                              id: knowledgeData.data[item].id,
                              title: knowledgeData.data[item].title,
                              content: knowledgeData.data[item].content,
                              browse_count:
                                  knowledgeData.data[item].browse_count,
                              classify: knowledgeData.data[item].classify.name,
                              name: knowledgeData.data[item].user.name,
                              ctime: knowledgeData.data[item].ctime,
                              avator: knowledgeData.data[item].user.avatar,
                            )
                          ],
                        );
                      } else {
                        return knowledgeItem(
                          imgStr: HttpGo.URL + '/upload'+
                              knowledgeData.data[item].pic,
                          id: knowledgeData.data[item].id,
                          title: knowledgeData.data[item].title,
                          content: knowledgeData.data[item].content,
                          browse_count: knowledgeData.data[item].browse_count,
                          classify: knowledgeData.data[item].classify.name,
                          name: knowledgeData.data[item].user.name,
                          ctime: knowledgeData.data[item].ctime,
                          avator: knowledgeData.data[item].user.avatar,
                        );
                      }
                    },
                  ),
                );
              }
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text('安全知识'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listView,
    );
  }
}
