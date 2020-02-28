import 'package:flutter/material.dart';

class ServiceDetail extends StatefulWidget {
  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
//  final String title;
//  final String content;

//  const knowledgeDetail({Key key, @required this.title, @required this.content})
//      : assert(title != null),
//        assert(content != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('服务'), centerTitle: true),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Center(
                      child: Text(
                    '什么是flutter',
                    style: TextStyle(fontSize: 20.0),
                  )),
                ),
                Text(
                  '    Flutter是谷歌的移动UI框架，可以快速在iOS和Android上构建高质量的原生用户界面。 Flutter可以与现有的代码一起工作。在全世界，Flutter正在被越来越多的开发者和组织使用，并且Flutter是完全免费、开源的。',
                  softWrap: true,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ));
  }
}
