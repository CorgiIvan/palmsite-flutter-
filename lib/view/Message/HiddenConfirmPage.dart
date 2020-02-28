import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/navigateUtil.dart';
import 'GenjinPage.dart';
import 'ZhenggaiPage.dart';
import '../../utils/HttpGo.dart';

class ContentSearchItem extends StatelessWidget {
  final String imgStr;

  final String textStr;
  final String answerStr;
  const ContentSearchItem(this.imgStr, this.textStr, this.answerStr);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);
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
                      width: ScreenUtil().setWidth(450),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            imgStr,
                            width: 25,
                            height: 25,
                          ),
                          Container(
                            child: Text(
                              '  ' + textStr + '  ',
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        answerStr,
                        style: TextStyle(color: Colors.grey, fontSize: 17.0),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}

class HiddenConfirmPage extends StatelessWidget {
  final int Id;
  final String Title;
  final String Content;
  final String Recordtime;
  final String Workpoint;
  final String Name;
  final String Mobile;
  final String Constructionunit;
  final String leader;
  final String evidence;

  const HiddenConfirmPage(
      this.Id,
      this.Title,
      this.Content,
      this.Recordtime,
      this.Workpoint,
      this.Name,
      this.Mobile,
      this.Constructionunit,
      this.leader,
      this.evidence);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('隐患详情'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 1.0,
            ),
            ContentSearchItem(
                'images/main/SafeRecord/a_yhbh@3x.png', '隐患编号', Id.toString()),
            ContentSearchItem(
                'images/main/SafeRecord/a_bt@3x.png', '标题', Title),
            ContentSearchItem(
                'images/main/SafeRecord/a_nr@3x.png', '内容', Content),
            ContentSearchItem(
                'images/main/HiddenPushPage/a_lzsj@3x.png', '时间', Recordtime),
            ContentSearchItem(
                'images/main/HiddenPushPage/a_gd@3x.png', '工点', Workpoint),
            ContentSearchItem(
                'images/main/HiddenPushPage/a_tsr@3x.png', '巡视员姓名', Name),
            ContentSearchItem(
                'images/main/SafeRecord/a_lxdh@3x.png', '电话', Mobile),
            ContentSearchItem('images/main/HiddenPushPage/a_sgdw@3x.png',
                '施工单位', Constructionunit),
            ContentSearchItem(
                'images/main/HiddenPushPage/a_fzr@3x.png', '负责人', leader),
            Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 8.0, left: 8.0, bottom: 4.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 0.2, color: Colors.black26)),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(450),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/main/HiddenPushPage/a_qz@3x.png',
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  '  取证',
                                  style: TextStyle(fontSize: 16.0),
                                )
                              ],
                            ),
                          ),
                          Image.network(
                            HttpGo.URL + '/upload'+ evidence,
                            height: 100.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.black26, width: 0.3),
                        right: BorderSide(color: Colors.black26, width: 0.15))),
                child: InkWell(
                  onTap: () {
                    navigate().navigateToMain(context, ZhenggaiPage(Id));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/main/a_lb@3x.png',
                          width: 17,
                          height: 17,
                        ),
                        Text(
                          '  整改',
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ),
            Container(
              child: Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.black26, width: 0.3),
                        left: BorderSide(color: Colors.black26, width: 0.15))),
                child: InkWell(
                  onTap: () {
                    navigate().navigateToMain(context, GenjinPage(Id));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/main/a_lb@3x.png',
                          width: 17,
                          height: 17,
                        ),
                        Text('  跟进', style: TextStyle(fontSize: 15.0))
                      ],
                    ),
                  ),
                ),
              )),
            ),
          ],
        ));
  }
}
