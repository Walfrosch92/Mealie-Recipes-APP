import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../core/utils/platform_features.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Rechtsklick-Menü für Listenzeilen mit Wisch-Aktionen (Windows/macOS).
//
// Wischen ist mit der Maus umständlich — am Rechner erwartet man Bearbeiten,
// Löschen & Co. im Kontextmenü. Das Menü liest seine Einträge direkt aus den
// Wisch-Aktionen des umschlossenen [Slidable]; beide Wege bieten dadurch
// immer dasselbe an. Auf Handy/Tablet tut dieses Widget nichts.
// ---------------------------------------------------------------------------

class SwipeContextMenu extends StatelessWidget {
  final Slidable child;
  // Derselbe Schlüssel wie das Slidable: In Listen wird am ÄUSSEREN Widget
  // abgeglichen — ohne ihn könnte eine aufgewischte Zeile nach dem Löschen
  // an der Nachbarzeile „hängen bleiben".
  SwipeContextMenu({required this.child}) : super(key: child.key);

  List<SlidableAction> get _actions => [
        ...?child.startActionPane?.children.whereType<SlidableAction>(),
        ...?child.endActionPane?.children.whereType<SlidableAction>(),
      ];

  Future<void> _open(BuildContext context, Offset globalPosition) async {
    final actions = _actions;
    if (actions.isEmpty) return;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;
    final at = overlay.globalToLocal(globalPosition);
    final picked = await showMenu<int>(
      context: context,
      color: context.appCard,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.rSm)),
      position: RelativeRect.fromLTRB(at.dx, at.dy, overlay.size.width - at.dx,
          overlay.size.height - at.dy),
      items: [
        for (var i = 0; i < actions.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Builder(builder: (ctx) {
              final danger =
                  actions[i].backgroundColor == AppTokens.swipeDelete;
              final color = danger ? AppTokens.danger : ctx.appFg;
              return Row(children: [
                Icon(actions[i].icon, size: 20, color: color),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(actions[i].label ?? '',
                      style: TextStyle(color: color)),
                ),
              ]);
            }),
          ),
      ],
    );
    if (picked == null || !context.mounted) return;
    actions[picked].onPressed?.call(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!PlatformFeatures.webAppTools) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapUp: (d) => _open(context, d.globalPosition),
      child: child,
    );
  }
}
