// lib/src/core/theme/app_dimens.dart

/// Dimensiones compartidas del catalogo de la casa.
///
/// Nace con la altura de control porque campo, selector, boton y
/// pastilla de tema debian coincidir y cada uno la calculaba por su
/// cuenta. No contiene logica ni recibe contexto.
class AppDimens {
  const AppDimens._();

  /// Altura minima de los controles de superficie.
  ///
  /// Cuarenta y ocho pixeles es el minimo accesible de toque en
  /// Material. Se aplica como minimo y no como tope, porque el alto
  /// natural de un campo decorado varia con la pista, el error, el
  /// icono y las metricas de la fuente, y caparlo lo comprime.
  static const double controlHeight = 48;
}
