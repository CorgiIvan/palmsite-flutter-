import 'dart:convert' show json;

class ExamModel {
  int status;
  String msg;
  List<Exam> data;

  ExamModel({this.status, this.msg, this.data});

  factory ExamModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<Exam> dataList = list.map((i) => Exam.fromJson(i)).toList();

    return ExamModel(
        status: parsedJson['status'], msg: parsedJson['msg'], data: dataList);
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'data': data,
      };
}

class Exam {
  int id;
  String question;
  String answer;
  String optiona;
  String optionb;
  String optionc;
  String optiond;
  bool isTrue;

  Exam(
      {this.id,
      this.question,
      this.answer,
      this.optiona,
      this.optionb,
      this.optionc,
      this.optiond,
      this.isTrue});

  factory Exam.fromJson(Map<String, dynamic> parsedJson) {
    return Exam(
        id: parsedJson['id'],
        question: parsedJson['question'],
        answer: parsedJson['answer'],
        optiona: parsedJson['optiona'],
        optionb: parsedJson['optionb'],
        optionc: parsedJson['optionc'],
        optiond: parsedJson['optiond'],
        isTrue: parsedJson['isTrue']);
  }
}
