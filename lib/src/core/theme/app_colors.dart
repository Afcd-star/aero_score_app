// lib/src/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Catálogo puro de colores de AeroScore.
///
/// NO contiene lógica y NO recibe BuildContext. Los helpers que sí
/// necesitan contexto viven en theme_helpers.dart.
///
/// Verdad estructural declarada, no ocultada. Este catálogo convive con
/// un segundo sistema de color: el ColorScheme que AppTheme construye
/// mezclando literales crudos (0xFF1A1A2E, 0xFF161625, 0xFF454545,
/// 0xFF252525) y paleta de Material (Colors.white, white70, black87,
/// grey shade50 y shade300). Por eso hay tres defectos que esta
/// documentación registra sin corregir, porque corregirlos es mutar la
/// paleta y pertenece al frente de descableado interno de tema, no a
/// documentar.
///
/// Uno, duplicación de valor con nombres distintos: 0xFF252525 sirve a
/// textOnWhite, foregroundLight, backgroundDark y cardDark; 0xFF454545
/// sirve a secondaryDark, mutedDark, inputDark, borderDark y
/// borderSubtle, más el literal outline del tema.
///
/// Dos, colisión de rol: 0xFF252525 sirve como texto sobre blanco en
/// claro y como superficie en oscuro, dos papeles opuestos bajo un hex.
///
/// Tres, desalineación de superficie: la superficie real del tema en
/// oscuro es 0xFF1A1A2E, que este catálogo no nombra, mientras
/// backgroundDark y cardDark valen 0xFF252525 y theme_helpers los
/// devuelve como si fueran la superficie de la tarjeta, lo que produjo
/// la divergencia de superficie entre lista y formulario.
///
/// Retiro registrado, para que no se reañadan sin consumidor delante.
/// Los doce espejos de shadcn/ui que el esquema nunca cableó se retiraron
/// con grafo de consumidores vacío en todo el árbol: accentLight,
/// accentDark, accentForegroundLight, accentForegroundDark,
/// cardForegroundLight, cardForegroundDark, destructiveForegroundLight,
/// destructiveForegroundDark, ringLight, ringDark, glowPink y midnight.
/// Sus roles los cubre el esquema de Material 3, y los dos últimos
/// duplicaban el hex de coral y de backgroundSecondary.
///
/// Regla de nacimiento adoptada: toda pieza nueva nace con documentación
/// pública completa, porque retrofitar cuesta dos órdenes de magnitud
/// más que documentar al nacer.
class AppColors {
  const AppColors._();

  // ═════════════════════════════════════════════════════════════
  // COLORES DE MARCA (Invariantes)
  // ═════════════════════════════════════════════════════════════
  // Duplicación de valor declarada: fuchsia, glowFuchsia y
  // brandSoftForegroundDark comparten 0xFFFF00FF con roles distintos
  // (marca, extremo de degradado, texto de fondo tenue oscuro).
  // backgroundBase (0xFF0A0515) es fondo de marca a sangre para splash y
  // casco, NO es colorScheme.surface, que en oscuro el tema fija en
  // 0xFF1A1A2E.

  /// Rosa eléctrico de marca, semilla del esquema y acento de foco.
  /// Comparte hex con glowFuchsia y brandSoftForegroundDark.
  static const Color fuchsia = Color(0xFFFF00FF);

  /// Coral de marca, extremo cálido del degradado y acento secundario.
  static const Color coral = Color(0xFFFF006A);

  /// Verde menta de marca, terciario del esquema en ambos modos.
  static const Color mint = Color(0xFF86FBD1);

  /// Base oscura de marca para splash y casco a sangre. NO es la
  /// superficie del esquema, que en oscuro vale 0xFF1A1A2E.
  static const Color backgroundBase = Color(0xFF0A0515);

  /// Segundo fondo de marca, azul noche. Valor único del catálogo tras
  /// el retiro de su duplicado sin uso.
  static const Color backgroundSecondary = Color(0xFF0B0D17);

  /// Extremo fucsia del degradado de marca. Comparte hex con fuchsia y
  /// brandSoftForegroundDark. Se consume por dentro desde getGlowGradient,
  /// sin prefijo, así que su número de referencias directas externas no
  /// refleja su utilidad real: getGlowGradient lo usa en cada llamada.
  static const Color glowFuchsia = Color(0xFFFF00FF);

  /// Extremo violeta del degradado de marca, valor único del catálogo. Se
  /// consume por dentro desde getGlowGradient, sin prefijo, igual que
  /// glowFuchsia, por lo que sus referencias externas lo subestiman.
  static const Color glowViolet = Color(0xFF8B00FF);

  // ═════════════════════════════════════════════════════════════
  // COLORES DE TEXTO
  // ═════════════════════════════════════════════════════════════
  // Colisión de rol declarada: 0xFF252525 aparece aquí como texto sobre
  // blanco, en textOnWhite y foregroundLight, y también como superficie
  // en oscuro, en backgroundDark y cardDark. Un mismo hex con dos papeles
  // opuestos según modo. 0xFFFAFAFA aparece como textPrimary y, en oscuro,
  // como foregroundDark, primaryDark y secondaryForegroundDark.
  // 0xFF343434 aparece como textSecondary y como primaryForegroundDark.

  /// Texto primario sobre superficie oscura. Comparte hex con
  /// foregroundDark, primaryDark y secondaryForegroundDark.
  static const Color textPrimary = Color(0xFFFAFAFA);

  /// Texto secundario, gris profundo. Comparte hex con
  /// primaryForegroundDark.
  static const Color textSecondary = Color.fromARGB(255, 52, 52, 54);

  /// Texto oscuro sobre blanco en claro. Comparte hex con foregroundLight,
  /// backgroundDark y cardDark, que es la colisión de rol declarada en la
  /// cabecera de sección.
  static const Color textOnWhite = Color(0xFF252525);

  // ═════════════════════════════════════════════════════════════
  // LIGHT MODE
  // ═════════════════════════════════════════════════════════════
  // Desalineación de fuente declarada: el esquema en claro fija surface
  // en Colors.white (paleta de Material), mismo valor que backgroundLight
  // y cardLight del catálogo pero de fuente distinta. 0xFFFFFFFF se
  // repite en backgroundLight, cardLight y primaryForegroundLight.
  // 0xFF030213 se repite en primaryLight y secondaryForegroundLight.
  // 0xFF252525 lo usa foregroundLight, con la colisión de rol contra la
  // superficie oscura ya declarada. successLight comparte 0xFF22C55E con
  // roleOrganizerLight y facultyFTL.

  /// Fondo de pantalla en claro. Comparte hex con cardLight y con el
  /// surface del esquema, que el tema fija en Colors.white.
  static const Color backgroundLight = Color(0xFFFFFFFF);

  /// Texto primario en claro. Comparte hex con textOnWhite, backgroundDark
  /// y cardDark.
  static const Color foregroundLight = Color(0xFF252525);

  /// Superficie de tarjeta en claro. Comparte hex con backgroundLight.
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Primario de acción en claro, tinta profunda. Comparte hex con
  /// secondaryForegroundLight.
  static const Color primaryLight = Color(0xFF030213);

  /// Texto sobre primario en claro. Comparte hex con backgroundLight.
  static const Color primaryForegroundLight = Color(0xFFFFFFFF);

  /// Secundario de superficie en claro, gris muy claro.
  static const Color secondaryLight = Color(0xFFF1F2F6);

  /// Texto sobre secundario en claro. Comparte hex con primaryLight.
  static const Color secondaryForegroundLight = Color(0xFF030213);

  /// Superficie tenue en claro, para fondos de control.
  static const Color mutedLight = Color(0xFFECECF0);

  /// Texto tenue en claro, gris medio.
  static const Color mutedForegroundLight = Color(0xFF717182);

  /// Destructivo de marca en claro, rojo saturado. Valor único, no
  /// coincide con roleAdminLight.
  static const Color destructiveLight = Color(0xFFD4183D);

  /// Borde tenue en claro, negro al diez por ciento.
  static const Color borderLight = Color(0x1A000000);

  /// Fondo de campo de entrada en claro.
  static const Color inputBackgroundLight = Color(0xFFF3F3F5);

  /// Éxito de marca en claro, verde. Comparte hex con roleOrganizerLight
  /// y facultyFTL.
  static const Color successLight = Color(0xFF22C55E);

  /// Fondo tenue de marca para acciones suaves sobre superficie clara.
  /// Fucsia puro al diez por ciento compuesto sobre blanco.
  static const Color brandSoftBackgroundLight = Color(0xFFFFE6FF);

  /// Texto de acento profundo sobre el fondo tenue claro.
  /// Razón de contraste 5.05 sobre el fondo tenue claro.
  static const Color brandSoftForegroundLight = Color(0xFFB300B3);

  /// Borde suave de marca para superficie clara.
  /// Fucsia puro al treinta por ciento compuesto sobre blanco.
  /// Decorativo, razón de contraste 1.38 sobre el fondo tenue claro.
  static const Color brandSoftBorderLight = Color(0xFFFFB2FF);

  // ═════════════════════════════════════════════════════════════
  // DARK MODE
  // ═════════════════════════════════════════════════════════════
  // Desalineación de superficie declarada, la que la purga de la hoja
  // modal expuso: el esquema en oscuro fija surface en 0xFF1A1A2E y
  // onSurface en Colors.white (paleta de Material), mientras este
  // catálogo declara backgroundDark y cardDark en 0xFF252525 y
  // foregroundDark en 0xFFFAFAFA. theme_helpers.getCard y getBackground
  // devuelven 0xFF252525 como si fuera la superficie de la tarjeta, y por
  // eso lista y formulario divergían en oscuro. backgroundDark, cardDark
  // y foregroundDark son candidatos a realineación con el esquema o a
  // retiro en el frente de descableado interno de tema, según el conteo
  // de consumidores.
  // Redundancia declarada: 0xFF454545 vive en secondaryDark, mutedDark,
  // inputDark y borderDark, más el literal outline del tema. 0xFFFAFAFA
  // vive en foregroundDark, primaryDark y secondaryForegroundDark.
  // 0xFF343434 vive en primaryForegroundDark. successDark comparte
  // 0xFF16A34A con roleOrganizerDark.

  /// Superficie oscura heredada de 0xFF252525. NO coincide con
  /// colorScheme.surface en oscuro, que el tema fija en 0xFF1A1A2E.
  /// Candidata a realineación o retiro en descableado interno de tema.
  static const Color backgroundDark = Color(0xFF252525);

  /// Texto primario en oscuro. Comparte hex con primaryDark,
  /// secondaryForegroundDark y textPrimary. El esquema fija onSurface en
  /// Colors.white, fuente distinta del mismo rol.
  static const Color foregroundDark = Color(0xFFFAFAFA);

  /// Superficie de tarjeta oscura heredada de 0xFF252525. NO coincide
  /// con colorScheme.surface en oscuro. Candidata a realineación o
  /// retiro en descableado interno de tema.
  static const Color cardDark = Color(0xFF252525);

  /// Primario de acción en oscuro. Comparte hex con foregroundDark.
  static const Color primaryDark = Color(0xFFFAFAFA);

  /// Texto sobre primario en oscuro. Comparte hex con textSecondary.
  static const Color primaryForegroundDark = Color(0xFF343434);

  /// Secundario de superficie en oscuro. Comparte hex con mutedDark,
  /// inputDark y borderDark.
  static const Color secondaryDark = Color(0xFF454545);

  /// Texto sobre secundario en oscuro. Comparte hex con foregroundDark.
  static const Color secondaryForegroundDark = Color(0xFFFAFAFA);

  /// Superficie tenue en oscuro. Comparte hex con secondaryDark.
  static const Color mutedDark = Color(0xFF454545);

  /// Texto tenue en oscuro, gris claro. Valor único del catálogo tras el
  /// retiro de su duplicado entre modos.
  static const Color mutedForegroundDark = Color(0xFFB5B5B5);

  /// Destructivo de marca en oscuro, granate profundo. Valor único.
  static const Color destructiveDark = Color(0xFF8B2340);

  /// Borde en oscuro. Comparte hex con secondaryDark, mutedDark e
  /// inputDark, más el literal outline del tema.
  static const Color borderDark = Color(0xFF454545);

  /// Fondo de campo de entrada en oscuro. Comparte hex con secondaryDark.
  static const Color inputDark = Color(0xFF454545);

  /// Éxito de marca en oscuro, verde. Comparte hex con roleOrganizerDark.
  static const Color successDark = Color(0xFF16A34A);

  /// Fondo tenue de marca para acciones suaves sobre superficie oscura.
  /// Fucsia puro al diez por ciento compuesto sobre la superficie del
  /// tema en oscuro, no sobre cardDark.
  static const Color brandSoftBackgroundDark = Color(0xFF311743);

  /// Texto de acento brillante sobre el fondo tenue oscuro.
  /// Fucsia puro, razón de contraste 5.02 sobre el fondo tenue oscuro.
  /// Comparte hex con fuchsia y glowFuchsia.
  static const Color brandSoftForegroundDark = Color(0xFFFF00FF);

  /// Borde suave de marca para superficie oscura.
  /// Decorativo, razón de contraste 1.35 sobre el fondo tenue oscuro.
  static const Color brandSoftBorderDark = Color(0xFF5F126D);

  // ═════════════════════════════════════════════════════════════
  // SURFACES & BORDERS
  // ═════════════════════════════════════════════════════════════
  // Duplicación declarada: borderSubtle comparte 0xFF454545 con
  // secondaryDark, mutedDark, inputDark y borderDark, y con el literal
  // outline del tema. surfaceBase y surfaceElevated son valores únicos
  // del catálogo, lavados fríos para superficies decorativas, y no se
  // corresponden con ningún rol del esquema.

  /// Superficie base fría, lavado claro azulado para decorado.
  static const surfaceBase = Color.fromARGB(255, 240, 240, 248);

  /// Superficie elevada fría, lavado azulado más intenso para decorado.
  static const surfaceElevated = Color.fromARGB(255, 220, 220, 243);

  /// Borde sutil oscuro. Comparte hex con borderDark, secondaryDark,
  /// mutedDark e inputDark, más el literal outline del tema.
  static const Color borderSubtle = Color(0xFF454545);

  // ═════════════════════════════════════════════════════════════
  // ROLES (9 tipos)
  // ═════════════════════════════════════════════════════════════
  // Duplicación de valor declarada entre roles y facultades:
  // roleJudgeALight comparte 0xFF3B82F6 con facultyFIO, roleJudgeDLight
  // comparte 0xFFA855F7 con facultyFTI, roleOrganizerLight comparte
  // 0xFF22C55E con successLight y facultyFTL, roleOrganizerDark comparte
  // 0xFF16A34A con successDark. roleUnknown escala slate para separarse
  // del gris de espectador y señalar anomalía de datos: en claro se
  // oscurece y en oscuro se aclara, que es la dirección correcta para
  // texto sobre la superficie de cada modo.

  /// Identidad de administrador en claro, rojo.
  static const Color roleAdminLight = Color(0xFFEF4444);

  /// Identidad de juez principal en claro, ámbar.
  static const Color roleJudgePrincipalLight = Color(0xFFF59E0B);

  /// Identidad de juez de arte en claro, azul. Comparte hex con facultyFIO.
  static const Color roleJudgeALight = Color(0xFF3B82F6);

  /// Identidad de juez de dificultad en claro, violeta. Comparte hex con
  /// facultyFTI.
  static const Color roleJudgeDLight = Color(0xFFA855F7);

  /// Identidad de juez de ejecución en claro, índigo.
  static const Color roleJudgeELight = Color(0xFF6366F1);

  /// Identidad de entrenador en claro, teal.
  static const Color roleCoachLight = Color(0xFF14B8A6);

  /// Identidad de organizador en claro, verde. Comparte hex con
  /// successLight y facultyFTL.
  static const Color roleOrganizerLight = Color(0xFF22C55E);

  /// Identidad de espectador en claro, gris.
  static const Color roleViewerLight = Color(0xFF6B7280);

  /// Rol desconocido o no catalogado en claro. Escala slate para separarlo
  /// del gris de espectador y señalar anomalía de datos. En claro se
  /// oscurece, que es la dirección correcta para texto sobre superficie
  /// clara.
  static const Color roleUnknownLight = Color(0xFF475569);

  /// Identidad de administrador en oscuro, rojo.
  static const Color roleAdminDark = Color(0xFFDC2626);

  /// Identidad de juez principal en oscuro, ámbar.
  static const Color roleJudgePrincipalDark = Color(0xFFD97706);

  /// Identidad de juez de arte en oscuro, azul.
  static const Color roleJudgeADark = Color(0xFF2563EB);

  /// Identidad de juez de dificultad en oscuro, violeta.
  static const Color roleJudgeDDark = Color(0xFF9333EA);

  /// Identidad de juez de ejecución en oscuro, índigo.
  static const Color roleJudgeEDark = Color(0xFF4F46E5);

  /// Identidad de entrenador en oscuro, teal.
  static const Color roleCoachDark = Color(0xFF0D9488);

  /// Identidad de organizador en oscuro, verde. Comparte hex con
  /// successDark.
  static const Color roleOrganizerDark = Color(0xFF16A34A);

  /// Identidad de espectador en oscuro, gris.
  static const Color roleViewerDark = Color(0xFF9CA3AF);

  /// Rol desconocido o no catalogado en oscuro, más claro que el gris de
  /// espectador para que no se confundan. En oscuro se aclara, que es la
  /// dirección correcta para texto sobre superficie oscura.
  static const Color roleUnknownDark = Color(0xFFCBD5E1);

  // ═════════════════════════════════════════════════════════════
  // FACULTADES (UCI)
  // ═════════════════════════════════════════════════════════════
  // Duplicación de valor declarada con roles: facultyFIO comparte
  // 0xFF3B82F6 con roleJudgeALight, facultyFTI comparte 0xFFA855F7 con
  // roleJudgeDLight, facultyFTL comparte 0xFF22C55E con roleOrganizerLight
  // y successLight. facultyFTE es valor único.

  /// Facultad de Informática en claro, azul. Comparte hex con
  /// roleJudgeALight.
  static const Color facultyFIO = Color(0xFF3B82F6);

  /// Facultad de Lenguas en claro, verde. Comparte hex con
  /// roleOrganizerLight y successLight.
  static const Color facultyFTL = Color(0xFF22C55E);

  /// Facultad de Interdisciplinaria en claro, violeta. Comparte hex con
  /// roleJudgeDLight.
  static const Color facultyFTI = Color(0xFFA855F7);

  /// Facultad de Económicas en claro, amarillo. Valor único.
  static const Color facultyFTE = Color(0xFFEAB308);

  // ═════════════════════════════════════════════════════════════
  // TOKENS SEMANTICOS DE ESTADO (tinte suave, aditivos)
  // ═════════════════════════════════════════════════════════════
  // Pares de contenedor tenue y texto saturado por modo para las
  // variantes semánticas del catálogo. Son aditivos: los tokens de marca
  // success y destructive tienen muchos consumidores fuera del badge y
  // no se mutan aquí. Los valores salen de una escala consciente del
  // contraste y la prueba numérica los verifica.

  /// Contenedor tenue de éxito en claro.
  static const Color successContainerLight = Color(0xFFDCFCE7);

  /// Texto saturado de éxito sobre su contenedor en claro.
  static const Color successOnContainerLight = Color(0xFF166534);

  /// Contenedor tenue de éxito en oscuro.
  static const Color successContainerDark = Color(0xFF052E16);

  /// Texto saturado de éxito sobre su contenedor en oscuro.
  static const Color successOnContainerDark = Color(0xFF4ADE80);

  /// Contenedor tenue informativo en claro.
  static const Color infoContainerLight = Color(0xFFDBEAFE);

  /// Texto saturado informativo sobre su contenedor en claro.
  static const Color infoOnContainerLight = Color(0xFF1E40AF);

  /// Contenedor tenue informativo en oscuro.
  static const Color infoContainerDark = Color(0xFF172554);

  /// Texto saturado informativo sobre su contenedor en oscuro.
  static const Color infoOnContainerDark = Color(0xFF93C5FD);

  /// Contenedor tenue de atención en claro.
  static const Color warningContainerLight = Color(0xFFFEF3C7);

  /// Texto saturado de atención sobre su contenedor en claro.
  static const Color warningOnContainerLight = Color(0xFF92400E);

  /// Contenedor tenue de atención en oscuro.
  static const Color warningContainerDark = Color(0xFF451A03);

  /// Texto saturado de atención sobre su contenedor en oscuro.
  static const Color warningOnContainerDark = Color(0xFFFCD34D);

  /// Contenedor tenue destructivo en claro.
  static const Color destructiveContainerLight = Color(0xFFFEE2E2);

  /// Texto saturado destructivo sobre su contenedor en claro.
  static const Color destructiveOnContainerLight = Color(0xFFB91C1C);

  /// Contenedor tenue destructivo en oscuro.
  static const Color destructiveContainerDark = Color(0xFF450A0A);

  /// Texto saturado destructivo sobre su contenedor en oscuro.
  static const Color destructiveOnContainerDark = Color(0xFFFCA5A5);

  // ═════════════════════════════════════════════════════════════
  // GRADIENTES
  // ═════════════════════════════════════════════════════════════

  /// Degradado de marca, fucsia a violeta, en diagonal o centrado.
  ///
  /// Lee glowFuchsia y glowViolet. El parámetro diagonal controla la
  /// dirección: verdadero va de esquina superior izquierda a inferior
  /// derecha, falso centra ambos extremos.
  static LinearGradient getGlowGradient({bool diagonal = true}) {
    return LinearGradient(
      begin: diagonal ? Alignment.topLeft : Alignment.center,
      end: diagonal ? Alignment.bottomRight : Alignment.center,
      colors: const [glowFuchsia, glowViolet],
    );
  }
}
