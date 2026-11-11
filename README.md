# AeroScore

Radiografia tecnica del proyecto. No es documento comercial ni de
marketing. Es referencia interna del equipo, bitacora de decisiones
y base para auditorias de calidad. Se actualiza al cierre de cada
funcionalidad.

## Que es

Aplicacion movil multiplataforma para la gestion integral de
competiciones de acrobacias deportivas. Cubre el ciclo completo de
un evento: registro de usuarios con aprobacion administrativa,
creacion y administracion de eventos, gestion de equipos, alta y
edicion de competidores, asignacion de jueces por especialidad,
captura de reglas y reglamento, configuracion del panel y consulta
de estadisticas y actividad reciente. Pensada para operar con
conectividad intermitente, con panel de administracion rico en
acciones e interfaz que debe sentirse nativa en cada plataforma
destino.

## Stack

* Lenguaje y SDK: Dart 3 con null safety activo.
* Framework de interfaz: Flutter con Material 3.
* Gestion de estado: Riverpod 3.x con anotaciones y generacion de
  codigo.
* Enrutamiento: GoRouter con rutas declarativas.
* Backend y datos: PocketBase como fuente de verdad, con capa de
  repositorios propia.
* Persistencia local: SharedPreferences para sesion, token y marca
  de tiempo de inicio.
* Modelado inmutable: Freezed 3 para entidades de dominio, DTO y
  estados de pantalla.
* Serializacion: json_serializable con claves explicitas.
* Resultados tipados: either_dart para separar exito de fallo sin
  excepciones silenciosas.
* Graficos: fl_chart para visualizaciones ligeras.
* Calidad estatica: very_good_analysis como conjunto de reglas.
* Pruebas: flutter_test con mocktail para dobles de prueba.
* Generacion: build_runner como orquestador de codigo generado.

## Arquitectura

Clean architecture con organizacion vertical por funcionalidad.
Cada modulo de negocio vive aislado en su propia carpeta y expone
tres capas internas: dominio, datos y presentacion. La regla de oro
es la direccion de dependencia: presentacion depende de dominio y
datos, datos depende de dominio, dominio no depende de nadie.
Cualquier violacion se corrige en el momento, sin excepciones.

## Estado por funcionalidad

* Autenticacion: saneada a nivel de analisis estatico. Deuda
  funcional registrada.
* Competidores: saneada a nivel de analisis estatico.
* Eventos: saneada a nivel de analisis estatico tras generacion de
  codigo.
* Administracion: en revision. Capa uno de dominio cerrada. Capa
  dos de datos pendiente de abrir tras el baseline versionado.
* Equipos: pendiente de auditoria archivo por archivo.
* Calificacion: contiene el juicio de expresion artistica,
  dificultad y ejecucion de forma unificada. Las carpetas que antes
  se preveian separadas para esas tres especialidades se borraron
  por no tener contrato propio.
* Sincronizacion: no iniciada. Precondicion de backend: una
  coleccion de cola o de estado de sincronizacion que hoy no existe
  en ninguna migracion. Precondicion de dominio: un ciclo completo
  de evento cerrado de extremo a extremo.

## Deuda registrada y priorizada

* Sin cobertura de pruebas para repositorios, modelos y proveedores
  de las funcionalidades ya saneadas.
* Hojas de competidor y de equipos alojadas en administracion que
  no pertenecen a ese modulo. Destino: sus funcionalidades.
* Modelos de datos de administracion ausentes. Destino: crear la
  capa de modelos con Freezed y json_serializable.
* Repositorio de administracion sin stream de tiempo real estable.
  Destino: definir el contrato de consulta antes de suscripcion.
* Log de auditoria inexistente en el backend. La actividad reciente
  usa una heuristica de marcas de tiempo como deuda explicita.
* Catalogo de widgets sin estado vacio ni placeholder de modulo.
  Empty states improvisados en la vista. Destino: crear
  AeroEmptyState y AeroModulePlaceholder al auditar shared, bloque
  final del plan.
* Guard de rutas basico por prefijo. Destino: consumir permisos
  dinamicos desde la coleccion Roles al cerrar la capa de datos de
  roles.
* Registro de rol desconocido por ahora solo de depuracion. Destino:
  puerto de registro o coleccion de auditoria.

## Normas de codigo

Identificadores, nombres de archivo, clases, metodos y variables en
ingles. Comentarios, documentacion publica y mensajes de cara al
usuario en espanol. Prohibido el guion medio y la raya en cualquier
literal, comentario o texto; cuando un valor de negocio lo exige, se
representa mediante secuencia Unicode equivalente. Prohibidas las
formas verbales y los terminos relacionados con la mejora forzada de
rendimiento; se emplean sinonimos como ajuste, afinamiento, mejora,
rendimiento o eficiencia segun el contexto. Literales de cadena
adyacentes en lugar de concatenacion con el operador de suma. Lineas
de maximo 80 columnas. Salto de linea obligatorio al final de cada
archivo. Directivas de importacion ordenadas alfabeticamente por ruta
completa, con la seccion de dart al inicio. Documentacion publica en
espanol para toda clase, constructor, metodo y propiedad expuesta.
Constructores sin nombre declarados antes que factorias y antes que
el resto de miembros. Parametros nombrados requeridos declarados
antes que los opcionales. Clausulas de captura de excepcion siempre
explicitas con on, nunca peladas. Llamadas a Future en contexto
sincronico envueltas en unawaited o convertidas a await segun el
contrato. Tipos explicitos en callbacks de interfaz y en argumentos
de tipo que el analizador no puede inferir. Dependencias del
manifiesto ordenadas alfabeticamente, sin bloques de comentario entre
ellas, con contexto en comentario inline al final de cada linea.

## Como compilar y generar

Instalar dependencias: `flutter pub get`

Generar codigo de Freezed, json_serializable y Riverpod: `dart run build_runner build --delete-conflicting-outputs`


Ejecutar la aplicacion: `flutter run`

Correr analisis estatico: `dart analyze`

Correr pruebas: `flutter test`


## Formato de commit

Conventional commits con tipo en ingles y descripcion en espanol.
Ejemplo: `feat: anadir el repositorio de roles en auth`. Los tipos
(`feat`, `fix`, `chore`, `refactor`, `docs`, `test`) se quedan en
ingles porque son tokens que herramientas de changelog parsean; la
prosa que los acompana va en espanol conforme a la norma de
documentacion del equipo.

## Backend

PocketBase corre como binario independiente en una carpeta hermana
del proyecto Flutter, no dentro de este arbol. Sus migraciones, su
directorio de datos y su archivo de datos de prueba no forman parte
del repo de la aplicacion. La fuente de verdad del esquema son las
migraciones versionadas en el lado del backend.

