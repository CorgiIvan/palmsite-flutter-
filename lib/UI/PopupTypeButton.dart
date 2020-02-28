import 'dart:convert';

import 'package:flutter/material.dart';
import '../UI/PopupButton.dart';

class FilterData {
  int id;
  bool active;
  bool disable;
  String name;

  FilterData({this.id, this.active, this.name, this.disable});

  static List<FilterData> fromJson(String json) {
    List<FilterData> listModel = new List<FilterData>();
    List list = jsonDecode(json)['list'];
    list.forEach((v) {
      var model = fromMap(v);
      listModel.add(model);
    });

    return listModel;
  }

  static FilterData fromMap(Map map) {
    return new FilterData(
        id: map['id'],
        active: map['active'],
        disable: map['disable'],
        name: map['name']);
  }
}

///首页筛选栏--体型筛选按钮
class PopupTypeButton extends StatefulWidget {
  const PopupTypeButton({this.originData, this.onSelect,this.home_tab_type});

  final ValueChanged<List<FilterData>> onSelect;
  final List<FilterData> originData;
  final String home_tab_type;

  @override
  State<StatefulWidget> createState() => new _PopupTypeButtonState();
}

class _PopupTypeButtonState extends State<PopupTypeButton> {
   List<FilterData> _filterData;
   String home_tab_type;
  _onSelect(List<FilterData> filterData) {
    setState(() {
      _filterData = filterData;
    });
    if (widget.onSelect != null) widget.onSelect(filterData);
  }

  void Change(String name){
    home_tab_type = name;
    setState(() {
      home_tab_type = name;
    });
  }

  _initState(){
    home_tab_type = widget.home_tab_type;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initState();
  }

  @override
  Widget build(BuildContext context) {
//定义一个按钮，添加PopupTypeWindow为关联弹窗界面。
    return new PopupButton<List<FilterData>>(
        //TODO
//        name: home_tab_type,
        name: home_tab_type,
        onSelected: (value) => _onSelect(value),
        child: new PopupTypeWindow(
          originData: widget.originData,
          selectData: _filterData,
        ),
        fullWidth: true,
        offset: new Offset(0.0, 20.0));
  }
}

///首页体型筛选弹窗
class PopupTypeWindow extends StatefulWidget {
  const PopupTypeWindow({this.originData, this.selectData});

  final List<FilterData> originData;
  final List<FilterData> selectData;

  @override
  State<StatefulWidget> createState() => new _PopupTypeWindowState();
}

class _PopupTypeWindowState extends State<PopupTypeWindow> {
  final List<FilterData> _originData = FilterData.fromJson(
      """{"list":[{"id":1,"active":false,"disable":true,"name":"132"},
      {"id":2,"active":true,"disable":true,"name":"123"}]}""");
  final int _columnNum = 3; //每行个数

  _reset() {
    setState(() {
      _originData.forEach((data) => data.active = false);
    });
  }

  _confirm() {
    List<FilterData> results = [];
    _originData.forEach((data) {
      if (data.active) results.add(data);
    });
    Navigator.of(context).pop(results);
  }

  _onChanged(FilterData data) {
    for (int i = 0; i < _originData.length; i++) {
      if (data.id == _originData[i].id) {
        _originData[i].active = data.active;
        break;
      }
    }
  }

  bool _isActive(int id) {
    if (widget.selectData != null) {
      for (int i = 0; i < widget.selectData.length; i++) {
        if (id == widget.selectData[i].id) {
          return true;
        }
      }
    }
    return false;
  }

  _initData() {
    int length = widget.originData == null ? 0 : widget.originData.length;
    for (int i = 0; i < length; i++) {
      FilterData data = widget.originData[i];
      data.active = _isActive(data.id);
      data.disable = false;
      _originData.add(data);
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(PopupTypeWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initData();
  }

  @override
  Widget build(BuildContext context) {
//    _initData();

    List<Widget> child = [];
    Column row;
    for (int i = 0; i < _originData.length; i++) {
      if (i % _columnNum == 0) {
        row = new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[],
        );
        child.add(new Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: row,
        ));
      }
      row.children.add(new PopupItem(
        data: _originData[i],
        onChanged: (FilterData data) => _onChanged(data),
      ));
    }
    child.add(new Padding(
      padding: const EdgeInsets.only(top: 15.0),
//        child: new Column(children: <Widget>[
//          new Divider(height: 0.0),
//          new Row(children: <Widget>[
//            new Expanded(
//                child: new FlatButton(
//                    onPressed: _reset,
//                    child: const Text('123'),
//                    color: Theme.of(context).bottomAppBarColor)),
//            new Expanded(
//                child: new FlatButton(
//                    onPressed: _confirm,
//                    child: const Text(
//                      '589',
//                      style: const TextStyle(color: Colors.white),
//                    ),
//                    color: Theme.of(context).primaryColor)),
//          ])
    ));

    return new Column(children: child);
  }
}

///item控件
class PopupItem extends StatefulWidget {
  const PopupItem({this.data, this.onChanged});

  final FilterData data;
  final ValueChanged<FilterData> onChanged;

  @override
  State<StatefulWidget> createState() => new _PopupItemState();
}

class _PopupItemState extends State<PopupItem> {
  _onPress() {
//    print('啊啊啊啊啊啊/啊啊啊啊啊啊啊啊啊啊啊啊啊');
//    Navigator.of(context).pop();
    setState(() {
      widget.data.active = !widget.data.active;
    });
    if (widget.onChanged != null) widget.onChanged(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _onPress,
      child: new Column(
        children: <Widget>[
//          new DecoratedBox(
//            decoration: new BoxDecoration(
//              color: widget.data.active ? Theme.of(context).primaryColor : null,
//              borderRadius: new BorderRadius.circular(50.0),
//            ),
//            child: new Padding(
//              padding: const EdgeInsets.all(2.0),
////     TODO
//            child: Icon(Icons.arrow_forward),
////              child: new Image.asset(widget.data.image),
//            ),
//          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
            child: new Text(
              widget.data.name,
              style: new TextStyle(
                  color: widget.data.active
                      ? Theme.of(context).primaryColor
                      : null),
            ),
          )
        ],
      ),
    );
  }
}
