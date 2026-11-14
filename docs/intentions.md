# Intenciones de arquitectura pendientes

Este documento registra carpetas y capacidades planeadas que
aún no tienen contrato de backend ni de dominio. No se crea
código en `lib` para ninguna de ellas hasta que exista el
esquema que la respalda. El objetivo es evitar carpetas vacías
que inviten a volcar implementación sin diseño.

## Sincronización

Precondición de backend: una colección de cola o de estado de
sincronización que hoy no existe en ninguna migración.
Precondición de dominio: un ciclo completo de evento cerrado,
es decir registro de evento, equipos, competidores, entrenadores
y jueces emitiendo puntuaciones.
Decisión: se desarrolla cuando la app logre ejecutar ese ciclo
completo de punta a punta. Mientras tanto no existe carpeta en
`lib`.

## Capacidades absorbidas

Las expresiones artística, dificultad y ejecución se modelan
dentro de la funcionalidad de calificación, que ya posee su
tipo de jurado, sus entidades y su caso de uso de puntuación
final. No se crean carpetas separadas para ellas.

El panel de administración contiene el tablero de métricas y
actividad del rol administrativo. No se crea una carpeta de
tablero aparte mientras no exista un contrato de resumen para
un rol distinto del administrador.

## Reglamento

Hoy es contenido estático tipado dentro del caparazón de
administración. Solo se convierte en funcionalidad propia
cuando exista una colección de reglamento en el backend que
permita su edición en tiempo de ejecución.

## Capitán de equipo

No es un rol de usuario. Es una capacidad extra de un
competidor, representada por su marca de capitán en la
entidad de competidor. No se añade al catálogo de identidad.

## Catálogo pendiente de shared

El catalogo actual no define estado vacio ni placeholder de
modulo. Existen empty states improvisados en la vista, lo cual
viola la regla de no improvisar cuando falta un widget de marca.

Al auditar shared, como bloque final del plan, se crean:

* AeroEmptyState para listas sin datos y resultados de busqueda
  vacios. Sustituye los empty states manuales de competitors,
  teams y role management.
* AeroModulePlaceholder para funciones aun no implementadas.
  Sustituye los destinos crudos de coach y organizer en el
  enrutador, y evalua la vista temporal de juez principal.

Mientras shared no se audite, no se crean nuevos empty states ni
placeholders improvisados en ninguna feature.

## Validacion visual pendiente

El color slate asignado al rol desconocido en el catalogo de
colores se valida en interfaz cuando se renderice el chip de rol
en la presentacion de autenticacion. Si tras verlo se confunde
con el gris de espectador, se mueve a un tono no gris. No se
considera cerrado el modelo de roles hasta esa validacion.

## Repositorio de roles postergado

La coleccion Roles existe en el backend con campo permissions de tipo
json libre y estado activo o inactivo en minuscula, renombrada a plural
por la migracion de rename. Pero no tiene datos sembrados y ningun
consumidor la lee hoy, porque la gestion de roles muta el campo role
del usuario via el repositorio de autenticacion, no la tabla Roles.

Crear su repositorio ahora seria codigo muerto. Se desarrolla cuando
existan dos precondiciones: datos sembrados en Roles y un consumidor
real que lea el catalogo dinamico de permisos. Mientras tanto el
modelo de identidad sigue siendo el enum canonico y el permiso
dinamico queda como intencion, no como implementacion.

Forma de permissions acordada para cuando se cree: arreglo de cuerdas
con los nombres del catalogo de permisos, mapeado al conjunto tipado
de dominio. El campo json del backend es opaco, asi que el cliente
fija la forma.

## Alineamiento de toolchain postergado

El aviso de build_runner que compara la version de lenguaje del SDK
con la del analyzer no se resuelve con pub upgrade. La causa raiz es
que analyzer queda clavado por la cadena riverpod_lint,
riverpod_analyzer_utils y custom_lint_visitor, cuyo sufijo de version
declara contra que analyzer esta compilado.

Precondicion: migrar la cadena completa de riverpod de forma
coherente, incluyendo annotation y generator, con versiones objetivo
verificadas por pub outdated y gate global, no por upgrade suelto.

Consecuencia observada del intento fallido: pub upgrade movio 43
dependencias, includo dos saltos mayores en build y equatable, y
build_runner 2.15 elimino la bandera delete conflicting outputs que
usa el ritual de gate. Se revertio el lock sin commitear.

Decision derivada: la capa cuatro de admin usa providers manuales,
como el resto de la casa, y la migracion a anotaciones viaja en este
frente junto con la cadena riverpod.

## Cabeceras con ruta vieja

Cuatro archivos conservan en su comentario de cabecera la ruta de
administracion desde la que fueron movidos en sesiones anteriores:
competitor_repository, event_list_view, team_repository_impl y
team_repository. No afectan al grafo de imports porque son comentarios,
pero mienten sobre la ubicacion del archivo. Se corrigen al abrir el
frente de cada feature, no antes, para no mezclar naturalezas.

## Layout de notifiers de interfaz

La convencion de la casa coloca notifiers de estado de interfaz dentro
de data di. Eso provoca que data di importe presentacion, como ocurre
en auth con el notifier de gestion de roles y en competidores con el
filtro de equipo. La ubicacion correcta es presentacion providers. Se
unifica en un pase de layout posterior al cierre de administracion,
con grep de consumidores por cada notifier movido.

## Pase visual del header del panel

El header del panel se construye hoy con widgets crudos y lectura
forzada del usuario. La correccion de comportamiento y tipado se hace
en capa cuatro. La reconstruccion visual con el catalogo de marca se
hace en el pase de shared, junto con AeroEmptyState y
AeroModulePlaceholder, para no inventar firmas de catalogo sin leerlas.

## Delta al cierre de administracion, version 0.1.0

Resuelto en este ciclo y ya no deuda abierta:

- Reubicacion de hojas de competidor y equipos a sus features.
- Creacion de modelos de datos de administracion con DTO de actividad.
- Contrato de repositorio podado a dos metodos y definido.
- Proveedor de administracion con cliente global inyectado y Failure
  tipado en AsyncValue.
- View del panel con navegacion tipada, seccion desde la ruta, cierre de
  sesion esperado y usuario protegado.
- Casos de uso reubicados de auth a administracion.
- Provider y header muertos eliminados por codigo muerto.
- Catalogo tipografico completo y saltos finales en todo el arbol.
- Legibilidad de configuracion, gestion de roles y tarjeta de roles en
  ambos temas.
- Suite de pruebas de administracion con veintiun casos verdes.

Nueva deuda registrada con precondicion:

- Prueba del repositorio de administracion contra PocketBase.
  Precondicion: cliente http inyectable.
- Heuristica de dos segundos de la actividad. Precondicion: coleccion de
  auditoria.
- Veintiun avisos de los tres widgets de administracion en shared.
  Frente de shared.
- Vinetas del reglamento camufladas. Frente de catalogo.
- Catalogo de botones con altura y relleno. Frente de catalogo.
- Monograma frente a avatar de usuario. Frente de catalogo y tema.
- Selector de tema con persistencia e interruptor. El cableado ya existe
  en main; falta persistencia e interfaz. Frente de tema.

Decision de versionado adoptada: 0.MINOR.PATCH previo a 1.0, minor por
cierre de feature, 1.0.0 con esquema de backend congelado y las seis
features auditadas. Hito actual 0.1.0.