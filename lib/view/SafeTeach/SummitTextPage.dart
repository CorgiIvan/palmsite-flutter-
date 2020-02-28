import 'package:flutter/material.dart';
import 'SummitItem.dart';
import 'SummitBackdrop.dart';
import '../../bloc/count_provider.dart';
import '../../utils/FuckingDioUtil.dart';
import '../../model/TeachExamModel.dart';
import '../../UI/LoadingWidget.dart';
import '../../UI/LoadingDialog.dart';
import 'dart:async';
import '../../utils/HttpGo.dart';
import 'package:dio/dio.dart';
import '../../cookie/cookie.dart';

class SummitTextPage extends StatefulWidget {
  final int ctime;
  const SummitTextPage(this.ctime);
  @override
  State<StatefulWidget> createState() => SummitTextState();
}

class SummitTextState extends State<SummitTextPage>
    with WidgetsBindingObserver {
  int _currentPageIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  var trueArray = <int>[];
  TeachExamModel _teachexan;
  /**
   * 计时器，用来记录今日学习时长
   */
  int time = 0;
  Timer _timer;

  /**
   * 开始计时
   */
  void startTime() {
    print('开始计时');
    _timer = new Timer.periodic(const Duration(seconds: 1), (timer) {
      time++;
      print(time);
    });
  }

  /**
   * 停止计时
   */
  void stopTime() {
    print('停止计时');
    if (_timer != null) {
      _timer.cancel();
    }
  }

  /**
   * 销毁页面执行的方法
   */
  @override
  void dispose() {
    HttpGo().post('/ss/api.learn_assess/count', (data) {},
        params: FormData.from({'today_time': time}));
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /**
   * 达能状态被修改时执行的方法
   */
  AppLifecycleState _lastLifecyleState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      print(state);
      if (state == AppLifecycleState.paused) {
        stopTime();
      } else if (state == AppLifecycleState.resumed) {
        startTime();
      }
    });
  }

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
  int falseNumber;
  String score;

  /**
   * 部分控件
   */
  Widget listview;
  Widget _Navigator;
  Widget title;

  onPageChange(int index) async {
    print('执行onPageChange');
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

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
                title: new Text("分数"),
                content: StreamBuilder<Map>(
                  stream: bloc.stream,
                  initialData: bloc.value,
                  builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                    score = ((100 / _teachexan.data.length) *
                            snapshot.data['true'].length)
                        .toStringAsFixed(2);
                    falseNumber = snapshot.data['false'].length;
                    return Text('你这次考试的分数是:' + score);
                  },
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("我知道了!"),
                    onPressed: () {
                      _timer.cancel();
                      showDialog<Null>(
                          context: context, //BuildContext对象
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new LoadingDialog(
                              //调用对话框
                              text: '正在上传成绩...',
                            );
                          });
                      /**
                       * 上传成绩的请求
                       */
                      cookie().getUser().then((user) {
                        int id = user['id'];
                        HttpGo().post('/ss/api.learn_result/add', (data1) {
                          HttpGo().post('/ss/api.learn_result/count', (data2) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            HttpGo().showToast(data2['msg']);
                          }, errorCallBack: (error) {
                            Navigator.pop(context);
                          },
                              params: FormData.from({
                                'total': _teachexan.data.length,
                                'errors_count': falseNumber
                              }));
                        }, errorCallBack: (error) {
                          Navigator.pop(context);
                        },
                            params: FormData.from({
                              'user_id': id,
                              'classify_id': 1,
                              'score': score,
                              'learn_time':
                                  DateTime.now().millisecondsSinceEpoch -
                                      widget.ctime,
                            }));
                      });
                    },
                  )
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
    WidgetsBinding.instance.addObserver(this);
    startTime();
    _futurebuilder = HttpGo().post("/ss/api.teach_online/decimation.html", (data){
      setState(() {
        isGet = true;
        _teachexan = TeachExamModel.fromJson(data);
      });
    },errorCallBack: (error){
      setState(() {
        isGet = false;
      });
    });
  }

  /**
   * 绘制生成树
   */
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    return FutureBuilder(
        future: _futurebuilder,
        builder: (context, snapshot) {
          if (_teachexan == null) {
            if (isGet) {
              return SummitExamBackDrop(
                title: '阶段测评',
                backPanel: LoadingWidget().childWidget(),
                fontPanel: Container(),
                titlePanel: Container(),
              );
            } else {
              return SummitExamBackDrop(
                title: '阶段测评',
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
              itemCount: _teachexan.data.length,
              itemBuilder: (context, index) {
                return SummitExamItem(
                    index + 1,
                    _teachexan.data[index].id,
                    _teachexan.data[index].topic,
                    _teachexan.data[index].answer,
                    _teachexan.data[index].option_value1,
                    _teachexan.data[index].option_value2,
                    _teachexan.data[index].option_value3,
                    _teachexan.data[index].option_value4);
              },
            ));

            _buildTabItem(Map list) {
              List<Widget> tiles = [];
              Widget content;
              for (int item = 0; item < _teachexan.data.length; item++) {
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
                        _teachexan.data.length.toString())
                  ],
                )
              ],
            );
            return SummitExamBackDrop(
              title: '阶段测评',
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
