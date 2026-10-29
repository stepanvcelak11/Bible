import 'package:flutter/material.dart';

/// Široký displej (tablet, telefon na šířku) – boční navigace a obsah
/// v omezené šířce.
bool isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= 700;

/// Nízký prostor (panel rozdělené obrazovky na telefonu, telefon na
/// šířku) – obrazovky vynechají velké nadpisy a úvodní texty.
bool isCompactHeight(BuildContext context) =>
    MediaQuery.sizeOf(context).height < 560;

/// Omezí šířku obsahu na čitelnou míru a vycentruje ho (na telefonu nic
/// nemění).
class ReadableWidth extends StatelessWidget {
  const ReadableWidth({super.key, required this.child, this.maxWidth = 760});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth <= maxWidth + 48) return child;
        return Center(
          child: SizedBox(
            width: maxWidth,
            child: MediaQuery.removePadding(
              context: context,
              removeLeft: true,
              removeRight: true,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
