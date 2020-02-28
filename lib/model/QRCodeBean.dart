import 'dart:convert' show json;

class QRCodeBean {

  String type;
  int id;

  QRCodeBean.fromParams({this.type, this.id});

  factory QRCodeBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new QRCodeBean.fromJson(json.decode(jsonStr)) : new QRCodeBean.fromJson(jsonStr);

  QRCodeBean.fromJson(jsonRes) {
    type = jsonRes['type'];
    id = jsonRes['id'];
  }

  @override
  String toString() {
    return '{"type": ${type != null?'${json.encode(type)}':'null'},"id": $id}';
  }
}