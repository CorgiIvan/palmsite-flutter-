import 'package:flutter/material.dart';
import 'SummitItem.dart';
import 'SummitBackdrop.dart';
import '../../bloc/count_provider.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../model/TeachDecimationModel.dart';
import '../../UI/LoadingWidget.dart';
import '../../UI/LoadingDialog.dart';
import '../../utils/HttpGo.dart';

class SummitExamPage extends StatefulWidget {
  final int teach_online_id;
  final int ctime;
  const SummitExamPage(this.teach_online_id, this.ctime);
  @override
  State<StatefulWidget> createState() => _SummitExamState();
}

class _SummitExamState extends State<SummitExamPage> {
  int _currentPageIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  var trueArray = <int>[];
  TeachDecimation _teachDecimation;
  /**
   * 是否获取到数据的标识
   */
  bool isGet = true;

  bool isChoiceA = false;
  bool isChoiceB = false;
  bool isChoiceC = false;
  bool isChoiceD = false;
  bool isChoiced = false;
  String TextchoiceA = '';
  String TextchoiceB = '';
  String TextchoiceC = '';
  String TextchoiceD = '';

  int CurrentPage = 0;

  /**
   * 部分控件
   */
  Widget listview;
  Widget _Navigator;
  Widget title;

  onPageChange(int index) async {
    await _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _pageChange(int index) {
    setState(() {
      if (_currentPageIndex != index) {
        CurrentPage = index;
        _currentPageIndex = index;
      }
    });
  }

  void showAlertDialog(BuildContext context) {
    final bloc = BlocProvider.of(context);
    NavigatorState navigator =
        context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    debugPrint("navigator is null?" + (navigator == null).toString());

    double score;
    int falseNumber;

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
                title: new Text("分数"),
                content: StreamBuilder<Map>(
                  stream: bloc.stream,
                  initialData: bloc.value,
                  builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                    score = ((100 / _teachDecimation.data.length) *
                        snapshot.data['true'].length);
                    falseNumber = snapshot.data['false'].length;
                    return Text('你这次考试的分数是:' + score.toString());
                  },
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text("我知道了!"),
                      onPressed: () {
                        showDialog<Null>(
                            context: context, //BuildContext对象
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return new LoadingDialog(
                                //调用对话框
                                text: '正在上传成绩...',
                              );
                            });
                        int isPass;
                        if (score >= 60) {
                          isPass = 1;
                        } else {
                          isPass = 0;
                        }
                        HttpGo().AddTeachResult(
                            (dara) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            widget.teach_online_id,
                            widget.ctime,
                            score,
                            _teachDecimation.data.length,
                            falseNumber,
                            isPass,
                            errorCallBack: (error) {
                              Navigator.pop(context);
                            });
                      })
                ]),
        barrierDismissible: false);
  }

  /**
   * 防止futurebuilder重绘
   */
  var _futurebuilder;
  @override
  void initState() {
    super.initState();
    _futurebuilder = HttpGo().post("/ss/api.teach_online/decimation.html", (data){
      setState(() {
        isGet = true;
        _teachDecimation = TeachDecimation.fromJson(data);
      });
    },errorCallBack: (error){
      isGet = false;
    });

//    _futurebuilder = FuckingDioUtil()
//        .postTwoNoMap2withCookie("/origin/api.user/login.html",
//            "/ss/api.teach_online/decimation.html")
//        .then((response) {
//      if (response == false) {
//        isGet = false;
//      } else {
//        _teachDecimation = TeachDecimation.fromJson(response.data);
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    return FutureBuilder(
        future: _futurebuilder,
        builder: (context, snapshot) {
          if (_teachDecimation == null) {
            if (isGet) {
              return SummitExamBackDrop(
                title: '在线考试',
                backPanel: LoadingWidget().childWidget(),
                fontPanel: Container(),
                titlePanel: Container(),
              );
            } else {
              return SummitExamBackDrop(
                title: '在线考试',
                backPanel: LoadingWidget().defeatWidget(),
                fontPanel: Container(),
                titlePanel: Container(),
              );
            }
          } else {
            listview = Scaffold(
                body: PageView.builder(
              onPageChanged: _pageChange,
              controller: _pageController,
              itemCount: _teachDecimation.data.length,
              itemBuilder: (context, index) {
                return SummitExamItem(
                    index + 1,
                    _teachDecimation.data[index].id,
                    _teachDecimation.data[index].topic,
                    _teachDecimation.data[index].answer,
                    _teachDecimation.data[index].option_value1,
                    _teachDecimation.data[index].option_value2,
                    _teachDecimation.data[index].option_value3,
                    _teachDecimation.data[index].option_value4);
              },
            ));

            _buildTabItem(Map list) {
              List<Widget> tiles = [];
              Widget content;
              for (int item = 0; item < _teachDecimation.data.length; item++) {
                tiles.add(Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Container(
                      height: 39,
                      width: 39,
                      decoration: BoxDecoration(
                          color: list['true'].contains(item)
                              ? Colors.green[500]
                              : list['false'].contains(item)
                                  ? Colors.red
                                  : (CurrentPage == item)
                                      ? Colors.grey
                                      : Colors.transparent,
                          border: Border.all(
                              width: 1.0,
                              color: list['true'].contains(item)
                                  ? Colors.transparent
                                  : list['false'].contains(item)
                                      ? Colors.transparent
                                      : (CurrentPage == item)
                                          ? Colors.transparent
                                          : Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: InkWell(
                        onTap: () {
                          onPageChange(item);
                          setState(() {
                            CurrentPage = item;
                          });
                        },
                        child: Center(
                          child: Text(
                            (item + 1).toString(),
                            style: TextStyle(
                                color: (list['true'].contains(item))
                                    ? Colors.white
                                    : (list['false'].contains(item))
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                      ),
                    )));
              }
              content = Wrap(
                children: tiles,
              );
              return content;
            }

            _Navigator = Scaffold(
                body: StreamBuilder<Map>(
              stream: bloc.stream,
              initialData: bloc.value,
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                return _buildTabItem(snapshot.data);
              },
            ));

            title = Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      showAlertDialog(context);
                    },
                    child: Text(
                      '交卷',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                StreamBuilder<Map>(
                  stream: bloc.stream,
                  initialData: bloc.value,
                  builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                    return RichText(
                      text: TextSpan(
                          text: '√ ' + snapshot.data['true'].length.toString(),
                          style: TextStyle(color: Colors.green),
                          children: [
                            TextSpan(
                                text: '    × ' +
                                    snapshot.data['false'].length.toString(),
                                style: TextStyle(color: Colors.red))
                          ]),
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.arrow_upward),
                    Text(' ' +
                        (CurrentPage + 1).toString() +
                        '/' +
                        _teachDecimation.data.length.toString())
                  ],
                )
              ],
            );
            return SummitExamBackDrop(
              title: '在线考试',
              backPanel: listview,
              fontPanel: _Navigator,
              titlePanel: title,
            );
          }
        });
  }
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
