import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/navigateUtil.dart';

class ExaminationItem extends StatelessWidget {
  final int id;
  final String quesiotn;
  final String answer;

  const ExaminationItem(
      {Key key,
      @required this.id,
      @required this.quesiotn,
      @required this.answer})
      : assert(id != null),
        assert(quesiotn != null),
        assert(answer != null);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2280)..init(context);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.black26),
          color: Colors.white),
      width: ScreenUtil().setWidth(1020),
      child: ListTile(
        trailing: Image.asset('images/main/a_ckda@3x.png',width: 20.0,),
        title: Text(quesiotn),
        onTap: () {
          showAlertDialog(context);
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    NavigatorState navigator =
        context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    debugPrint("navigator is null?" + (navigator == null).toString());

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
                title: new Text("答案"),
                content: new Text(answer),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("我知道了!"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }
}
