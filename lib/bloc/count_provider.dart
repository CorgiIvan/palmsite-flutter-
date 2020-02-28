import 'package:flutter/material.dart';
import 'package:palm_sitt_for_flutter/bloc/count_bloc.dart';

class BlocProvider extends InheritedWidget {
  CountBLoC bLoC = CountBLoC();

  BlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CountBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).bLoC;
}
