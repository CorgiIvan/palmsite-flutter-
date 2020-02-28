import 'dart:convert' show json;

class TeachAssessModel {
  int code;
  int count;
  String msg;
  String time;
  List<Data> data;

  TeachAssessModel.fromParams(
      {this.code, this.count, this.msg, this.time, this.data});

  factory TeachAssessModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new TeachAssessModel.fromJson(json.decode(jsonStr))
          : new TeachAssessModel.fromJson(jsonStr);

  TeachAssessModel.fromJson(jsonRes) {
    try {
      code = jsonRes['code'];
      count = jsonRes['count'];
      msg = jsonRes['msg'];
      time = jsonRes['time'];
      data = jsonRes['data'] == null ? null : [];

      for (var dataItem in data == null ? [] : jsonRes['data']) {
        data.add(dataItem == null ? null : new Data.fromJson(dataItem));
      }
    } catch (E) {
      print(E);
    }
  }

  @override
  String toString() {
    return '{"code": $code,"count": $count,"msg": ${msg != null ? '${json.encode(msg)}' : 'null'},"time": ${time != null ? '${json.encode(time)}' : 'null'},"data": $data}';
  }
}

class Data {
  var grade;
  var id;
  var pass;
  var status;
  var today_time;
  var total_time;
  var user_id;
  var accuracy;
  var ctime;
  var mtime;
  User user;

  Data.fromParams(
      {this.grade,
      this.id,
      this.pass,
      this.status,
      this.today_time,
      this.total_time,
      this.user_id,
      this.accuracy,
      this.ctime,
      this.mtime,
      this.user});

  Data.fromJson(jsonRes) {
    grade = jsonRes['grade'];
    id = jsonRes['id'];
    pass = jsonRes['pass'];
    status = jsonRes['status'];
    today_time = jsonRes['today_time'];
    total_time = jsonRes['total_time'];
    user_id = jsonRes['user_id'];
    accuracy = jsonRes['accuracy'];
    ctime = jsonRes['ctime'];
    mtime = jsonRes['mtime'];
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"grade": $grade,"id": $id,"pass": $pass,"status": $status,"today_time": $today_time,"total_time": $total_time,"user_id": $user_id,"accuracy": $accuracy,"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"user": $user}';
  }
}

class User {
  Object d_key;
  Object number;
  Object wx_open_id;
  int expire_time;
  int id;
  int last_login_time;
  int login_count;
  int parent_id;
  int role_id;
  int status;
  String avatar;
  String ctime;
  String email;
  String last_login_ip;
  String mobile;
  String mtime;
  String name;
  String password;
  String remark;
  String unit;
  String username;

  User.fromParams(
      {this.d_key,
      this.number,
      this.wx_open_id,
      this.expire_time,
      this.id,
      this.last_login_time,
      this.login_count,
      this.parent_id,
      this.role_id,
      this.status,
      this.avatar,
      this.ctime,
      this.email,
      this.last_login_ip,
      this.mobile,
      this.mtime,
      this.name,
      this.password,
      this.remark,
      this.unit,
      this.username});

  User.fromJson(jsonRes) {
    d_key = jsonRes['d_key'];
    number = jsonRes['number'];
    wx_open_id = jsonRes['wx_open_id'];
    expire_time = jsonRes['expire_time'];
    id = jsonRes['id'];
    last_login_time = jsonRes['last_login_time'];
    login_count = jsonRes['login_count'];
    parent_id = jsonRes['parent_id'];
    role_id = jsonRes['role_id'];
    status = jsonRes['status'];
    avatar = jsonRes['avatar'];
    ctime = jsonRes['ctime'];
    email = jsonRes['email'];
    last_login_ip = jsonRes['last_login_ip'];
    mobile = jsonRes['mobile'];
    mtime = jsonRes['mtime'];
    name = jsonRes['name'];
    password = jsonRes['password'];
    remark = jsonRes['remark'];
    unit = jsonRes['unit'];
    username = jsonRes['username'];
  }

  @override
  String toString() {
    return '{"d_key": $d_key,"number": $number,"wx_open_id": $wx_open_id,"expire_time": $expire_time,"id": $id,"last_login_time": $last_login_time,"login_count": $login_count,"parent_id": $parent_id,"role_id": $role_id,"status": $status,"avatar": ${avatar != null ? '${json.encode(avatar)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"email": ${email != null ? '${json.encode(email)}' : 'null'},"last_login_ip": ${last_login_ip != null ? '${json.encode(last_login_ip)}' : 'null'},"mobile": ${mobile != null ? '${json.encode(mobile)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"password": ${password != null ? '${json.encode(password)}' : 'null'},"remark": ${remark != null ? '${json.encode(remark)}' : 'null'},"unit": ${unit != null ? '${json.encode(unit)}' : 'null'},"username": ${username != null ? '${json.encode(username)}' : 'null'}}';
  }
}
