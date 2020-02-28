import 'package:flutter/material.dart';
import '../../bloc/count_provider.dart';

const double _kFlingVelocity = 2.0;

class SummitExamBackDrop extends StatefulWidget {
  final String title;
  final Widget backPanel;
  final Widget fontPanel;
  final Widget titlePanel;

  const SummitExamBackDrop(
      {@required this.title,
        @required this.backPanel,
      @required this.fontPanel,
      @required this.titlePanel});

  State<StatefulWidget> createState() => _SummitExamBackDrop();
}

class _SummitExamBackDrop extends State<SummitExamBackDrop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 0,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(SummitExamBackDrop old) {
    super.didUpdateWidget(old);
    _controller.fling(velocity: -_kFlingVelocity);
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(
        velocity: _backdropPanelVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    Animation<RelativeRect> panelAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, panelTop, 0.0, panelTop - panelSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Container(
        child: Stack(
      children: <Widget>[
        widget.backPanel,
        PositionedTransition(
            rect: panelAnimation,
            child: _BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              title: widget.titlePanel,
              child: widget.fontPanel,
            )),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: _BackdropTitle(
              listenable: _controller.view,
              frontTitle: Text('题目选择'),
              backTitle: Text(widget.title),
            ),
          ),
          body: LayoutBuilder(
            builder: _buildStack,
          ),
          resizeToAvoidBottomPadding: false,
        ),
        onWillPop: () {
          bloc.init();
          Navigator.pop(context);
        });
  }
}

class _BackdropTitle extends AnimatedWidget {
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle({
    Key key,
    Listenable listenable,
    this.frontTitle,
    this.backTitle,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: Interval(0.5, 1.0),
            ).value,
            child: backTitle,
          ),
          Opacity(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Interval(0.5, 1.0),
              ).value,
              child: frontTitle),
        ],
      ),
    );
  }
}

class _BackdropPanel extends StatelessWidget {
  const _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead,
                child: title,
              ),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}