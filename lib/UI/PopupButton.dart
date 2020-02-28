import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PopupButton<T> extends StatefulWidget {
  const PopupButton(
      {Key key,
        @required this.name,
        @required this.child,
        this.onSelected,
        this.onCancel,
        this.offset: Offset.zero,
        this.theme,
        this.fullWidth,
        this.arrows})
      : super(key: key);

  final String name;
  final PopupWindowSelected onSelected;
  final PopupWindowCanceled onCancel;
  final Offset offset;
  final Widget child;
  final ThemeData theme;
  final List<String> arrows;
  final bool fullWidth;

  @override
  _PopupButtonState<T> createState() => new _PopupButtonState<T>();
}

typedef void PopupWindowCanceled();
typedef void PopupWindowSelected<T>(T value);

class _PopupButtonState<T> extends State<PopupButton<T>> {
  ///内部缓存变量_active，用来改变弹窗和正常情况下按钮颜色和图标状态。
  bool _active = false;

  _showPopupWindow() {
    setState(() {
      _active = true;
    });

    ///获取本控件的渲染对象
    final RenderBox button = context.findRenderObject();

    ///获取本控件覆盖物的渲染对象
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    ///计算弹窗的弹出位置，widget.offset为偏移数据，默认在button底部弹出。
    final RelativeRect position = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(button.size.bottomLeft(widget.offset),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(widget.offset),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showPopupWindow<T>(
      context: context,
      child: widget.child,
      position: position,
      fullWidth: widget.fullWidth,
    ).then<void>((T newValue) {
      setState(() {
        _active = false;
      });
      if (newValue == null) {
        if (widget.onCancel != null) widget.onCancel();
        return null;
      }
      if (widget.onSelected != null) widget.onSelected(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    var color = widget.theme != null
        ? (_active == true ? widget.theme.highlightColor : null)
        : (_active == true ? Colors.blue : Colors.grey);
    var arrow = widget.arrows != null
        ? new AssetImage(_active == true ? widget.arrows[0] : widget.arrows[1])
        : new Icon(
      _active ? Icons.arrow_drop_up : Icons.arrow_drop_down,
      color: color,
    );

    return new FlatButton(
        onPressed: _showPopupWindow,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              widget.name,
              textAlign: TextAlign.center,
              style: new TextStyle(color: color,fontSize: 16.0),
            ),
            arrow
          ],
        ));
  }
}

const Duration _kWindowDuration = const Duration(milliseconds: 300);
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const double _kWindowMaxWidth = 5.0 * _kWindowWidthStep;
const double _kWindowMinWidth = 2.0 * _kWindowWidthStep;
const double _kWindowVerticalPadding = 0.0;
const double _kWindowWidthStep = 56.0;
const double _kWindowScreenPadding = 0.0;

///弹窗方法
Future<T> showPopupWindow<T>({
  @required BuildContext context,
  RelativeRect position,
  @required Widget child,
  double elevation: 8.0,
  String semanticLabel,
  bool fullWidth,
}) {
  assert(context != null);
  String label = semanticLabel;
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      label = semanticLabel;
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
      label =
          semanticLabel ?? MaterialLocalizations.of(context)?.popupMenuLabel;
  }

  return Navigator.push(
      context,
      new _PopupWindowRoute(
        context: context,
        position: position,
        child: child,
        elevation: elevation,
        semanticLabel: label,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        fullWidth: fullWidth,
      ));
}

///自定义弹窗路由：参照_PopupMenuRoute修改的
class _PopupWindowRoute<T> extends PopupRoute<T> {
  _PopupWindowRoute({
    @required BuildContext context,
    RouteSettings settings,
    this.child,
    this.position,
    this.elevation: 8.0,
    this.theme,
    this.barrierLabel,
    this.semanticLabel,
    this.fullWidth,
  }) : super(settings: settings) {
    assert(child != null);
  }

  final Widget child;
  final RelativeRect position;
  double elevation;
  final ThemeData theme;
  final String semanticLabel;
  final bool fullWidth;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Duration get transitionDuration => _kWindowDuration;

  @override
  Animation<double> createAnimation() {
    return new CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd));
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget win = new _PopupWindow<T>(
      route: this,
      semanticLabel: semanticLabel,
      fullWidth: fullWidth,
    );
    if (theme != null) {
      win = new Theme(data: theme, child: win);
    }

    return new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: new Builder(
        builder: (BuildContext context) {
          return new CustomSingleChildLayout(
            delegate: new _PopupWindowLayoutDelegate(
                position, null, Directionality.of(context)),
            child: win,
          );
        },
      ),
    );
  }
}

///自定义弹窗控件：对自定义的弹窗内容进行再包装，添加长宽、动画等约束条件
class _PopupWindow<T> extends StatelessWidget {
  const _PopupWindow({
    Key key,
    this.route,
    this.semanticLabel,
    this.fullWidth: false,
  }) : super(key: key);

  final _PopupWindowRoute<T> route;
  final String semanticLabel;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final double length = 10.0;
    final double unit = 1.0 /
        (length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.

    final CurveTween opacity =
    new CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = new CurveTween(curve: new Interval(0.0, unit));
    final CurveTween height =
    new CurveTween(curve: new Interval(0.0, unit * length));

    final Widget child = new ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: fullWidth ? double.infinity : _kWindowMinWidth,
        maxWidth: fullWidth ? double.infinity : _kWindowMaxWidth,
      ),
      child: new IntrinsicWidth(
          stepWidth: _kWindowWidthStep,
          child: new SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(vertical: _kWindowVerticalPadding),
            child: route.child,
          )),
    );

    return new AnimatedBuilder(
      animation: route.animation,
      builder: (BuildContext context, Widget child) {
        return new Opacity(
          opacity: opacity.evaluate(route.animation),
          child: new Material(
            type: MaterialType.card,
            elevation: route.elevation,
            child: new Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route.animation),
              heightFactor: height.evaluate(route.animation),
              child: new Semantics(
                scopesRoute: true,
                namesRoute: true,
                explicitChildNodes: true,
                label: semanticLabel,
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

///自定义委托内容：子控件大小及其位置计算
class _PopupWindowLayoutDelegate extends SingleChildLayoutDelegate {
  _PopupWindowLayoutDelegate(
      this.position, this.selectedItemOffset, this.textDirection);

  final RelativeRect position;
  final double selectedItemOffset;
  final TextDirection textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return new BoxConstraints.loose(constraints.biggest -
        const Offset(_kWindowScreenPadding * 2.0, _kWindowScreenPadding * 2.0));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y;
    if (selectedItemOffset == null) {
      y = position.top;
    } else {
      y = position.top +
          (size.height - position.top - position.bottom) / 2.0 -
          selectedItemOffset;
    }

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      assert(textDirection != null);
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < _kWindowScreenPadding)
      x = _kWindowScreenPadding;
    else if (x + childSize.width > size.width - _kWindowScreenPadding)
      x = size.width - childSize.width - _kWindowScreenPadding;
    if (y < _kWindowScreenPadding)
      y = _kWindowScreenPadding;
    else if (y + childSize.height > size.height - _kWindowScreenPadding)
      y = size.height - childSize.height - _kWindowScreenPadding;
    return new Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayoutDelegate oldDelegate) {
    return position != oldDelegate.position;
  }
}