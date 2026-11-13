// lib/src/shared/presentation/widgets/aero/aero_switch.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AeroSwitch extends StatelessWidget {

  const AeroSwitch({
    required this.value, required this.onChanged, super.key,
    this.scale,
    this.semanticLabel,
  });
  final bool value;
  final ValueChanged<bool> onChanged;
  final double? scale;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final switchWidget = Transform.scale(
      scale: scale ?? 0.9,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: AppColors.fuchsia.withValues(alpha: 0.7),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: 0.5);
            }
            return Colors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.selected)) {
              return AppColors.fuchsia.withValues(alpha: 0.7);
            }
            return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2);
          },
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 20,
      ),
    );

    // ✅ CORRECCIÓN: Envolver con Semantics para accesibilidad
    if (semanticLabel != null && semanticLabel!.isNotEmpty) {
      return Semantics(
        label: semanticLabel,
        child: switchWidget,
      );
    }

    return switchWidget;
  }
}

class AeroSwitchListTile extends StatelessWidget {

  const AeroSwitchListTile({
    required this.title, required this.value, required this.onChanged, super.key,
    this.subtitle,
    this.icon,
    this.onTap,
  });
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.fuchsia.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.fuchsia, size: 20),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.baseTextTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            )
          : null,
      trailing: AeroSwitch(
        value: value,
        onChanged: (val) {
          onChanged(val);
          onTap?.call();
        },
        semanticLabel: title, // ✅ Pasar el título como etiqueta semántica
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      onTap: () => onChanged(!value),
    );
  }
}
