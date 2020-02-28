import 'dart:convert';

import 'package:flutter/material.dart';

import '../UI/PopupButton.dart';
import '../bloc/count_provider.dart';

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
  final ValueChanged<List<FilterData>> onSelect;

  final List<FilterData> originData;
  final String home_tab_type;
  const PopupTypeButton({this.originData, this.onSelect, this.home_tab_type});

  @override
  State<StatefulWidget> createState() => new PopupTypeButtonState();
}

class PopupTypeButtonState extends State<PopupTypeButton> {
  List<FilterData> _filterData;
  String home_tab_type;
  List<FilterData> selectData;
  List<FilterData> _originData;

  FilterData data;
  ValueChanged<FilterData> onChanged;

  final int _columnNum = 1; //每行个数

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

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
      row.children.add(InkWell(
        onTap: () {
          setState(() {
            Navigator.of(context).pop();
            home_tab_type = _originData[i].name;
            for (int a = 0; a < _originData.length; a++) {
              _originData[a].active = false;
            }
            _originData[i].active = true;
            bloc.AddUserId(_originData[i].id);
          });
        },
        child: new Container(
          child: (Padding(
            padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
            child: Center(
              child: new Text(
                _originData[i].name,
                style: new TextStyle(
                    color: _originData[i].active
                        ? Colors.blue
                        : null,
                    fontSize: 16.0),
              ),
            ),
          )),
        ),
      ));
    }
    child.add(new Padding(
      padding: const EdgeInsets.only(top: 15.0),
    ));
    final example1 = Column(children: child);

//定义一个按钮，添加PopupTypeWindow为关联弹窗界面。
    return new PopupButton<List<FilterData>>(
        //TODO
        name: home_tab_type,
        onSelected: (value) => _onSelect(value),
        fullWidth: true,
        offset: new Offset(0.0, 20.0),
        child: example1);
  }

  @override
  void initState() {
    super.initState();
    _initState();
//    _initData();
  }

  _initData() {
    int length = widget.originData == null ? 0 : widget.originData.length;
    for (int i = 0; i < length; i++) {
      print('拿到的数据是============' + widget.originData[i].name);
      FilterData data = widget.originData[i];
      data.active = _isActive(data.id);
      data.disable = false;
      _originData.add(widget.originData[i]);
    }
  }

  _initState() {
    home_tab_type = widget.home_tab_type;
    _originData = widget.originData;
  }

  bool _isActive(int id) {
    if (selectData != null) {
      for (int i = 0; i < selectData.length; i++) {
        if (id == selectData[i].id) {
          return true;
        }
      }
    }
    return false;
  }

  _onSelect(List<FilterData> filterData) {
    setState(() {
      _filterData = filterData;
    });
    if (widget.onSelect != null) widget.onSelect(filterData);
  }
}