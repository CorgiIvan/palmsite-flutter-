import 'dart:convert' show json;

class TeachCaseModel {
  int code;
  int count;
  String msg;
  String time;
  List<Data> data;

  TeachCaseModel.fromParams(
      {this.code, this.count, this.msg, this.time, this.data});

  factory TeachCaseModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new TeachCaseModel.fromJson(json.decode(jsonStr))
          : new TeachCaseModel.fromJson(jsonStr);

  TeachCaseModel.fromJson(jsonRes) {
    code = jsonRes['code'];
    count = jsonRes['count'];
    msg = jsonRes['msg'];
    time = jsonRes['time'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']) {
      data.add(dataItem == null ? null : new Data.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"code": $code,"count": $count,"msg": ${msg != null ? '${json.encode(msg)}' : 'null'},"time": ${time != null ? '${json.encode(time)}' : 'null'},"data": $data}';
  }
}

class Data {
  int browse_count;
  int classify_id;
  int id;
  int status;
  int user_id;
  String content;
  String ctime;
  String mtime;
  String pic;
  String title;
  Classify classify;
  User user;

  Data.fromParams(
      {this.browse_count,
      this.classify_id,
      this.id,
      this.status,
      this.user_id,
      this.content,
      this.ctime,
      this.mtime,
      this.pic,
      this.title,
      this.classify,
      this.user});

  Data.fromJson(jsonRes) {
    browse_count = jsonRes['browse_count'];
    classify_id = jsonRes['classify_id'];
    id = jsonRes['id'];
    status = jsonRes['status'];
    user_id = jsonRes['user_id'];
    content = jsonRes['content'];
    ctime = jsonRes['ctime'];
    mtime = jsonRes['mtime'];
    pic = jsonRes['pic'];
    title = jsonRes['title'];
    classify = jsonRes['classify'] == null
        ? null
        : new Classify.fromJson(jsonRes['classify']);
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"browse_count": $browse_count,"classify_id": $classify_id,"id": $id,"status": $status,"user_id": $user_id,"content": ${content != null ? '${json.encode(content)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"pic": ${pic != null ? '${json.encode(pic)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'},"classify": $classify,"user": $user}';
  }
}

class User {
  Object d_key;
  Object number;
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
  String wx_open_id;

  User.fromParams(
      {this.d_key,
      this.number,
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
      this.username,
      this.wx_open_id});

  User.fromJson(jsonRes) {
    d_key = jsonRes['d_key'];
    number = jsonRes['number'];
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
    wx_open_id = jsonRes['wx_open_id'];
  }

  @override
  String toString() {
    return '{"d_key": $d_key,"number": $number,"expire_time": $expire_time,"id": $id,"last_login_time": $last_login_time,"login_count": $login_count,"parent_id": $parent_id,"role_id": $role_id,"status": $status,"avatar": ${avatar != null ? '${json.encode(avatar)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"email": ${email != null ? '${json.encode(email)}' : 'null'},"last_login_ip": ${last_login_ip != null ? '${json.encode(last_login_ip)}' : 'null'},"mobile": ${mobile != null ? '${json.encode(mobile)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"password": ${password != null ? '${json.encode(password)}' : 'null'},"remark": ${remark != null ? '${json.encode(remark)}' : 'null'},"unit": ${unit != null ? '${json.encode(unit)}' : 'null'},"username": ${username != null ? '${json.encode(username)}' : 'null'},"wx_open_id": ${wx_open_id != null ? '${json.encode(wx_open_id)}' : 'null'}}';
  }
}

class Classify {
  int id;
  int status;
  String ctime;
  String mtime;
  String name;

  Classify.fromParams(
      {this.id, this.status, this.ctime, this.mtime, this.name});

  Classify.fromJson(jsonRes) {
    id = jsonRes['id'];
    status = jsonRes['status'];
    ctime = jsonRes['ctime'];
    mtime = jsonRes['mtime'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"id": $id,"status": $status,"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
}
