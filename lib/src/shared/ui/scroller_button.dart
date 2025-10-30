import 'package:flutter/material.dart';

enum ScrollMode { animated, jumper }

class ScrollerButton extends StatefulWidget {
  const ScrollerButton({
    super.key,
    required this.controller,
    this.scrollMode = ScrollMode.animated,
    this.visibleAfterOffset = 1000,
    this.scrollToOffset = 0,
    this.scrollDuration,
    this.scrollCurve = Curves.easeIn,
  });

  final ScrollController controller;
  final ScrollMode scrollMode;
  final double visibleAfterOffset;
  final double scrollToOffset;
  final Duration? scrollDuration;
  final Curve scrollCurve;

  @override
  State<ScrollerButton> createState() => _ScrollerButtonState();
}

class _ScrollerButtonState extends State<ScrollerButton> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !_isVisible,
      child: AnimatedOpacity(
        curve: Curves.fastOutSlowIn,
        opacity: _isVisible ? 1 : 0,
        duration: Duration(seconds: 1),
        child: IconButton.filled(
          icon: Icon(Icons.arrow_upward),
          onPressed: handleScroll,
        ),
      ),
    );
  }

  void handleScroll() {
    final duration =
        widget.scrollDuration ??
        (widget.controller.offset < 2000
            ? Duration(milliseconds: 400)
            : Duration(seconds: 1));

    switch (widget.scrollMode) {
      case ScrollMode.animated:
        widget.controller.animateTo(
          widget.scrollToOffset,
          duration: duration,
          curve: widget.scrollCurve,
        );
      case ScrollMode.jumper:
        widget.controller.jumpTo(widget.scrollToOffset);
    }
  }

  void listenScrollController() {
    if (!_isVisible && widget.controller.offset > widget.visibleAfterOffset) {
      setState(() => _isVisible = true);
    } else if (_isVisible &&
        widget.controller.offset <= widget.visibleAfterOffset) {
      setState(() => _isVisible = false);
    }
  }

  @override
  void initState() {
    widget.controller.addListener(listenScrollController);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listenScrollController);
    super.dispose();
  }
}
