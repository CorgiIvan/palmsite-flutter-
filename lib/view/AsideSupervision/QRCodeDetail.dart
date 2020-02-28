import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/navigateUtil.dart';
import 'QRCodeVideo.dart';
import '../../utils/HttpGo.dart';

class QRCodeDetail extends StatefulWidget {
  final String wx_open_id;
  final String name;
  final String record_time;
  final String record_position;
  final String video_title;
  final String video;
  final String wp_name;
  final String acceptance_requirements;
  final String supervisor_staff;
  final String time;
  final String construction_unit;

  const QRCodeDetail(
      this.wx_open_id,
      this.name,
      this.record_time,
      this.record_position,
      this.video_title,
      this.video,
      this.wp_name,
      this.acceptance_requirements,
      this.supervisor_staff,
      this.time,
      this.construction_unit);
  @override
  State<StatefulWidget> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCodeDetail> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isShowQR = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      HttpGo.URL + '/upload'+ widget.video,
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
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final Video = Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding:
              EdgeInsets.only(top: 8.0, left: 8.0, bottom: 4.0, right: 8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.2, color: Colors.black26)),
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
//                  Container(
//                    height: 100,
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: _controller.value.initialized
//                          ? AspectRatio(
//                              aspectRatio: _controller.value.aspectRatio,
//                              child: VideoPlayer(_controller),
//                            )
//                          : Container(),
//                    ),
//                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: InkWell(
                      onTap:
//                      _controller.value.isPlaying
//                          ? _controller.pause
//                          : _controller.play,
                      (){
                        navigate().navigateToMain(context, QRCodeVideo(widget.video));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0))),
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

    final QRBtn = Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Row(
          children: <Widget>[
            new Expanded(
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    _isShowQR = true;
                  });
                },
                child: Text(
                  "生成二维码",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('二维码详情页面'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                ContentSearchItem('images/main/SafeRecord/a_yhbh@3x.png',
                    '安全巡视员ID', widget.wx_open_id),
                ContentSearchItem('images/main/HiddenPushPage/a_fzr@3x.png',
                    '巡视员姓名', widget.name),
                ContentSearchItem('images/main/pangzhanjianli/a_lzsj@3x.png',
                    '录制时间', widget.record_time),
                ContentSearchItem('images/main/pangzhanjianli/a_lzwz@3x.png',
                    '录制位置', widget.record_position),
                ContentSearchItem('images/main/pangzhanjianli/a_spmc@3x.png',
                    '视频名称', widget.video_title),
                Video,
                ContentSearchItem('images/main/pangzhanjianli/a_gd@3x.png',
                    '工点名称', widget.wp_name),
                ContentSearchItem('images/main/pangzhanjianli/a_ysyq@3x.png',
                    '验收要求', widget.acceptance_requirements),
                ContentSearchItem('images/main/pangzhanjianli/a_jlry@3x.png',
                    '监理人员', widget.supervisor_staff),
                ContentSearchItem('images/main/pangzhanjianli/a_jrxxsc@3x.png',
                    '旁站监理时间', widget.time),
                ContentSearchItem('images/main/pangzhanjianli/a_sgdw@3x.png',
                    '施工单位', widget.construction_unit),
                QRBtn,
              ],
            ),
            _isShowQR
                ? Container(
                    color: Color(0x501A1A1A),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            color: Colors.white,
                            child: QrImage(
                              data: '数据',
                              size: ScreenUtil().setHeight(550),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: FloatingActionButton(
                            backgroundColor: Colors.black,
                            onPressed: () {
                              setState(() {
                                _isShowQR = false;
                              });
                            },
                            child: Icon(Icons.close),
                          ),
                        )
                      ],
                    )),
                  )
                : Container()
          ],
        ));
  }
}

class ContentSearchItem extends StatelessWidget {
  const ContentSearchItem(this.imgStr, this.textStr, this.answerStr);

  final String imgStr;
  final String textStr;
  final String answerStr;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding:
              EdgeInsets.only(top: 8.0, left: 8.0, bottom: 4.0, right: 8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.2, color: Colors.black26)),
                color: Colors.white),
            child: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 160,
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            imgStr,
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            '  ' + textStr + '  ',
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        answerStr,
                        style: TextStyle(color: Colors.grey, fontSize: 17.0),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
