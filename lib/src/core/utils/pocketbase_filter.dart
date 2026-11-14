// lib/src/core/utils/pocketbase_filter.dart

/// Utilitario para interpolar valores de usuario en filtros de PocketBase.
///
/// PocketBase delimita las cadenas de un filtro con comillas dobles y no
/// escapa los valores por ti, asi que un texto con comilla o barra
/// invertida puede cerrar la cadena y ejecutar fragmentos del filtro.
/// Este helper escapa primero la barra invertida y despues la comilla,
/// en ese orden, para que las barras que anadimos al escapar comillas no
/// se doblen. Lo consumen todos los repositorios que arman filtros con
/// entrada del usuario, no solo equipos.
String escapeFilterValue(String value) {
  return value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');
}
