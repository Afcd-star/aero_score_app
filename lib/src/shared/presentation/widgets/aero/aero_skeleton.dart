// lib/src/shared/presentation/widgets/aero/aero_skeleton.dart
import 'dart:async';

import 'package:flutter/material.dart';

/// Marcador de carga con brillo animado, con forma de contenido.
///
/// Su degradado usa grises fijos y no sigue el brillo del tema, deuda de
/// descableado registrada.
class AeroSkeleton extends StatefulWidget {
  /// Crea el marcador con su geometria opcional.
  const AeroSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  /// Ancho del marcador. Nulo deja que lo decida el padre.
  final double? width;

  /// Alto del marcador. Nulo deja que lo decida el padre.
  final double? height;

  /// Radio de las esquinas. Por defecto ocho.
  final BorderRadius? borderRadius;

  /// Margen exterior del marcador.
  final EdgeInsetsGeometry? margin;

  @override
  State<AeroSkeleton> createState() => _AeroSkeletonState();
}

class _AeroSkeletonState extends State<AeroSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}
