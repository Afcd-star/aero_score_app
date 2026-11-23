// lib/src/core/theme/text_styles.dart
import 'package:flutter/material.dart';

/// Definicion centralizada de la tipografia de AeroScore.
///
/// Sora para titulos y Manrope para cuerpo. Las familias se declaran en
/// el manifiesto con sus pesos y se referencian por nombre, asi que
/// cargan con el motor: sin peticion de red y sin paso asincrono.
///
/// Se declaran los quince roles de TextTheme: un rol ausente hace que
/// cualquier `baseTextTheme.rol?.copyWith(...)` devuelva null y el texto
/// pierda en silencio tamano, peso y color, heredando el estilo del
/// Material.
class AppTextStyles {
  const AppTextStyles._();

  /// Familia tipografica de los titulos.
  static const String titleFamily = 'Sora';

  /// Familia tipografica del cuerpo y las etiquetas.
  static const String bodyFamily = 'Manrope';

  /// Tema tipografico base, aplicado segun el brillo en AppTheme.
  ///
  /// Es constante y se construye una sola vez. Antes era un getter que
  /// ejecutaba quince llamadas a la biblioteca de fuentes en cada
  /// acceso, y se accede desde cada construccion de widget.
  static TextTheme get baseTextTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: titleFamily,
        fontSize: 36,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: titleFamily,
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontFamily: titleFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        fontFamily: titleFamily,
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontFamily: titleFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: titleFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontFamily: titleFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: titleFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontFamily: titleFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
