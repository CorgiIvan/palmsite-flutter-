import 'dart:convert' show json;

class UploadBean {
  int code;
  String msg;
  String time;
  Data data;

  UploadBean.fromParams({this.code, this.msg, this.time, this.data});

  factory UploadBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new UploadBean.fromJson(json.decode(jsonStr))
          : new UploadBean.fromJson(jsonStr);

  UploadBean.fromJson(jsonRes) {
    code = jsonRes['code'];
    msg = jsonRes['msg'];
    time = jsonRes['time'];
    data = jsonRes['data'] == null ? null : new Data.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"code": $code,"msg": ${msg != null ? '${json.encode(msg)}' : 'null'},"time": ${time != null ? '${json.encode(time)}' : 'null'},"data": $data}';
  }
}

class Data {
  String name;
  String url;

  Data.fromParams({this.name, this.url});

  Data.fromJson(jsonRes) {
    name = jsonRes['name'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return '{"name": ${name != null ? '${json.encode(name)}' : 'null'},"url": ${url != null ? '${json.encode(url)}' : 'null'}}';
  }
}
