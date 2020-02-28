import 'dart:convert' show json;

class SafeRectifyModel {
  int code;
  int count;
  String msg;
  String time;
  List<Data> data;

  SafeRectifyModel.fromParams(
      {this.code, this.count, this.msg, this.time, this.data});

  factory SafeRectifyModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SafeRectifyModel.fromJson(json.decode(jsonStr))
          : new SafeRectifyModel.fromJson(jsonStr);

  SafeRectifyModel.fromJson(jsonRes) {
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
  int safe_hidden_id;
  int status;
  String content;
  String ctime;
  String mtime;
  Hidden hidden;

  Data.fromParams(
      {this.id,
      this.safe_hidden_id,
      this.status,
      this.content,
      this.ctime,
      this.mtime,
      this.hidden});

  Data.fromJson(jsonRes) {
    id = jsonRes['id'];
    safe_hidden_id = jsonRes['safe_hidden_id'];
    status = jsonRes['status'];
    content = jsonRes['content'];
    ctime = jsonRes['ctime'];
    mtime = jsonRes['mtime'];
    hidden = jsonRes['hidden'] == null
        ? null
        : new Hidden.fromJson(jsonRes['hidden']);
  }

  @override
  String toString() {
    return '{"id": $id,"safe_hidden_id": $safe_hidden_id,"status": $status,"content": ${content != null ? '${json.encode(content)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"hidden": $hidden}';
  }
}

class Hidden {
  int id;
  int perambulate_user_id;
  int push_user_id;
  int record_time;
  int status;
  String construction_unit;
  String content;
  String ctime;
  String evidence;
  String leader;
  String mobile;
  String mtime;
  String title;
  String work_point;

  Hidden.fromParams(
      {this.id,
      this.perambulate_user_id,
      this.push_user_id,
      this.record_time,
      this.status,
      this.construction_unit,
      this.content,
      this.ctime,
      this.evidence,
      this.leader,
      this.mobile,
      this.mtime,
      this.title,
      this.work_point});

  Hidden.fromJson(jsonRes) {
    id = jsonRes['id'];
    perambulate_user_id = jsonRes['perambulate_user_id'];
    push_user_id = jsonRes['push_user_id'];
    record_time = jsonRes['record_time'];
    status = jsonRes['status'];
    construction_unit = jsonRes['construction_unit'];
    content = jsonRes['content'];
    ctime = jsonRes['ctime'];
    evidence = jsonRes['evidence'];
    leader = jsonRes['leader'];
    mobile = jsonRes['mobile'];
    mtime = jsonRes['mtime'];
    title = jsonRes['title'];
    work_point = jsonRes['work_point'];
  }

  @override
  String toString() {
    return '{"id": $id,"perambulate_user_id": $perambulate_user_id,"push_user_id": $push_user_id,"record_time": $record_time,"status": $status,"construction_unit": ${construction_unit != null ? '${json.encode(construction_unit)}' : 'null'},"content": ${content != null ? '${json.encode(content)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"evidence": ${evidence != null ? '${json.encode(evidence)}' : 'null'},"leader": ${leader != null ? '${json.encode(leader)}' : 'null'},"mobile": ${mobile != null ? '${json.encode(mobile)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'},"work_point": ${work_point != null ? '${json.encode(work_point)}' : 'null'}}';
  }
}
