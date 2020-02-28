import 'dart:async';

class CountBLoC {
  List trueCount = [];
  List falseCount = [];
  Map<String,dynamic> Count = {'true':[],'false':[],'userId':null};
  var _countController = StreamController<Map>.broadcast();

  Stream<Map> get stream => _countController.stream;
  Map get value => Count;

  increment(int number) {
    trueCount.add(number);
    Count['true'] = trueCount;
    _countController.sink.add(Count);
  }

  increfalsement(int number) {
    falseCount.add(number);
    Count['false'] = falseCount;
    _countController.sink.add(Count);
  }

  AddUserId(int id){
    Count['userId'] = id;
    _countController.sink.add(Count);
  }

  int getId(){
    return Count['userId'];
  }

  dispose() {
    _countController.close();
  }

  init(){
    trueCount = [];
    falseCount = [];
    Count = {'true':trueCount,'false':falseCount,'userId':null};
    _countController.sink.add(Count);
  }
}