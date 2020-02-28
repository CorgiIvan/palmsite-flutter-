import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'safeteach/KnowledgePage.dart';
import 'safeteach/ExaminationPage.dart';
import 'safeteach/VideoPage.dart';
import 'safeteach/EvaluationPage.dart';
import 'safeteach/CasePage.dart';
import 'SecurityPatrol/SecurityPatrolPage.dart';
import 'SecurityPatrol/HiddenPushPage.dart';
import 'SecurityPatrol/ContentSearchPage.dart';
import 'AsideSupervision/QRCodePage.dart';
import 'AsideSupervision/PalmInformationPage.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'SafeTeach/SummitChoicePage.dart';
import 'QRScanPage.dart';
import '../utils/navigateUtil.dart';
import 'message/ListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/HttpGo.dart';
import 'package:dio/dio.dart';
import '../utils/FuckingDioUtil.dart';
import '../model/CarouselModel.dart';
import '../UI/LoadingWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String barcode = "";
  var _futureBuilderFuture;
  CarouselBean carouselBean;
  int a = 0;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture =
      HttpGo().post("/ss/api.carousel/find", (data) {
        setState(() {
          carouselBean = CarouselBean.fromJson(data);
        });
      }, params: FormData.from({"advertisement": 1}));
    ;
//    _futureBuilderFuture = FuckingDioUtil().postTwoNoMap1withCookie(
//        "/origin/api.user/login.html",
//        "/ss/api.carousel/find",
//        {"advertisement": 1}).then((response) {
//      carouselBean = CarouselBean.fromJson(response.data);
//    });
  }

  /**
   * 二维码扫描器
   */
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print("扫描出来的东西有" + barcode);
      String str = 'type';
      String str2 = ',';
      String type =
          barcode.substring(barcode.indexOf(str) + 6, barcode.length - 1);
      String id = barcode.substring(7, barcode.indexOf(str2) - 1);
      setState(() {
        if (type == '1') {
          navigate().navigateToMain(context, QRScanPage(1, id));
        } else if (type == '2') {
          navigate().navigateToMain(context, QRScanPage(2, id));
        } else if (type == '3') {
          navigate().navigateToMain(context, QRScanPage(3, id));
        } else {
          Fluttertoast.showToast(
              msg: '请扫描指定的二维码',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white);
        }
        return this.barcode = barcode;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: '请扫描指定的二维码',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          return this.barcode = '没有照相机权限!';
        });
      } else {
        setState(() {
          return this.barcode = '位置的错误: $e';
        });
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
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

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              scan();
            },
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
              child: Image.asset('images/main/erwm@3x.png'),
            ),
          ),
          title: Text('首页'),
          centerTitle: true,
          elevation: 0.0,
          actions: <Widget>[
            Center(
              child: InkWell(
                onTap: () {
                  navigate().navigateToMain(context, ListPage());
                },
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                  child: Image.asset('images/main/info_n@3x.png'),
                ),
              ),
            )
          ],
        ),
        body: ListView(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: ScreenUtil().setHeight(400),
            child: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (carouselBean == null) {
                    return LoadingWidget().childWidget();
                  } else {
                    /**
                     * 轮播图
                     */
                    return Swiper(
                        itemBuilder: _swiperBuilder,
                        itemCount: carouselBean.data.length,
                        pagination: new SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                          color: Colors.black54,
                          activeColor: Colors.white,
                        )),
//                control: new SwiperControl(),
                        scrollDirection: Axis.horizontal,
                        autoplay: true,
                        onTap: (index) => print('点击了第$index个'));
                  }
                }),
          ),
          BuildText(text: '安全教育'),
          Padding(
            padding: EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BuildPiece(
                  text: '安全知识',
                  color: Colors.green[300],
                  image: 'images/main/icon6.png',
                  widget: knowledgePage(),
                ),
                BuildPiece(
                    text: '安全案例',
                    color: Colors.redAccent[200],
                    image: 'images/main/icon1.png',
                    widget: SafetyCasePage()),
                BuildPiece(
                    text: '安全视频',
                    color: Colors.blue[600],
                    image: 'images/main/icon4.png',
                    widget: StudyOnlinePage())
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BuildPiece(
                  text: '在线考试',
                  color: Colors.blue[200],
                  image: 'images/main/icon3.png',
                  widget: SummitExamChoicePage()),
              BuildPiece(
                  text: '考试题库',
                  color: Colors.orange[200],
                  image: 'images/main/icon5.png',
                  widget: examinationPage()),
              BuildPiece(
                  text: '学习评估',
                  color: Colors.purple[200],
                  image: 'images/main/icon2.png',
                  widget: StudyEvaluationPage()),
            ],
          ),
          BuildText(text: '安全巡视'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BuildPieceStyle2(
                  text: '安全巡视',
                  image: 'images/main/tuis.png',
                  widget: SecurityPatrolPage()),
              BuildPieceStyle2(
                  text: '隐患推送',
                  image: 'images/main/jians.png',
                  widget: HiddenPushPage()),
              BuildPieceStyle2(
                  text: '内容检索',
                  image: 'images/main/jil.png',
                  widget: ContentSearchPage())
            ],
          ),
          BuildText(text: '旁站监理'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BuildPieceStyle2(
                  text: '工点信息',
                  image: 'images/main/car.png',
                  widget: PalmInformationPage()),
              BuildPieceStyle2(
                  text: '二维码',
                  image: 'images/main/eweim.png',
                  widget: QRCodePage())
            ],
          )
        ]));
  }

  _getcookie() async {
//    Future<String> cookie = getCookie();
//    cookie.then((String cookie) {
    /**
     * 失败方法一号
     */
//    List<String> cookie;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    cookie = prefs.getStringList('cookies');
//    Options options = Options(method: "POST", headers: {
//      "Cookies": cookie,
//    });

    /**
     * 失败方法二号
     */
//    var response =
//        HttpUtil.getInstance().post("/logged.html", options: options);

//    })
    /**
     * 失败方法三号
     */
//    var client = http.Client();
//    client.post("http://www.feebird.cn:21105/origin/api.user/logged.html").then((response){
//      print("Response body: ${response.body}");
//    });
//    Response response = await dio.post(
//      "http://www.feebird.cn:21105/origin/api.user/logged.html",
//    );
//    print('后来的cookie是========' + response.headers['set-cookie'].toString());
//    print("保存起来的cookies是============" + prefs.getString('cookie'));
//    print("响应结果是============" + response.data.toString());

    /**
     * 我放弃了...使用了最垃圾解决办法
     */
  }
}

class BuildText extends StatelessWidget {
  final String text;

  const BuildText({@required this.text}) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(text, style: TextStyle(fontSize: 17.0))),
    );
  }
}

class BuildPiece extends StatelessWidget {
  final String text;
  final Color color;
  final String image;
  final Widget widget;

  const BuildPiece(
      {@required this.text,
      @required this.color,
      @required this.image,
      @required this.widget})
      : assert(text != null),
        assert(color != null),
        assert(image != null),
        assert(widget != null);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);
    return Container(
        width: ScreenUtil().setWidth(350),
        color: color,
        child: Padding(
            padding: EdgeInsets.all(7),
            child: InkWell(
              onTap: () {
                navigate().navigateToMain(context, widget);
              },
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(text,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(image,
                          height: ScreenUtil().setHeight(100),
                          fit: BoxFit.cover)
                    ],
                  )
                ],
              ),
            )));
  }
}

class BuildPieceStyle2 extends StatelessWidget {
  final String text;
  final String image;
  final Widget widget;

  const BuildPieceStyle2(
      {@required this.text, @required this.image, @required this.widget})
      : assert(text != null),
        assert(image != null),
        assert(widget != null);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);
    return Container(
      width: ScreenUtil().setWidth(360),
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.black26),
          color: Colors.white),
      child: InkWell(
        onTap: () {
          navigate().navigateToMain(context, widget);
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
              child: Image.asset(
                image,
                height: ScreenUtil().setHeight(120),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Text(text, style: TextStyle(fontSize: 17)),
            )
          ],
        ),
      ),
    );
  }
}
