import 'dart:convert' show json;

class TeachExamModel {
  int code;
  int count;
  String msg;
  String time;
  List<Data> data;

  TeachExamModel.fromParams(
      {this.code, this.count, this.msg, this.time, this.data});

  factory TeachExamModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new TeachExamModel.fromJson(json.decode(jsonStr))
          : new TeachExamModel.fromJson(jsonStr);

  TeachExamModel.fromJson(jsonRes) {
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
  int classify_id;
  int id;
  int option_key1;
  int option_key2;
  int option_key3;
  int option_key4;
  int option_key5;
  int score;
  int status;
  int type;
  int user_id;
  String answer;
  String ctime;
  String keyword;
  String mtime;
  String option_value1;
  String option_value2;
  String option_value3;
  String option_value4;
  String option_value5;
  String topic;
  Classify classify;
  User user;

  Data.fromParams(
      {this.classify_id,
      this.id,
      this.option_key1,
      this.option_key2,
      this.option_key3,
      this.option_key4,
      this.option_key5,
      this.score,
      this.status,
      this.type,
      this.user_id,
      this.answer,
      this.ctime,
      this.keyword,
      this.mtime,
      this.option_value1,
      this.option_value2,
      this.option_value3,
      this.option_value4,
      this.option_value5,
      this.topic,
      this.classify,
      this.user});

  Data.fromJson(jsonRes) {
    classify_id = jsonRes['classify_id'];
    id = jsonRes['id'];
    option_key1 = jsonRes['option_key1'];
    option_key2 = jsonRes['option_key2'];
    option_key3 = jsonRes['option_key3'];
    option_key4 = jsonRes['option_key4'];
    option_key5 = jsonRes['option_key5'];
    score = jsonRes['score'];
    status = jsonRes['status'];
    type = jsonRes['type'];
    user_id = jsonRes['user_id'];
    answer = jsonRes['answer'];
    ctime = jsonRes['ctime'];
    keyword = jsonRes['keyword'];
    mtime = jsonRes['mtime'];
    option_value1 = jsonRes['option_value1'];
    option_value2 = jsonRes['option_value2'];
    option_value3 = jsonRes['option_value3'];
    option_value4 = jsonRes['option_value4'];
    option_value5 = jsonRes['option_value5'];
    topic = jsonRes['topic'];
    classify = jsonRes['classify'] == null
        ? null
        : new Classify.fromJson(jsonRes['classify']);
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"classify_id": $classify_id,"id": $id,"option_key1": $option_key1,"option_key2": $option_key2,"option_key3": $option_key3,"option_key4": $option_key4,"option_key5": $option_key5,"score": $score,"status": $status,"type": $type,"user_id": $user_id,"answer": ${answer != null ? '${json.encode(answer)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"keyword": ${keyword != null ? '${json.encode(keyword)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"option_value1": ${option_value1 != null ? '${json.encode(option_value1)}' : 'null'},"option_value2": ${option_value2 != null ? '${json.encode(option_value2)}' : 'null'},"option_value3": ${option_value3 != null ? '${json.encode(option_value3)}' : 'null'},"option_value4": ${option_value4 != null ? '${json.encode(option_value4)}' : 'null'},"option_value5": ${option_value5 != null ? '${json.encode(option_value5)}' : 'null'},"topic": ${topic != null ? '${json.encode(topic)}' : 'null'},"classify": $classify,"user": $user}';
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
