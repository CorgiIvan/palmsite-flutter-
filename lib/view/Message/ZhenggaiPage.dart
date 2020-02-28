import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/navigateUtil.dart';
import '../../UI/LoadingDialog.dart';
import '../../utils/FuckingDioUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/HttpGo.dart';
import 'package:dio/dio.dart';

class ZhenggaiPage extends StatefulWidget {
  final int Id;
  const ZhenggaiPage(this.Id);
  @override
  State<StatefulWidget> createState() => _ZhenggaiState();
}

class _ZhenggaiState extends State<ZhenggaiPage> {
  TextEditingController _Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void post() {
      Map<String, dynamic> data = {
        'safe_hidden_id': widget.Id,
        'content': _Controller.text,
      };
      if (_Controller.text.isEmpty) {
        Fluttertoast.showToast(
            msg: '整改信息不能为空',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      } else {
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new LoadingDialog(
                //调用对话框
                text: '正在上传...',
              );
            });
        HttpGo().post("/ss/api.safe_rectify/add", (data) {
          Navigator.pop(context);
          Navigator.pop(context);
          HttpGo().showToast(data['msg']);
        }, errorCallBack: (error) {
          Navigator.pop(context);
        }, params: FormData.from(data));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('整改信息'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(500),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.5, color: Colors.grey[300]),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: ListView(
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
                        Text('  整改内容')
                      ],
                    ),
                  ),
                  TextField(
                    controller: _Controller,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(6.0),
                        border: InputBorder.none,
                        hintText: '请输入整改内容!'),
                    autofocus: false,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          post();
                        },
                        child: Text(
                          "提交",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
