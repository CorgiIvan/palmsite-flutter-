import 'dart:convert' show json;

class TeachDecimation {
  int code;
  String msg;
  String time;
  List<Data> data;

  TeachDecimation.fromParams({this.code, this.msg, this.time, this.data});

  factory TeachDecimation(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new TeachDecimation.fromJson(json.decode(jsonStr))
          : new TeachDecimation.fromJson(jsonStr);

  TeachDecimation.fromJson(jsonRes) {
    code = jsonRes['code'];
    msg = jsonRes['msg'];
    time = jsonRes['time'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']) {
      data.add(dataItem == null ? null : new Data.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"code": $code,"msg": ${msg != null ? '${json.encode(msg)}' : 'null'},"time": ${time != null ? '${json.encode(time)}' : 'null'},"data": $data}';
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
      this.topic});

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
  }

  @override
  String toString() {
    return '{"classify_id": $classify_id,"id": $id,"option_key1": $option_key1,"option_key2": $option_key2,"option_key3": $option_key3,"option_key4": $option_key4,"option_key5": $option_key5,"score": $score,"status": $status,"type": $type,"user_id": $user_id,"answer": ${answer != null ? '${json.encode(answer)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"keyword": ${keyword != null ? '${json.encode(keyword)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"option_value1": ${option_value1 != null ? '${json.encode(option_value1)}' : 'null'},"option_value2": ${option_value2 != null ? '${json.encode(option_value2)}' : 'null'},"option_value3": ${option_value3 != null ? '${json.encode(option_value3)}' : 'null'},"option_value4": ${option_value4 != null ? '${json.encode(option_value4)}' : 'null'},"option_value5": ${option_value5 != null ? '${json.encode(option_value5)}' : 'null'},"topic": ${topic != null ? '${json.encode(topic)}' : 'null'}}';
  }
}
