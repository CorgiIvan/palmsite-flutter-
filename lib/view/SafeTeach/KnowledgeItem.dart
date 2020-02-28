import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'KnowledgeDetail.dart';
import '../../utils/navigateUtil.dart';

class knowledgeItem extends StatelessWidget {
  final String imgStr;
  final int id;
  final int browse_count;
  final String title;
  final String content;
  final String classify;
  final String name;
  final String ctime;
  final String avator;

  const knowledgeItem(
      {Key key,
      @required this.imgStr,
      @required this.browse_count,
      @required this.id,
      @required this.title,
      @required this.content,
      @required this.classify,
      @required this.name,
      @required this.ctime,
      @required this.avator})
      : assert(id != null),
        assert(title != null),
        assert(content != null);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.black26),
          color: Colors.white),
      child: ListTile(
        leading: Image.network(
          imgStr,
          width: 100,
          height: 60,
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 6.0),
          child: Text(title),
        ),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                  child: Container(
                    child: Text(
                      classify,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              browse_count.toString() + '浏览',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
        onTap: () {
//          navigate().navigateToStateless(context, TestWebView());
          navigate().navigateToMain(
              context,
              knowledgeDetail(
                  id,title, content, browse_count, classify, name, ctime,avator));
        },
      ),
    );
  }
}
