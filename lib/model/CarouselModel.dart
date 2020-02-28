import 'dart:convert' show json;

class CarouselBean {

  int code;
  int count;
  String msg;
  String time;
  List<Data> data;
  Number number;

  CarouselBean.fromParams({this.code, this.count, this.msg, this.time, this.data, this.number});

  factory CarouselBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CarouselBean.fromJson(json.decode(jsonStr)) : new CarouselBean.fromJson(jsonStr);

  CarouselBean.fromJson(jsonRes) {
    code = jsonRes['code'];
    count = jsonRes['count'];
    msg = jsonRes['msg'];
    time = jsonRes['time'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
      data.add(dataItem == null ? null : new Data.fromJson(dataItem));
    }

    number = jsonRes['number'] == null ? null : new Number.fromJson(jsonRes['number']);
  }

  @override
  String toString() {
    return '{"code": $code,"count": $count,"msg": ${msg != null?'${json.encode(msg)}':'null'},"time": ${time != null?'${json.encode(time)}':'null'},"data": $data,"number": $number}';
  }
}

class Number {

  int one;
  int two;

  Number.fromParams({this.one, this.two});

  Number.fromJson(jsonRes) {
    one = jsonRes['1'];
    two = jsonRes['2'];
  }

  @override
  String toString() {
    return '{"1": $one,"2": $two}';
  }
}

class Data {

  int advertisement;
  int id;
  int past_time;
  int sort;
  int status;
  String ctime;
  String mtime;
  String pic;

  Data.fromParams({this.advertisement, this.id, this.past_time, this.sort, this.status, this.ctime, this.mtime, this.pic});

  Data.fromJson(jsonRes) {
    advertisement = jsonRes['advertisement'];
    id = jsonRes['id'];
    past_time = jsonRes['past_time'];
    sort = jsonRes['sort'];
    status = jsonRes['status'];
    ctime = jsonRes['ctime'];
    mtime = jsonRes['mtime'];
    pic = jsonRes['pic'];
  }

  @override
  String toString() {
    return '{"advertisement": $advertisement,"id": $id,"past_time": $past_time,"sort": $sort,"status": $status,"ctime": ${ctime != null?'${json.encode(ctime)}':'null'},"mtime": ${mtime != null?'${json.encode(mtime)}':'null'},"pic": ${pic != null?'${json.encode(pic)}':'null'}}';
  }
}

