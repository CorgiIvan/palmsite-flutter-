import 'dart:convert' show json;

class UserLoggedBean {

  Object code;
  String msg;
  String time;
  Data data;

  UserLoggedBean.fromParams({this.code, this.msg, this.time, this.data});

  factory UserLoggedBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new UserLoggedBean.fromJson(json.decode(jsonStr)) : new UserLoggedBean.fromJson(jsonStr);

  UserLoggedBean.fromJson(jsonRes) {
    code = jsonRes['code'];
    msg = jsonRes['msg'];
    time = jsonRes['time'];
    data = jsonRes['data'] == null ? null : new Data.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"code": $code,"msg": ${msg != null?'${json.encode(msg)}':'null'},"time": ${time != null?'${json.encode(time)}':'null'},"data": $data}';
  }
}

class Data {

  Object d_key;
  Object number;
  Object user;
  int expire_time;
  int id;
  int last_login_time;
  int login_count;
  int parent_id;
  int role_id;
  int status;
  String auth;
  String avatar;
  String ctime;
  String email;
  String last_login_ip;
  String mobile;
  String mtime;
  String name;
  String remark;
  String unit;
  String username;
  String wx_open_id;
  Role role;

  Data.fromParams({this.d_key, this.number, this.user, this.expire_time, this.id, this.last_login_time, this.login_count, this.parent_id, this.role_id, this.status, this.auth, this.avatar, this.ctime, this.email, this.last_login_ip, this.mobile, this.mtime, this.name, this.remark, this.unit, this.username, this.wx_open_id, this.role});

  Data.fromJson(jsonRes) {
    d_key = jsonRes['d_key'];
    number = jsonRes['number'];
    user = jsonRes['user'];
    expire_time = jsonRes['expire_time'];
    id = jsonRes['id'];
    last_login_time = jsonRes['last_login_time'];
    login_count = jsonRes['login_count'];
    parent_id = jsonRes['parent_id'];
    role_id = jsonRes['role_id'];
    status = jsonRes['status'];
    auth = jsonRes['auth'];
    avatar = jsonRes['avatar'];
    ctime = jsonRes['ctime'];
    email = jsonRes['email'];
    last_login_ip = jsonRes['last_login_ip'];
    mobile = jsonRes['mobile'];
    mtime = jsonRes['mtime'];
    name = jsonRes['name'];
    remark = jsonRes['remark'];
    unit = jsonRes['unit'];
    username = jsonRes['username'];
    wx_open_id = jsonRes['wx_open_id'];
    role = jsonRes['role'] == null ? null : new Role.fromJson(jsonRes['role']);
  }

  @override
  String toString() {
    return '{"d_key": $d_key,"number": $number,"user": $user,"expire_time": $expire_time,"id": $id,"last_login_time": $last_login_time,"login_count": $login_count,"parent_id": $parent_id,"role_id": $role_id,"status": $status,"auth": ${auth != null?'${json.encode(auth)}':'null'},"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},"ctime": ${ctime != null?'${json.encode(ctime)}':'null'},"email": ${email != null?'${json.encode(email)}':'null'},"last_login_ip": ${last_login_ip != null?'${json.encode(last_login_ip)}':'null'},"mobile": ${mobile != null?'${json.encode(mobile)}':'null'},"mtime": ${mtime != null?'${json.encode(mtime)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"unit": ${unit != null?'${json.encode(unit)}':'null'},"username": ${username != null?'${json.encode(username)}':'null'},"wx_open_id": ${wx_open_id != null?'${json.encode(wx_open_id)}':'null'},"role": $role}';
  }
}

class Role {

  int id;
  String name;

  Role.fromParams({this.id, this.name});

  Role.fromJson(jsonRes) {
    id = jsonRes['id'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"id": $id,"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}

