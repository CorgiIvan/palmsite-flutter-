import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palm_sitt_for_flutter/utils/navigateUtil.dart';
import 'ServiceDetai.dart';

class ServicePage extends StatefulWidget {
  State<StatefulWidget> createState() => _ServiceState();
}

class _ServiceState extends State<ServicePage> {
  var _List = List();
  var _ListPic = List();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    final listWidget = Container(
        child: ListView.builder(
            itemCount: _List.length,
            itemBuilder: (context, item) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.2, color: Colors.black26),
                    color: Colors.white),
                child: ListTile(
                  leading: Image.asset(_ListPic[item],height: 25,width: 25,),
                  title: Text(_List[item]),
                  trailing: Image.asset(
                    'images/main/a_fhw@3x.png',
                    height: 15,
                  ),
                  onTap: () {
                    navigate().navigateToMain(context, ServiceDetail());
                  },
                ),
              );
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text('服务'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: listWidget,
    );
  }

  @override
  void initState() {
    super.initState();
    _List = ['操作手册'
//    , '平台意见反馈'
    ];
    _ListPic = ['images/main/a_czsc@3x.png'
//    , 'images/main/a_yjfk@3x.png'
    ];
  }
}
