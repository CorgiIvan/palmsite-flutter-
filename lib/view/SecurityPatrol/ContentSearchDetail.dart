import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentSearchDetail extends StatefulWidget {
  final String wx_open_id;
  final String name;
  final String telephone;
  final String title;
  final String content;
  final String resulte;
  const ContentSearchDetail(this.wx_open_id, this.name, this.telephone,
      this.title, this.content, this.resulte);
  @override
  State<StatefulWidget> createState() => _ContentSearchDetailState();
}

class _ContentSearchDetailState extends State<ContentSearchDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('内容详情'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 10,
          ),
          ContentSearchItem('images/main/SafeRecord/a_yhbh@3x.png', '安全巡视员ID',
              widget.wx_open_id),
          ContentSearchItem(
              'images/main/HiddenPushPage/a_fzr@3x.png', '巡视员姓名', widget.name),
//          ContentSearchItem('images/main/SafeRecord/a_xb@3x.png', '性别', '男'),
          ContentSearchItem(
              'images/main/SafeRecord/a_lxdh@3x.png', '联系电话', widget.telephone),
          ContentSearchItem(
              'images/main/SafeRecord/a_bt@3x.png', '标题', widget.title),
          ContentSearchItem(
              'images/main/SafeRecord/a_nr@3x.png', '内容', widget.content),
          ContentSearchItem(
              'images/main/SafeRecord/a_xcjl@3x.png', '巡查结论', widget.resulte),
        ],
      ),
    );
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
                      width: ScreenUtil().setWidth(500),
                      child: Text(
                        answerStr,
                        softWrap: true,
                        style: TextStyle(color: Colors.grey, fontSize: 17.0),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
