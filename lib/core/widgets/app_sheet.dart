import 'package:flutter/material.dart';

import '../l10n/strings_cs.dart';

/// Jednotný vysouvací panel: nahoře vždy úchyt (panel jde stáhnout dolů)
/// a vpravo tlačítko ✕ – každý panel se zavírá stejně.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useSafeArea = false,
  bool? showDragHandle,
  Color? backgroundColor,
  BoxConstraints? constraints,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  useSafeArea: useSafeArea,
  backgroundColor: backgroundColor,
  constraints: constraints,
  isDismissible: isDismissible,
  enableDrag: enableDrag,
  useRootNavigator: useRootNavigator,
  // Úchyt kreslí [SheetFrame] spolu s tlačítkem zavřít.
  showDragHandle: false,
  builder: (context) => SheetFrame(child: builder(context)),
);

/// Horní lišta panelu (úchyt uprostřed, ✕ vpravo) nad obsahem.
class SheetFrame extends StatelessWidget {
  const SheetFrame({super.key, required this.child});

  final Widget child;

  static const barHeight = 52.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: barHeight),
          child: child,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: barHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Positioned(
                right: 16,
                top: 8,
                child: IconButton(
                  tooltip: S.close,
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.06),
                  ),
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
