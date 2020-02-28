import 'dart:convert' show json;

class SafeHidden {
  int code;
  int count;
  String msg;
  String time;
  List<Data> data;

  SafeHidden.fromParams(
      {this.code, this.count, this.msg, this.time, this.data});

  factory SafeHidden(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SafeHidden.fromJson(json.decode(jsonStr))
          : new SafeHidden.fromJson(jsonStr);

  SafeHidden.fromJson(jsonRes) {
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
  int perambulate_user_id;
  int push_user_id;
  int status;
  String construction_unit;
  String content;
  String ctime;
  String evidence;
  String leader;
  String mobile;
  String mtime;
  String record_time;
  String title;
  String work_point;
  Perambulate perambulate;
  Push push;

  Data.fromParams(
      {this.id,
      this.perambulate_user_id,
      this.push_user_id,
      this.status,
      this.construction_unit,
      this.content,
      this.ctime,
      this.evidence,
      this.leader,
      this.mobile,
      this.mtime,
      this.record_time,
      this.title,
      this.work_point,
      this.perambulate,
      this.push});

  Data.fromJson(jsonRes) {
    id = jsonRes['id'];
    perambulate_user_id = jsonRes['perambulate_user_id'];
    push_user_id = jsonRes['push_user_id'];
    status = jsonRes['status'];
    construction_unit = jsonRes['construction_unit'];
    content = jsonRes['content'];
    ctime = jsonRes['ctime'];
    evidence = jsonRes['evidence'];
    leader = jsonRes['leader'];
    mobile = jsonRes['mobile'];
    mtime = jsonRes['mtime'];
    record_time = jsonRes['record_time'];
    title = jsonRes['title'];
    work_point = jsonRes['work_point'];
    perambulate = jsonRes['perambulate'] == null
        ? null
        : new Perambulate.fromJson(jsonRes['perambulate']);
    push = jsonRes['push'] == null ? null : new Push.fromJson(jsonRes['push']);
  }

  @override
  String toString() {
    return '{"id": $id,"perambulate_user_id": $perambulate_user_id,"push_user_id": $push_user_id,"status": $status,"construction_unit": ${construction_unit != null ? '${json.encode(construction_unit)}' : 'null'},"content": ${content != null ? '${json.encode(content)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"evidence": ${evidence != null ? '${json.encode(evidence)}' : 'null'},"leader": ${leader != null ? '${json.encode(leader)}' : 'null'},"mobile": ${mobile != null ? '${json.encode(mobile)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"record_time": ${record_time != null ? '${json.encode(record_time)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'},"work_point": ${work_point != null ? '${json.encode(work_point)}' : 'null'},"perambulate": $perambulate,"push": $push}';
  }
}

class Push {
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

  Push.fromParams(
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

  Push.fromJson(jsonRes) {
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

class Perambulate {
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

  Perambulate.fromParams(
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

  Perambulate.fromJson(jsonRes) {
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
