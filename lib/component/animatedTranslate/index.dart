import 'package:flutter/cupertino.dart';

class AnimatedTranslate extends ImplicitlyAnimatedWidget {
  const AnimatedTranslate({
    super.key,
    required this.child,
    required this.x,
    required this.y,
    super.curve,
    required super.duration,
    super.onEnd,
  });

  final Widget child;

  final double? x;

  final double? y;

  @override
  _AnimatedTranslateState createState() => _AnimatedTranslateState();
}

class _AnimatedTranslateState extends AnimatedWidgetBaseState<AnimatedTranslate> {
  Tween<double>? _x;
  Tween<double>? _y;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _x = visitor(_x, widget.x, (dynamic value) => Tween<double>(begin: value)) as Tween<double>;
    _y = visitor(_y, widget.y, (dynamic value) => Tween<double>(begin: value)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_x!.evaluate(animation), _y!.evaluate(animation)),
      child: widget.child,
    );
  }
}
