import 'package:flutter/material.dart';
import '../utils/FuckingDioUtil.dart';
import '../model/ArchivesBean.dart';
import '../UI/LoadingWidget.dart';
import '../model/SiteSupervisionModel.dart';
import 'AsideSupervision/QRCodeDetail.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/navigateUtil.dart';
import 'AsideSupervision/QRCodeVideo.dart';
import '../utils/HttpGo.dart';
import 'package:dio/dio.dart';

class QRScanPage extends StatefulWidget {
  QRScanPage(this.type, this.id);
  final int type;
  final String id;
  State<StatefulWidget> createState() => _QRScanState();
}

class _QRScanState extends State<QRScanPage> {
  var _futureBuilder;
  ArchivesBean _archivesBean;
  SiteSupervision siteSupervision;
  VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isShowQR = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == 3) {
      _futureBuilder =
          HttpGo().post("/ss/api.site_supervision/find.html", (data) {
        Navigator.pop(context);
        HttpGo().showToast(data['msg']);
        setState(() {
          siteSupervision = SiteSupervision.fromJson(data);
          _controller = VideoPlayerController.network(
            HttpGo.URL + '/upload'+
                siteSupervision.data[0].video,
          )
            ..addListener(() {
              final bool isPlaying = _controller.value.isPlaying;
              if (isPlaying != _isPlaying) {
                setState(() {
                  _isPlaying = isPlaying;
                });
              }
            })
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            });
        });
      }, errorCallBack: (error) {
        Navigator.pop(context);
      }, params: FormData.from({"id": widget.id}));

//      _futureBuilder = FuckingDioUtil().postTwoNoMap1withCookie(
//          "/origin/api.user/login.html",
//          "/ss/api.site_supervision/find.html",
//          {"id": widget.id}).then((response) {
//        siteSupervision = SiteSupervision.fromJson(response.data);
//        _controller = VideoPlayerController.network(
//          "http://www.feebird.cn:21105/upload" + siteSupervision.data[0].video,
//        )
//          ..addListener(() {
//            final bool isPlaying = _controller.value.isPlaying;
//            if (isPlaying != _isPlaying) {
//              setState(() {
//                _isPlaying = isPlaying;
//              });
//            }
//          })
//          ..initialize().then((_) {
//            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//            setState(() {});
//          });
//      });
    } else {
      HttpGo().post('/am/api.archives.tenders/find', (data) {
        setState(() {
          _archivesBean = ArchivesBean.fromJson(data);
        });
      }, params: {'id': widget.id});

//      _futureBuilder = FuckingDioUtil().postTwoNoMap1withCookie(
//          '/origin/api.user/login',
//          '/am/api.archives.tenders/find',
//          {'id': widget.id}).then((response) {
//        _archivesBean = ArchivesBean.fromJson(response.data);
//      });
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('档案检索'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: FutureBuilder(
          future: _futureBuilder,
          builder: (context, snapshot) {
            if (_archivesBean == null && siteSupervision == null) {
              return LoadingWidget().childWidget();
            } else {
              if (widget.type == 1) {
                return Padding(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0),
                  child: ListView(
                    children: <Widget>[
                      ListTile('档案存放位置', _archivesBean.data[0].archives.number),
                      Container(
                        height: 0.3,
                        color: Colors.grey,
                      ),
                      ListTile('档案名称', _archivesBean.data[0].archives.name),
                      Container(
                        height: 0.3,
                        color: Colors.grey,
                      ),
                      ListTile('档案概述', _archivesBean.data[0].archives.overview),
                      Container(
                        height: 0.3,
                        color: Colors.grey,
                      ),
                      ListTile('档案目录', '暂无此数据'),
                    ],
                  ),
                );
              } else if (widget.type == 2) {
                return Padding(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0),
                  child: ListView(
                    children: <Widget>[
                      ListTile('档案存放位置', _archivesBean.data[0].archives.number),
                      Container(
                        height: 0.3,
                        color: Colors.grey,
                      ),
                      ListTile('档案名称', _archivesBean.data[0].archives.name),
                      Container(
                        height: 0.3,
                        color: Colors.grey,
                      ),
                      ListTile('档案概述', _archivesBean.data[0].archives.overview)
                    ],
                  ),
                );
              } else {
                Widget Video = Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 8.0, left: 8.0, bottom: 4.0, right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.2, color: Colors.black26)),
                            color: Colors.white),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(500),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "images/main/pangzhanjianli/a_sp@3x.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    Text(
                                      '  视频',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _controller.value.initialized
                                      ? AspectRatio(
                                          aspectRatio:
                                              _controller.value.aspectRatio,
                                          child: VideoPlayer(_controller),
                                        )
                                      : Container(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: MaterialButton(
                                  onPressed:
//                      _controller.value.isPlaying
//                          ? _controller.pause
//                          : _controller.play,
                                      () {
                                    navigate().navigateToMain(
                                        context,
                                        QRCodeVideo(
                                            siteSupervision.data[0].video));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
                return ListView(
                  children: <Widget>[
                    ContentSearchItem('images/main/SafeRecord/a_yhbh@3x.png',
                        '安全巡视员ID', siteSupervision.data[0].user.id.toString()),
                    ContentSearchItem('images/main/HiddenPushPage/a_fzr@3x.png',
                        '巡视员姓名', siteSupervision.data[0].user.name.toString()),
                    ContentSearchItem(
                        'images/main/pangzhanjianli/a_lzsj@3x.png',
                        '录制时间',
                        siteSupervision.data[0].record_time.toString()),
                    ContentSearchItem(
                        'images/main/pangzhanjianli/a_lzwz@3x.png',
                        '录制位置',
                        siteSupervision.data[0].record_position.toString()),
                    ContentSearchItem(
                        'images/main/pangzhanjianli/a_spmc@3x.png',
                        '视频名称',
                        siteSupervision.data[0].video_title.toString()),
                    Video,
                    ContentSearchItem('images/main/pangzhanjianli/a_gd@3x.png',
                        '工点名称', siteSupervision.data[0].wp_name.toString()),
                    ContentSearchItem(
                        'images/main/pangzhanjianli/a_ysyq@3x.png',
                        '验收要求',
                        siteSupervision.data[0].acceptance_requirements
                            .toString()),
                    ContentSearchItem(
                        'images/main/pangzhanjianli/a_jlry@3x.png',
                        '监理人员',
                        siteSupervision.data[0].supervisor_staff.toString()),
                    ContentSearchItem(
                        'images/main/pangzhanjianli/a_jrxxsc@3x.png',
                        '旁站监理时间',
                        siteSupervision.data[0].time.toString()),
                    ContentSearchItem(
                        'images/main/pangzhanjianli/a_sgdw@3x.png',
                        '施工单位',
                        siteSupervision.data[0].construction_unit.toString()),
                  ],
                );
              }
            }
          }),
    );
  }
}

class ListTile extends StatelessWidget {
  final String title;
  final String widget;
  const ListTile(this.title, this.widget);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        title + ":" + widget,
        style: TextStyle(fontSize: 17.0),
      ),
    );
  }
}
