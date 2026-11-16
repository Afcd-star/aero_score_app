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
## Norma de EOL para registrantes generados

Se anadio .gitattributes con text eol=lf para los diez registrantes
de plugins generados por flutter en android, ios, linux, macos y
windows. La causa es que el generador escribe LF y core.autocrlf en
Windows introduce deriva de finales de linea, lo que marco el
registrante de macos como modificado sin cambio de contenido, probado
por un diff vacio salvo el aviso de conversion. La regla fija LF en el
arbol de trabajo y elimina la deriva futura. No renormaliza blobs ya
comiteados con CRLF: si un registrante ya almacenado se marca como
modificado por EOL, se renormaliza esa ruta puntual con la bandera de
renormalizar de git add, no el arbol entero.

## Deudas abiertas tras el endurecimiento de equipos

Acoplamiento del literal de rol. Las reglas del server comparan el rol
contra Admin con mayuscula inicial. Hay que confirmar que el valor del
enum de rol del app serializa exactamente esa cadena, si no, todo el
CRUD de administrador falla en silencio con 403. Verificacion pendiente.

Falta un tipo de fallo de autorizacion en core. Hoy el 403 se traduce a
ServerFailure con mensaje de permiso denegado, porque AuthFailure es de
login y reutilizarlo mentiria semanticamente. La distincion de UX la
carga el mensaje. Frente de core.

Adopcion transversal del escape de filtro. El utilitario de core lo
consume equipos; competidores y eventos interpolan igual y deben
adoptarlo en sus frentes.

Borrado logico como bool. El contrato de equipos conserva void; el cambio
a bool y el manejo del error en el notificador van al pase de
presentacion de equipos.

Equipos inactivos legibles. Las reglas abren la lectura a cualquier
autenticado, incluido el estado inactivo; el app filtra por estado en las
consultas. Aceptado, anotado.

Centralizacion de textos a medias. Los mensajes del app estan escritos a
mano por todas partes, incluidos los de validacion y error que viven en
dominio y datos, lo que acopla esas capas a la copia de presentacion y a
un solo idioma. La centralizacion iniciada no termino. Frente de
lenguaje con decision previa: dominio devuelve codigos o cadenas.

Guiones en la interfaz. Los rangos de edad del reglamento usan guion. Si
la norma de escribir sin guion aplica tambien a la copia del app, hay que
reformularlos en el frente de lenguaje; si solo aplica a documentos, se
deja como esta. Decision pendiente del autor.

Limitacion de copyWith en la entidad de equipo. La implementacion manual
de copyWith usa la convencion de campo nulable con operador de oracion a
la izquierda, asi que no puede desasignar faculty, coachId, coachName ni
las marcas de tiempo. El formulario de edicion no puede quitar el
entrenador via copyWith. Precondicion de solucion: migrar TeamEntity a Freezed,
que distingue no cambiar de poner nulo con parametros opcionales reales.
Hay un test canario en la suite de dominio que fija la limitacion; cuando
Freezed la resuelva, el test fallara y avisara de borrar este bloque y
actualizar el test.

## Cierre del acoplamiento del literal de rol

RESUELTO. Verificado que el enum de rol serializa Admin con mayuscula
inicial, identico al literal de las reglas de la coleccion Teams del
server, y que la conversion desde almacenamiento compara por igualdad
exacta sin normalizacion. El riesgo de 403 silencioso en el CRUD de
administrador queda descartado. El bloque de deuda anterior se marca
como cerrado.

## Fase obligatoria de planilla de equipo

Requisito funcional confirmado por el autor, no opcional. No se
implemento en su momento por apuro de demo, cuando se queria mostrar
la apariencia de la app sin la persistencia real. El selector de
planilla se retiro del formulario en el pase de presentacion porque
recogia un archivo que el esquema vivo no podia guardar, pero la
funcionalidad vuelve como fase propia, no como deuda suelta.

Precondiciones que la fase debe cubrir, en orden de capas. Backend,
anadir un campo de archivo a la coleccion Teams y su migracion, lo
que obliga a reconciliar el historial de migraciones de Teams que hoy
no cuadra con el esquema vivo. Datos, mapear el campo en el modelo con
lectura segura y escritura, y decidir si la entidad expone el
identificador de archivo o un objeto de archivo. Presentacion,
restaurar la subida real con validacion de extension y tamano y la
llamada multipart de PocketBase, en lugar del selector muerto que se
quito. Esta fase va despues de cerrar equipos, calificacion, eventos y
competidores, y no se mezcla con el pase de forma de equipos porque
toca backend y datos, naturalezas distintas.

## Deudas abiertas tras el pase de presentacion de equipos

Crudos de catalogo en la presentacion de equipos. Indicadores de
carga circulares, estados vacios improvisados, avatares crudos,
tarjetas con filas de lista, contenedores, superficies sensibles a
pulsacion, detectores de gesto y dialogos crudos viven en los
selectores, la lista y la seccion. Deben migrar al catalogo cuando
shared se audite. Prohibido crear estados vacios nuevos mientras
tanto. Deuda de shared.

Colores cableados con ternarios de brillo. La seccion, el formulario
y la lista de equipos eligen texto y superficie con ternarios de
brillo en vez del esquema de tema. Van al frente de tema con el resto
del shell.

Patron de estado de formulario manual frente a valor asincrono. El
notifier de formulario usa banderas planas de carga, error y exito,
mientras el de lista usa notificador asincrono. No es un fallo, es
inconsistencia de patron que el frente de disposicion deberia
unificar. Deuda de disposicion.

Conteo de equipos incluye inactivos. El conteo por universidad y
facultad cuenta todos los registros sin filtrar estado, mientras la
lista si excluye inactivos. Los contadores pueden divergir de la lista
visible. Deuda de analitica, verificar la semantica deseada.

Pruebas de widget de presentacion. No se hicieron en este ciclo porque
requieren el catalogo estable. Deuda de shared, se cubren al auditar
el catalogo.

## Desviacion del checklist de cierre en pruebas de repositorio

El checklist de la informacion tecnica exige pruebas de repositorio
con dobles. Las de equipos se difieren porque el repositorio recibe un
cliente concreto de PocketBase y no un transporte inyectable, asi que
doblar la red exige antes refactorizar el contrato de acceso.
Precondicion: cliente de transporte inyectable en el repositorio de
equipos. Las pruebas de notificador que si se hicieron cubren la
logica de presentacion a nivel de estado, no la traduccion de red.
No es un olvido, es un alcance diferido con causa escrita.

## Deuda de filtrado de asignaciones ocupadas en los selectores de equipo

Destapada por el pase visual del cierre de equipos. Ambos modales,
entrenador y competidores, deben excluir a quienes ya formen parte de
un equipo activo. No se implementa en el cierre porque es crecimiento
de alcance: exige fijar reglas de dominio que el autor no ha declarado
y ampliar contratos de repositorio a una consulta cruzada entre
funcionalidades.

Precondicion de dominio, fijar dos reglas antes de codificar. Uno, la
unicidad del competidor, es decir si un competidor puede pertenecer a
un solo equipo activo o a varios, por ejemplo un duo mixto y un solo.
Si puede estar en varios, filtrar los ocupados esconderia competidores
validos y seria un bug. Dos, la multiplicidad del entrenador, es decir
si un entrenador dirige un solo equipo o varios. Si dirige varios,
filtrar los coachIds ocupados esconderia entrenadores validos y
romperia la creacion. El autor debe declarar ambas reglas, no se
asumen.

Precondicion de datos, exponer la consulta de asignaciones ocupadas.
Hoy el modal de competidores consume el proveedor de seleccion que
lista competidores sin saber de equipos, y el de entrenador lista
usuarios con rol de entrenador sin saber de equipos. Para filtrar hace
falta que el contrato de repositorio de equipos exponga los
identificadores de competidor y de entrenador ya en uso en equipos
activos, o que el de competidores y el de autenticacion sepan la
asignacion actual. Eso es trabajo de dominio y datos, no de
presentacion, y no cabe en un cierre ya empujado.

Precondicion de presentacion, una vez fijadas las reglas y expuesta la
consulta, los dos modales filtran la lista que renderizan por los
identificadores ocupados, con el estado vacio del catalogo cuando no
queda nadie, no un empty state improvisado.

## Reglas de dominio de las asignaciones de equipo, cerradas

Entrenador por equipo. Cerrado con evidencia del esquema vivo: la
relacion del entrenador es individual a la coleccion de usuarios, o
sea un entrenador dirige un solo equipo. Filtrar los identificadores
de entrenador ya ocupados es correcto y no esconde entrenadores
validos.

Competidor por equipo. Cerrado por declaracion del autor: un
competidor pertenece a un solo equipo activo. Filtrar los ocupados es
correcto.

## Deuda ampliada: coherencia de modalidad del roster, no solo filtrar

ocupados. Destapada por el autor al revisar el filtrado. El problema
real no es quitar a quienes ya estan en un equipo, es que el roster
debe cuadrar con la modalidad del evento. Las modalidades admiten
individuales masculinos, individuales femeninos, duo mixto, trio y
quinteto, y cada una exige un numero y un reparto de sexos concreto:
un duo mixto pide dos competidores de sexos distintos, un quinteto
pide cinco. Si el selector solo filtrara ocupados, un usuario podria
armar un duo mixto con una sola persona o con dos del mismo sexo, y
los jueces verian un roster incoherente con la categoria que califican.

Hueco de dominio que lo bloquea. La entidad de equipo guarda una lista
plana de identificadores de competidor sin categoria ni modalidad, asi
que hoy no hay donde expresar la regla. Precondicion antes de tocar el
selector: decidir donde vive la modalidad, si la impone el evento, la
declara el equipo o la hereda de los competidores, y como se valida el
cupo y el reparto de sexos del roster contra esa modalidad. Eso es
trabajo de dominio, datos y presentacion a la vez, toca evento,
competidor y equipo, y no cabe en el cierre de equipos. Se registra
como frente propio de reglas de roster, no como linea suelta del
filtrado.

## Deuda de producto: frontend funcional de juez y visitante en panales

Revelada por el autor. Las pantallas de juez, que califican en vivo,
y de visitante, que ven resultados, son el frontend funcional real de
la app y estan tocadas muy superficialmente, no construidas. Esto
reencuadra el frente de calificacion: no es deuda de forma de una
feature existente, es funcionalidad no construida, y la vista de
visitante ni siquiera tiene frente abierto. Precondicion: auditar
calificacion y la vista de visitante como construccion, no como
limpieza, con el mismo orden de capas y el gate de pruebas.

Consecuencia para el reordenamiento de frentes de produccion. El autor
plantea posponerlo hasta cerrar la fase inicial, y se acepta, porque
subir permiso de red de Android, sincronizacion sin conexion y
seguridad por rol a la cima no tiene sentido si no hay juez que
consuma el permiso ni visitante que vea el resultado protegido. La
fase inicial incluye construir calificacion y la vista de visitante de
verdad, no solo sanear las features de gestion. El reordenamiento se
plantea cuando esas pantallas existan.

## Deuda de docs: README publico desalineado con el estado real

Destapada al revisar los documentos de referencia. El README del
repositorio, que es la pagina publica de GitHub, repite las mentiras
del informe viejo: declara administracion en revision y equipos
pendientes cuando ambos ya no lo estan, e impone anotaciones de
Riverpod y dobles con mocktail que el codigo contradice por decision
registrada en el informe unificado. Un README publico que miente es
peor que un doc interno que miente, porque lo lee cualquier interesado
de produccion. Precondicion: alinearlo con el informe unificado dentro
de la reclasificacion independiente del informe a produccion, que el
autor ya decidio como commit propio. No se toca el README aqui porque
es documentacion de producto con naturaleza propia y la reclasificacion
la aborda en bloque.
