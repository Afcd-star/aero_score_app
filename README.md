# AeroScore

Radiografia tecnica del proyecto. No es documento comercial ni de
marketing. Es referencia interna del equipo y base para auditorias de
calidad. Se actualiza al cierre de cada funcionalidad.

La bitacora de decisiones y el registro de deuda viven en
`docs/intentions.md`. El informe por hito en `docs/informe_tecnico.md` y
el historial de cambios en `docs/changelog.md`.

## Que es

Aplicacion movil multiplataforma para la gestion integral de
competiciones de acrobacias deportivas. Cubre el ciclo de un evento:
registro de usuarios con aprobacion administrativa, rechazo y
desactivacion de cuentas, creacion y administracion de eventos, gestion
de equipos, alta y edicion de competidores, asignacion de jueces por
especialidad, reglamento y consulta de estadisticas y actividad reciente.
La captura de puntuacion y la consulta de resultados para visitantes
estan en construccion.

Operar con conectividad intermitente y sentirse nativa en cada plataforma
son objetivos del producto, no capacidades actuales: la sincronizacion
sin conexion no esta iniciada.

## Estado por modulo, medido

- Administracion: cerrada en 0.1.0. Panel con siete secciones, metricas y
  actividad reciente. Cero avisos del analizador.
- Equipos: cerrada en 0.2.0. Validacion unificada, modelo tipado contra el
  esquema vivo y borrado logico coherente. Cero avisos.
- Usuarios y aprobacion: cerrada en 0.3.0. Seccion propia con filtros,
  busqueda y refrescar. Aprobar, rechazar, desactivar y reactivar, con
  lote sobre el filtro que le da sentido. Cero avisos.
- Autenticacion: flujo de aprobacion cerrado de extremo a extremo y
  entidad documentada. Deuda de raiz: el estado de cuenta es cadena
  suelta y pide enumerado con conversion desde almacenamiento.
- Competidores: saneada en analisis estatico. Sin prueba de repositorio y
  con el escape de filtro pendiente de adoptar.
- Eventos: saneada en analisis estatico, con once errores de presentacion
  pendientes, de las mismas clases ya corregidas en equipos.
- Puntuacion: en construccion. Tiene modelos, repositorio, notificador y
  vista, con cincuenta y un errores concentrados en lecturas de datos sin
  tipar. Sus rutas ya no se alcanzan por inicio de sesion: los cuatro
  roles de juez aterrizan en un marcador.
- Visitante y resultados: no existe. El rol espectador no tiene destino
  propio y hoy acaba en la pantalla de cuenta pendiente, que le miente.
- Sincronizacion sin conexion: no iniciada. Precondicion de backend: una
  coleccion de cola o de estado que hoy no esta en ninguna migracion.

## Metricas medidas

- Pruebas automatizadas: sesenta y nueve, verdes.
- Errores de analisis estatico: sesenta y seis, concentrados en
  puntuacion, eventos y catalogo compartido.
- Modulos en cero avisos: administracion, equipos, y la seccion de
  usuarios con su tarjeta.

Las pruebas cubren entidades de dominio, notificadores, logica de lote,
escape de filtros y piezas de catalogo con render a ancho estrecho. Los
repositorios siguen sin prueba porque el cliente de PocketBase no es
inyectable: es desviacion registrada, no olvido.

## Stack

- Lenguaje y SDK: Dart 3 con null safety activo.
- Framework de interfaz: Flutter con Material 3.
- Gestion de estado: Riverpod 3.x con proveedores manuales tipados. Las
  anotaciones y la generacion viajan en el frente de toolchain, no como
  norma inmediata.
- Enrutamiento: GoRouter con rutas declarativas y redireccion por rol.
- Backend y datos: PocketBase como fuente de verdad, con capa de
  repositorios propia y cliente global inyectado.
- Persistencia local: SharedPreferences para sesion, token y marca de
  tiempo de inicio.
- Modelado: Freezed 3 en administracion. Las entidades de equipos y de
  usuario son clases manuales, con migracion registrada.
- Serializacion: json_serializable con claves explicitas.
- Resultados tipados: either_dart para separar exito de fallo sin
  excepciones silenciosas.
- Graficos: fl_chart para visualizaciones ligeras.
- Calidad estatica: very_good_analysis como conjunto de reglas.
- Pruebas: flutter_test con dobles hechos a mano. mocktail sigue
  declarado pero sin uso; la decision escrita es doble a mano.
- Generacion: build_runner como orquestador de codigo generado.

## Arquitectura

Clean architecture con organizacion vertical por funcionalidad. Cada
modulo vive aislado con dominio, datos, inyeccion y presentacion. La
regla de oro es la direccion de dependencia: presentacion depende de
dominio y datos, datos depende de dominio, dominio no depende de nadie.
Cualquier violacion se corrige en el momento. El catalogo compartido vive
en `shared` y lo consumen los modulos.

## Como compilar, generar y validar

    flutter pub get
    dart run build_runner build --delete-conflicting-outputs
    dart analyze
    flutter test
    flutter run

El generador solo es necesario cuando el cambio toca fuentes con
anotaciones, clases con partes generadas o el manifiesto. En cambios de
documentacion, de presentacion sin anotaciones o de logica pura, la puerta
es analisis mas pruebas.

Toda prueba viva se reporta declarando el modo de recarga usado. Cambio
de rutas, proveedores, clases selladas o enumeraciones exige reinicio en
caliente; cambio de manifiesto, recursos o nativo exige parada completa.

## Deuda registrada, por bloqueo de lanzamiento

Primero lo que impide publicar:

- El manifiesto principal de Android no declara permiso de red, asi que la
  compilacion de lanzamiento no tiene red. Depuracion y perfil si lo
  declaran, y depuracion ya permite texto claro para red local.
- La URL de produccion del entorno es un marcador.
- Las rutas de puntuacion apuntan a una pantalla sin construir. Antes de
  publicar, o se construye y se prueba, o se retiran o se protegen.
- El espectador no tiene destino propio. Sin vista de resultados, su
  destino honesto es un marcador de modulo, no la pantalla de espera.
- El guard de rutas es por prefijo, no por permisos dinamicos de la
  coleccion Roles, que existe sin datos sembrados ni consumidor.
- La sincronizacion sin conexion no existe.

Despues lo que degrada calidad sin impedir publicar:

- Tokens semanticos de estado y de marca. El badge tiene el contraste
  roto en exito y la condicion de atencion invertida, y el fucsia con
  blanco queda marginal para texto pequeno.
- Cuatro piezas de catalogo por crear: aviso temporal con su tema,
  marcador de modulo, indicador de progreso y hoja modal.
- Documentacion publica del catalogo, con avisos acumulados en boton y
  envoltorio de formulario, y veintiun avisos en los tres widgets de
  administracion en shared.
- La guia de uso del catalogo describe piezas que no existen en el arbol,
  y sus referencias rotas ya llegaron a comentarios del codigo.
- Enumerado de estado de cuenta, para retirar los literales sueltos de
  entidad, modelo, enrutador, filtro y tarjeta.
- AppEnvironment como segunda fuente de verdad de entorno frente al
  define de compilacion.
- Notifiers de estado de interfaz alojados en data di, lo que hace que
  datos importe presentacion.
- Log de auditoria inexistente en el backend. La actividad reciente usa
  una heuristica de marcas de tiempo.
- Registro de rol desconocido solo de depuracion.
- Aviso de build_runner que compara el SDK con el analyzer, clavado por la
  cadena de riverpod_lint. No se resuelve con actualizacion suelta.
- Prueba de widget del guard de alcance del lote, diferida con ruta y
  casos escritos.
- Repositorios sin prueba por cliente no inyectable.

## Normas de codigo

Identificadores, nombres de archivo, clases, metodos y variables en
ingles. Comentarios, documentacion publica y mensajes de cara al usuario
en espanol. Prohibido el guion medio y la raya en cualquier literal,
comentario o texto; cuando un valor de negocio lo exige, se representa
mediante secuencia Unicode equivalente. Prohibidas las formas verbales y
los terminos relacionados con la mejora forzada de rendimiento; se emplean
sinonimos como ajuste, afinamiento, mejora, rendimiento o eficiencia segun
el contexto. Literales de cadena adyacentes en lugar de concatenacion con
el operador de suma. Lineas de maximo 80 columnas. Salto de linea
obligatorio al final de cada archivo. Directivas de importacion ordenadas
alfabeticamente por ruta completa, con la seccion de dart al inicio.
Documentacion publica en espanol para toda clase, constructor, metodo y
propiedad expuesta. Constructores sin nombre declarados antes que
factorias y antes que el resto de miembros. Parametros nombrados
requeridos declarados antes que los opcionales. Clausulas de captura de
excepcion siempre explicitas con on, nunca peladas. Llamadas a Future en
contexto sincronico envueltas en unawaited o convertidas a await segun el
contrato. Tipos explicitos en callbacks de interfaz y en argumentos de
tipo que el analizador no puede inferir; en variables locales con
inicializador se usa var o final sin tipo. Dependencias del manifiesto
ordenadas alfabeticamente, sin bloques de comentario entre ellas, con
contexto en comentario inline al final de cada linea.

## Formato de commit

Conventional commits con tipo en ingles y descripcion en espanol.
Ejemplo: `feat: anadir el repositorio de roles en auth`. Los tipos se
quedan en ingles porque son tokens que herramientas de changelog parsean;
la prosa va en espanol conforme a la norma de documentacion del equipo.

Cada commit declara ubicacion en el plan, que se hace con numeros, por
que, que no se toca, que valida la puerta y notas de riesgo. Los commits
se limitan por rutas para que el residuo del indice no se cuele; los
archivos nuevos se preparan antes porque esa forma solo acepta rutas
conocidas por git. Cada bloque de terminal se basta a si mismo y declara
su propia codificacion.

## Backend

PocketBase corre como binario independiente en una carpeta hermana del
proyecto Flutter, no dentro de este arbol. Sus migraciones, su directorio
de datos y su archivo de datos de prueba no forman parte del repo de la
aplicacion. La fuente de verdad del esquema son las migraciones
versionadas en el lado del backend.