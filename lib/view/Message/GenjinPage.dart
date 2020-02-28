import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../model/SafeRectifyModel.dart';
import '../../utils/HttpGo.dart';
import 'package:dio/dio.dart';

class GenjinPage extends StatefulWidget {
  final int Id;
  const GenjinPage(this.Id);
  @override
  State<StatefulWidget> createState() => _GenjinState();
}

class _GenjinState extends State<GenjinPage> {
  Widget buildList;
  SafeRectifyModel safeRectify;
  var _futureBuilder;

  @override
  void initState() {
    super.initState();
    _futureBuilder = HttpGo().post("/ss/api.safe_rectify/find.html",
            (data) {
          setState(() {
            safeRectify = SafeRectifyModel.fromJson(data);
            getTitle();
          });
        },
        errorCallBack: (error) {},
        params: FormData.from({'safe_hidden_id': widget.Id}));
  }

  void getTitle() {
    Widget build() {
      List<Widget> tiles = [];
      Widget content;
      for (int item = 0; item < safeRectify.data.length; item++) {
        tiles.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(safeRectify.data[item].ctime),
            Text(
              safeRectify.data[item].content,
              style: TextStyle(fontSize: 16),
            ),
            Container(
              height: 10,
            )
          ],
        ));
      }
      content = Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tiles,
        ),
      );
      return content;
    }

    buildList = build();
  }

  @override
  Widget build(BuildContext context) {
    final listView = Container(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 0.5, color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'images/main/message/p_zgnr@3x.png',
                      width: 15,
                      height: 15,
                    ),
                    Text('  信息内容')
                  ],
                ),
              ),
              FutureBuilder(
                  future: _futureBuilder,
                  builder: (context, snapshot) {
                    return Container(
                      child: buildList,
                    );
                  }),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('跟踪信息'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listView,
    );
  }
}
