import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../environment/flavor.dart';
import '../../../../utils/app_talker.dart';

/// Floating Talker entry (dev / staging only).
///
/// Shown as an in-place overlay (not [Navigator.push]) because this widget
/// lives in [MaterialApp.builder] outside the app [Navigator].
class TalkerOverlay extends StatefulWidget {
  const TalkerOverlay({super.key, required this.child});

  final Widget? child;

  @override
  State<TalkerOverlay> createState() => _TalkerOverlayState();
}

class _TalkerOverlayState extends State<TalkerOverlay> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final content = widget.child ?? const SizedBox.shrink();
    if (!FlavorConfig.showTalker) {
      return content;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: content),
        if (_visible)
          Positioned.fill(
            child: TalkerScreen(
              talker: talker,
              appBarLeading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _visible = false),
              ),
            ),
          )
        else
          Positioned(
            left: 12,
            bottom: MediaQuery.paddingOf(context).bottom + 12,
            child: FloatingActionButton.small(
              heroTag: 'talker_fab',
              backgroundColor: Colors.black87,
              onPressed: () => setState(() => _visible = true),
              child: const Icon(Icons.bug_report, color: Colors.white, size: 20),
            ),
          ),
      ],
    );
  }
}
