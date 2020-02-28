import 'dart:convert' show json;

class TeachResultBean {
  int code;
  int count;
  String msg;
  String time;
  List<Data> data;

  TeachResultBean.fromParams(
      {this.code, this.count, this.msg, this.time, this.data});

  factory TeachResultBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new TeachResultBean.fromJson(json.decode(jsonStr))
          : new TeachResultBean.fromJson(jsonStr);

  TeachResultBean.fromJson(jsonRes) {
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
  int id;
  int score;
  int status;
  int teach_online_id;
  int user_id;
  String ctime;
  String etime;
  String exam_time;
  String mtime;
  String stime;
  User user;

  Data.fromParams(
      {this.id,
      this.score,
      this.status,
      this.teach_online_id,
      this.user_id,
      this.ctime,
      this.etime,
      this.exam_time,
      this.mtime,
      this.stime,
      this.user});

  Data.fromJson(jsonRes) {
    id = jsonRes['id'];
    score = jsonRes['score'];
    status = jsonRes['status'];
    teach_online_id = jsonRes['teach_online_id'];
    user_id = jsonRes['user_id'];
    ctime = jsonRes['ctime'];
    etime = jsonRes['etime'];
    exam_time = jsonRes['exam_time'];
    mtime = jsonRes['mtime'];
    stime = jsonRes['stime'];
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"id": $id,"score": $score,"status": $status,"teach_online_id": $teach_online_id,"user_id": $user_id,"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"etime": ${etime != null ? '${json.encode(etime)}' : 'null'},"exam_time": ${exam_time != null ? '${json.encode(exam_time)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"stime": ${stime != null ? '${json.encode(stime)}' : 'null'},"user": $user}';
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
