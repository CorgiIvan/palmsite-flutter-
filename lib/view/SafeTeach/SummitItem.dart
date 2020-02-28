import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../bloc/count_provider.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../utils/HttpGo.dart';
import 'SummitTextPage.dart';
import 'package:dio/dio.dart';

class SummitExamItem extends StatefulWidget {
  final int id;
  final int teach_exam_id;
  final String question;
  final String answer;
  final String optiona;
  final String optionb;
  final String optionc;
  final String optiond;

  const SummitExamItem(
      @required this.id,
      @required this.teach_exam_id,
      @required this.question,
      @required this.answer,
      @required this.optiona,
      @required this.optionb,
      @required this.optionc,
      @required this.optiond);
  @override
  State<StatefulWidget> createState() => _SummitExamItemState();
}

class _SummitExamItemState extends State<SummitExamItem>
    with AutomaticKeepAliveClientMixin {
  bool isChoiceA = false;
  bool isChoiceB = false;
  bool isChoiceC = false;
  bool isChoiceD = false;
  bool isChoiced = false;
  String TextchoiceA = '';
  String TextchoiceB = '';
  String TextchoiceC = '';
  String TextchoiceD = '';

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.id.toString() + '.' + widget.question,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: (TextchoiceA == widget.answer)
                        ? Colors.green
                        : isChoiceA
                            ? isChoiced ? Colors.red : Colors.blue[300]
                            : Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: InkWell(
                  onTap: () {
                    if (!isChoiced) {
                      setState(() {
                        isChoiceA = true;
                        isChoiceB = false;
                        isChoiceC = false;
                        isChoiceD = false;
                      });
                    }
                  },
                  child: ChoiceBtn(
                      widget.optiona, isChoiceA, TextchoiceA, widget.answer),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: (TextchoiceB == widget.answer)
                        ? Colors.green
                        : isChoiceB
                            ? isChoiced ? Colors.red : Colors.blue[300]
                            : Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: InkWell(
                  onTap: () {
                    if (!isChoiced) {
                      setState(() {
                        isChoiceA = false;
                        isChoiceB = true;
                        isChoiceC = false;
                        isChoiceD = false;
                      });
                    }
                  },
                  child: ChoiceBtn(
                      widget.optionb, isChoiceB, TextchoiceB, widget.answer),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: (TextchoiceC == widget.answer)
                        ? Colors.green
                        : isChoiceC
                            ? isChoiced ? Colors.red : Colors.blue[300]
                            : Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: InkWell(
                  onTap: () {
                    if (!isChoiced) {
                      setState(() {
                        isChoiceA = false;
                        isChoiceB = false;
                        isChoiceC = true;
                        isChoiceD = false;
                      });
                    }
                  },
                  child: ChoiceBtn(
                      widget.optionc, isChoiceC, TextchoiceC, widget.answer),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: (TextchoiceD == widget.answer)
                        ? Colors.green
                        : (isChoiceD
                            ? isChoiced ? Colors.red : Colors.blue[300]
                            : Colors.grey[300]),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: InkWell(
                  onTap: () {
                    if (!isChoiced) {
                      setState(() {
                        isChoiceA = false;
                        isChoiceB = false;
                        isChoiceC = false;
                        isChoiceD = true;
                      });
                    }
                  },
                  child: ChoiceBtn(
                      widget.optiond, isChoiceD, TextchoiceD, widget.answer),
                ),
              ),
            ),
            isChoiced
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (!isChoiceA &&
                                      !isChoiceB &&
                                      !isChoiceC &&
                                      !isChoiceD) {
                                    Fluttertoast.showToast(
                                        msg: "请选择答案",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white);
                                  } else {
                                    TextchoiceA = widget.optiona;
                                    TextchoiceB = widget.optionb;
                                    TextchoiceC = widget.optionc;
                                    TextchoiceD = widget.optiond;
                                    isChoiced = true;
                                    if ((isChoiceA &&
                                            (TextchoiceA == widget.answer)) ||
                                        (isChoiceB &&
                                            (TextchoiceB == widget.answer)) ||
                                        (isChoiceC &&
                                            (TextchoiceC == widget.answer)) ||
                                        (isChoiceD &&
                                            (TextchoiceD == widget.answer))) {
                                      bloc.increment(widget.id - 1);
                                    } else {
                                      bloc.increfalsement(widget.id - 1);
                                      /**
                                       * 上传错题记录
                                       */
                                      HttpGo.getInstance().post(
                                          '/ss/api.errors_list/add', (data) {},
                                          params: FormData.from({
                                            'teach_exam_id':
                                                widget.teach_exam_id,
                                            'error_time': DateTime.now()
                                                .millisecondsSinceEpoch
                                          }));
                                    }
                                  }
                                });
                              },
                              child: Text(
                                "确认",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ChoiceBtn extends StatefulWidget {
  final String text;
  final String textchoice;
  final String trueanswer;
  final bool choice;

  const ChoiceBtn(@required this.text, @required this.choice,
      @required this.textchoice, @required this.trueanswer);
  State<StatefulWidget> createState() => _ChoiceState();
}

class _ChoiceState extends State<ChoiceBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        new Expanded(
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              widget.text,
              style: TextStyle(
                  fontSize: 16.0,
                  color:
                      widget.choice || (widget.textchoice == widget.trueanswer)
                          ? Colors.white
                          : Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
