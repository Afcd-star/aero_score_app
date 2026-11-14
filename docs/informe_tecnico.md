# Informe tecnico de AeroScore

## 1. Proposito

Radiografia honesta del estado real de la aplicacion, bitacora de
decisiones tecnicas y base para auditoria de calidad. No es material de
marketing. Este documento se actualiza en el mismo commit que cierra
cada funcionalidad, junto con el changelog y la version.

## 2. Arquitectura

Organizacion feature first con Clean Architecture en cuatro capas por
funcionalidad: dominio, datos, inyeccion y presentacion. El orden de
ataque dentro de cada funcionalidad es fijo y no negociable.

- Dominio: tipos, enums, entidades con Freezed y contratos de
  repositorio. Se valida con analisis estatico y prueba de unidad de
  igualdad.
- Datos: modelos con Freezed y json_serializable, implementaciones de
  repositorio con manejo explicito de errores y lectura segura de mapas.
  Se valida con analisis estatico y prueba de repositorio con dobles.
- Inyeccion: proveedores de datos. Se valida que el proveedor sea unico
  por funcionalidad.
- Presentacion: estados, notifiers, vistas y widgets del catalogo de
  marca. Se valida con analisis estatico y prueba de widget.
- Cierre: commit atomico por capa con mensaje que refleje el cambio real.

Arbol de lib:

- lib/src/core: tema, rutas, inyeccion global, errores de dominio y
  utilidades transversales.
- lib/src/shared: catalogo de widgets Aero y componentes comunes.
- lib/src/features/admin: panel de administracion.
- lib/src/features/auth: autenticacion, registro, sesion y aprobacion
  pendiente.
- lib/src/features/competitors: gestion de competidores.
- lib/src/features/events: gestion de eventos.
- lib/src/features/teams: gestion de equipos.
- lib/src/features/scoring: modulo de calificacion.

## 3. Stack y decisiones

- Estado: Riverpod 3.x con proveedores manuales tipados. La migracion a
  anotaciones viaja en el frente de toolchain, no dentro de una feature
  a mitad de ciclo, para no mezclar manual y generado en la misma
  funcionalidad. Esta decision corrige la especificacion anterior que
  declaraba las anotaciones como obligatorias de inmediato.
- Enrutamiento: GoRouter con la ruta como fuente de verdad de la
  seccion activa donde aplica.
- Modelado: Freezed para inmutabilidad y equality, json_serializable
  para mapeo. Regla: nunca editar el generado, regenerar con
  build_runner.
- Errores: either_dart con Left de Failure tipado. La clase base Failure
  implementa Exception para permitir propagar el fallo por throw sin
  violar el lint de solo lanzar errores.
- Backend: PocketBase con cliente global que restaura la sesion desde
  SharedPreferences. Los repositorios reciben el cliente inyectado, no
  construyen el suyo, para que todas las consultas lleven token.
- UI: Material 3 con catalogo Aero propio. Regla operativa: si un widget
  del catalogo cubre la necesidad, se usa el catalogo; si no, se
  extiende el catalogo antes de improvisar en la vista.
- Tipografia: Sora para titulos y Manrope para cuerpo, con los quince
  roles de TextTheme declarados. Un rol ausente anula en silencio
  tamano, peso y color via copyWith.
- Idioma: codigo en ingles, comentarios e interfaz en espanol.

## 4. Estado por funcionalidad

- Autenticacion: corregida y estable a nivel de analisis estatico.
  Maquina de estados sellada con AuthInitial, AuthLoading,
  AuthPendingApproval, AuthSuccess y AuthError. Deuda funcional abierta:
  la clase de aprobacion pendiente no esta marcada como final, la
  ventana de solapamiento en restauracion de sesion requiere prueba, y
  el cierre de sesion abandona la llamada remota sin error recuperable.
- Competidores: saneada en sesiones anteriores. Deuda de cabecera con
  ruta vieja registrada.
- Eventos: saneada en sesiones anteriores, con dos bloqueos de
  compilacion resueltos en el desbloqueo minimo. Deuda de cabecera y de
  lints internos registrada.
- Equipos: pendiente de auditoria. No ha entrado en el ciclo archivo por
  archivo. Arrastra la mayor deuda de compilacion restante.
- Calificacion: pendiente de auditoria. No ha entrado en el ciclo.
- Administracion: CERRADA. Primer hito bajo checklist completo. Evidencia:
  cero avisos en el perimetro de la feature, veintiun pruebas de unidad
  verdes en cinco archivos, documentacion publica en espanol, lineas
  dentro de ochenta columnas, salto final, y pase visual en modo claro y
  oscuro. Se ejecuto el orden fijo de capas: dominio con entidades
  Freezed y contrato podado a dos metodos, datos con DTO manual de
  actividad, inyeccion con cliente global inyectado y Failure tipado en
  AsyncValue, presentacion con navegacion tipada derivada del enum y
  seccion sincronizada desde la ruta. Se reubicaron a sus features las
  hojas de competidor y equipos, el provider de coaches y la gestion de
  roles, y los dos casos de uso que estaban mal alojados en auth. Se
  eliminaron como codigo muerto el provider y el header del panel,
  probado por grep de consumidores vacio.

## 5. Deuda tecnica registrada y priorizada

Identificada, escrita y con precondicion. No corregida porque excede el
alcance del cierre o exige archivos aun no auditados.

- Prueba del repositorio de administracion contra PocketBase.
  Precondicion: cliente http inyectable en el contrato.
- Heuristica de dos segundos para deducir la accion de actividad.
  Precondicion: coleccion de auditoria en el backend.
- AppEnvironment como segunda fuente de verdad de entorno frente al
  define de compilacion del DI. Frente de core.
- URL de produccion de AppEnvironment es un marcador. Bloquea cualquier
  compilacion de release. Frente de release.
- Notifiers de estado de interfaz alojados dentro de data di, lo que
  hace que data importe presentacion. Frente de layout.
- Veintiun avisos de los tres widgets de administracion en shared
  (admin_quick_action, admin_stats_card, section_card): documentacion y
  lineas largas. Frente de shared.
- Vinetas del reglamento usan el primer color del degradado y se
  camuflan sobre su fondo. Frente de catalogo.
- Monograma fijo en el menu lateral en lugar de avatar de usuario.
  AeroAvatar existe en el catalogo; la decision de diseno es del frente
  de catalogo y tema.
- Catalogo de botones con altura desproporcionada y relleno blanco que
  desconecta de la marca. Frente de catalogo.
- Aviso de build_runner que compara el SDK con el analyzer. Causa raiz:
  analyzer clavado por la cadena riverpod_lint, riverpod_analyzer_utils
  y custom_lint_visitor. No se resuelve con pub upgrade. Frente de
  toolchain, con versiones verificadas por pub outdated y gate global.
- Manifiesto principal de Android sin permiso de red ni texto claro.
  Bloquea release y dispositivo fisico. Frente de Android.
- Cabeceras con ruta vieja en cuatro archivos ajenos a administracion.
  Se corrigen al abrir el frente de cada feature.

## 6. Checklist de cierre de funcionalidad

- Dominio, datos, inyeccion y presentacion en el orden fijo.
- Proveedores tipados, sin mezcla de manual y generado en la feature.
- Vistas usando el catalogo, sin widgets crudos duplicados.
- Documentacion publica en espanol completa.
- Lineas dentro de ochenta columnas y salto final.
- Directivas ordenadas alfabeticamente.
- Pruebas de unidad de dominio y datos, y prueba de widget de
  presentacion. flutter test en verde es requisito de gate.
- Pase visual en modo claro y oscuro cuando la feature toca superficie.
- Commit atomico por capa con mensaje descriptivo.
- Cierre documental: un commit que sube version, escribe changelog,
  actualiza este informe e intentions, y etiqueta. Antes de abrir la
  siguiente feature.

## 7. Ritual de gate

- dart run build_runner build con la bandera de salida en conflicto.
- dart analyze filtrado al perimetro de la feature. Cero severity 8.
  Los infos de otras features no bloquean el commit de esta, se anotan
  como deuda de su frente.
- flutter test en verde.
- Guardia de estado antes de cada commit: solo las rutas esperadas
  preparadas, nada suelto inesperado.
- Mensaje de commit en archivo temporal UTF8 sin BOM, add explicito,
  commit, borrado del temporal, estado final vacio. Push al cierre de
  capa o de feature segun la regla acordada.

## 8. Versionado

- Esquema SemVer previo a 1.0: 0.MINOR.PATCH. Minor por cierre de
  feature, patch por correccion. 1.0.0 exige esquema de PocketBase
  congelado y las seis features auditadas con pruebas.
- Hito actual: 0.1.0, administracion cerrada como primera feature bajo
  checklist completo con pruebas. El trabajo parcial de auth,
  competitors y eventos de sesiones anteriores se pliega en el changelog
  como historico sin etiquetas retroactivas, porque no se planearon para
  etiquetar.
- Mecanismo: en el commit de cierre documental se sube la linea version
  de pubspec.yaml, se anade entrada en docs/changelog.md, se actualiza
  este informe e intentions, y se crea etiqueta anotada. Un solo gesto
  ata docs y version.
- Sufijo de prelanzamiento para estados no auditados que necesiten
  build: 0.X.0-rc.N.

## 9. Registro de correcciones de metodo del lead

Diez correcciones registradas en esta conversacion, por honestidad de
auditoria. El patron recurrente es actuar sobre suposicion en vez de
sobre evidencia leida.

1. Inventar el nombre del tipo de retorno de getList en vez de leer la
   inferencia del repositorio de produccion.
2. Recomendar pub upgrade que no resolvia el aviso del analyzer y rompia
   la bandera del ritual de gate.
3. Comando git restore sin fuente explicita a HEAD, restaurando desde un
   indice sucio.
4. Grep que mezclaba comentarios de cabecera con imports reales.
5. Grep demasiado ancho que casaba la palabra admin en rutas de shared.
6. Import sin uso entregado en una suite de prueba.
7. Patron de cascada sobre literal constante en dos suites de prueba.
8. Afirmar que el catalogo no tenia avatar cuando AeroAvatar existia y
   se usaba en produccion.
9. Plan de reescribir provider y header que eran codigo muerto con cero
   consumidores.
10. Suponer que los casos de uso no existian cuando estaban mal alojados
    en auth.

Contramedida adoptada: leer el contrato o el grafo de consumidores antes
de escribir, y verificar con gate y guardia en vez de con fe.