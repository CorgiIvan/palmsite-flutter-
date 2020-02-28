import 'dart:convert' show json;

class ArchivesBean {
  int code;
  String msg;
  String time;
  List<Data> data;

  ArchivesBean.fromParams({this.code, this.msg, this.time, this.data});

  factory ArchivesBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new ArchivesBean.fromJson(json.decode(jsonStr))
          : new ArchivesBean.fromJson(jsonStr);

  ArchivesBean.fromJson(jsonRes) {
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
  int archives_id;
  int id;
  int status;
  int tenders_id;
  String ctime;
  String mtime;
  Archives archives;

  Data.fromParams(
      {this.archives_id,
      this.id,
      this.status,
      this.tenders_id,
      this.ctime,
      this.mtime,
      this.archives});

  Data.fromJson(jsonRes) {
    archives_id = jsonRes['archives_id'];
    id = jsonRes['id'];
    status = jsonRes['status'];
    tenders_id = jsonRes['tenders_id'];
    ctime = jsonRes['ctime'];
    mtime = jsonRes['mtime'];
    archives = jsonRes['archives'] == null
        ? null
        : new Archives.fromJson(jsonRes['archives']);
  }

  @override
  String toString() {
    return '{"archives_id": $archives_id,"id": $id,"status": $status,"tenders_id": $tenders_id,"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"archives": $archives}';
  }
}

class Archives {
  int catalog_id;
  int id;
  int security_classification;
  int status;
  int type;
  int user_id;
  String accountability_unit;
  String archives_code;
  String confidentiality_period;
  String ctime;
  String file;
  String keyword;
  String mtime;
  String name;
  String number;
  String overview;
  String qr_code;
  String responsible;
  String storage_place;
  String storage_year;
  String theme;

  Archives.fromParams(
      {this.catalog_id,
      this.id,
      this.security_classification,
      this.status,
      this.type,
      this.user_id,
      this.accountability_unit,
      this.archives_code,
      this.confidentiality_period,
      this.ctime,
      this.file,
      this.keyword,
      this.mtime,
      this.name,
      this.number,
      this.overview,
      this.qr_code,
      this.responsible,
      this.storage_place,
      this.storage_year,
      this.theme});

  Archives.fromJson(jsonRes) {
    catalog_id = jsonRes['catalog_id'];
    id = jsonRes['id'];
    security_classification = jsonRes['security_classification'];
    status = jsonRes['status'];
    type = jsonRes['type'];
    user_id = jsonRes['user_id'];
    accountability_unit = jsonRes['accountability_unit'];
    archives_code = jsonRes['archives_code'];
    confidentiality_period = jsonRes['confidentiality_period'];
    ctime = jsonRes['ctime'];
    file = jsonRes['file'];
    keyword = jsonRes['keyword'];
    mtime = jsonRes['mtime'];
    name = jsonRes['name'];
    number = jsonRes['number'];
    overview = jsonRes['overview'];
    qr_code = jsonRes['qr_code'];
    responsible = jsonRes['responsible'];
    storage_place = jsonRes['storage_place'];
    storage_year = jsonRes['storage_year'];
    theme = jsonRes['theme'];
  }

  @override
  String toString() {
    return '{"catalog_id": $catalog_id,"id": $id,"security_classification": $security_classification,"status": $status,"type": $type,"user_id": $user_id,"accountability_unit": ${accountability_unit != null ? '${json.encode(accountability_unit)}' : 'null'},"archives_code": ${archives_code != null ? '${json.encode(archives_code)}' : 'null'},"confidentiality_period": ${confidentiality_period != null ? '${json.encode(confidentiality_period)}' : 'null'},"ctime": ${ctime != null ? '${json.encode(ctime)}' : 'null'},"file": ${file != null ? '${json.encode(file)}' : 'null'},"keyword": ${keyword != null ? '${json.encode(keyword)}' : 'null'},"mtime": ${mtime != null ? '${json.encode(mtime)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"number": ${number != null ? '${json.encode(number)}' : 'null'},"overview": ${overview != null ? '${json.encode(overview)}' : 'null'},"qr_code": ${qr_code != null ? '${json.encode(qr_code)}' : 'null'},"responsible": ${responsible != null ? '${json.encode(responsible)}' : 'null'},"storage_place": ${storage_place != null ? '${json.encode(storage_place)}' : 'null'},"storage_year": ${storage_year != null ? '${json.encode(storage_year)}' : 'null'},"theme": ${theme != null ? '${json.encode(theme)}' : 'null'}}';
  }
}
