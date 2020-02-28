import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../utils/HttpGo.dart';

class QRCodeVideo extends StatefulWidget {
  final String video;
  const QRCodeVideo(this.video);
  @override
  State<StatefulWidget> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCodeVideo> {
  VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      HttpGo.URL + '/upload'+ widget.video,
    )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
//        if (isPlaying != _isPlaying) {
//          setState(() {
//            _isPlaying = isPlaying;
//          });
//        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.play();
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
        title: Text('视频回放'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VideoPlayer(_controller)),
      ),
    );
  }
}
