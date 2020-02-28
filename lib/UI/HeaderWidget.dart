  import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:convert';

class HeaderWidget {
  Uint8List bytes;
  Map<String, dynamic> user;
  /**
   * 获取cookie数据
   */
  Future getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    String password = prefs.getString('password');
    String avatar = prefs.getString('avatar');
    String name = prefs.getString('name');
    String mobile = prefs.getString('mobile');
    int id = prefs.getInt('id');
    print('数据' + name);
    var prefix = "data:image/jpeg;base64,";
    avatar = avatar.substring(prefix.length);
    bytes = base64.decode(avatar);
    user = {
      'id': id,
      "username": username,
      "password": password,
      "avatar": bytes,
      "name": name,
      "mobile": mobile
    };
    return user;
  }

  /**
   * 顶部头像控件
   */
  Widget head() {
    Widget head;
    head = FutureBuilder(
        future: getCookie(),
        builder: (context, snapshot) {
          if (user == null) {
            return Container();
          } else {
            return Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Container(
                    height: 100,
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: const Alignment(-1.0, 0.0),
                        end: const Alignment(0.6, 0.0),
                        colors: <Color>[
                          const Color(0xff67b1CC),
                          const Color(0xff79CECB)
                        ],
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Image.memory(
                            user['avatar'],
                            height: 70,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user['name'],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Text(user['mobile'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0))
                          ],
                        )
                      ],
                    )));
          }
          ;
        });
    return head;
  }
}
