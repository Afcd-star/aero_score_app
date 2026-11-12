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