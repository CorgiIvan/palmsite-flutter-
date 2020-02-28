import 'package:shared_preferences/shared_preferences.dart';

class cookie {
  String username;
  String password;
  SharedPreferences prefs;
  Map<String, dynamic> user = {
    'username': '',
    'password': '',
    'avatar': '',
    'name': '',
    'mobile': '',
    'id':''
  };

  Future setUser(String username, String password, String avatar, String name,
      String mobile,int id) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setString('avatar', avatar);
    await prefs.setString('name', name);
    await prefs.setString('mobile', mobile);
    await prefs.setInt('id', id);
    print("存起来的密码"+prefs.getString('password'));
  }

  Future<Map<String, dynamic>> getUser() async {
    prefs = await SharedPreferences.getInstance();
    user['username'] = prefs.getString('username');
    user['password'] = prefs.getString('password');
    user['avatar'] = prefs.getString('avatar');
    user['name'] = prefs.getString('name');
    user['mobile'] = prefs.getString('mobile');
    user['id'] = prefs.getInt('id');
    return user;
  }

  void initUser() async{
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', null);
    await prefs.setString('password', null);
    await prefs.setString('avatar', '');
    await prefs.setString('name', '');
    await prefs.setString('mobile', '');
  }

  Future getId() async{
    prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id');
    return id;
  }

  Future<Map<String, dynamic>> getToken() async {
    prefs = await SharedPreferences.getInstance();
    var Token;
    Token['username'] = prefs.getString('username');
    Token['password'] = prefs.getString('password');
    return Token;
  }
}
