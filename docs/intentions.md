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

## Casos borde del frente de disponibilidad de asignaciones

Registrados antes de implementarlo. Uno, al editar un equipo hay que
eximir su propio roster de la consulta de ocupados, o el selector
esconderia al entrenador y a los competidores que ese equipo ya tiene
y el usuario no podria conservar su seleccion. Se resuelve con un
parametro de exclusion por identificador de equipo en la consulta, no
filtrando en el modal. Dos, los rosters de equipos inactivos deben
quedar libres, asi que la consulta de ocupados filtra por estado
activo; si no, un borrado logico secuestraria competidores para
siempre. Tres, la copia del estado vacio debe distinguir entre no hay
registrados y todos estan asignados, porque el texto actual dice que
se registre un entrenador primero y eso seria mentira cuando la causa
real es la ocupacion. Ese cambio de copia toca la deuda de
centralizacion de textos ya registrada.

## Correccion de vocabulario de dominio

El modulo se llama puntuacion, no calificacion. Segun la FIG los
jueces puntuan a los competidores, y ese es el termino del negocio.
Los identificadores en ingles del codigo ya son correctos. La copia
de interfaz tiene al menos una cadena con el termino equivocado, la
descripcion del rol de juez principal, que dice que valida
calificaciones. Se corrige en el frente de lenguaje junto con el
resto de la copia, y los bloques de deuda que hablaban de
calificacion se leen como puntuacion.

## Orden de frentes por direccion de dependencia

Decision del autor, aceptada. Puntuacion se construye al final, no
 despues de equipos, porque consume identidad de juez, roster,
categoria y evento; construir al consumidor antes que sus
dependencias obliga a reescribir su capa de consumo cada vez que algo
de abajo se mueve. Primero se cierran los frentes que pueden cambiar
contratos de otros modulos, con shared antes de eventos para que
eventos adopte el catalogo final una sola vez. El catalogo de shared
se deriva de un inventario de usos crudos en todas las features, no
de auditar cada feature a fondo. La vista de visitante consume la
salida de puntuacion y va despues de el.

## Cierre de equipos en 0.2.0 e inventario global medido

Equipos cerrada segun checklist de codigo. Reconciliacion de
inventario: la cabecera con ruta vieja del repositorio ya estaba
corregida como efecto del reescrito del endurecimiento, asi que solo
la del contrato se corrigio en el pase de forma. El bloque que hablaba
de dos cabeceras de equipos queda resuelto.

Inventario global en hallazgos del analizador al cierre: administracion
y equipos en cero. Autenticacion 44 de informacion. Competidores 86 de
informacion. Core 141 de informacion y una advertencia. Eventos 11
errores, 209 de informacion y dos advertencias. Puntuacion 51 errores,
182 de informacion y una advertencia. Shared 5 errores y 261 de
informacion. Total 67 errores, cuatro advertencias y 923 de
informacion.

Lectura: los errores de eventos estan solo en presentacion y son las
mismas clases corregidas en equipos. Los de puntuacion se concentran en
tres modelos de datos con lecturas implicitas de dinamico, que bajo
conversiones estrictas son error de analisis y ademas riesgo de fallo
en ejecucion si el backend entrega otro tipo. Los de shared estan en el
catalogo que consumen todas las features, asi que su arreglo tiene el
mayor apalancamiento por error corregido.
## Estado de puntuacion: en construccion, no codigo muerto

El modulo tiene codigo real: tres modelos de datos, repositorio,
notifier, vista principal y dos widgets en shared. El inventario mide
51 errores, 182 de informacion y una advertencia. No es un modulo
vacio, es un modulo a medio construir de la epoca sin control de
versiones. Por eso la regla de eliminar codigo muerto NO se le aplica:
su codigo se reaudita y se reescribe en su frente, no se borra.

Decision de orden confirmada por el autor y aceptada: sus errores no
se arreglan ahora. Razones. Uno, no hay despliegue, asi que no hay
riesgo vivo de caida. Dos, el modulo se va a construir de verdad, asi
que sanear sus modelos ahora es retrabajo probable sobre un contrato
que puede cambiar. Tres, el saneamiento de lecturas es mecanico y se
hace mejor con el esquema real delante, igual que se hizo con equipos
contra el esquema vivo y no contra las migraciones viejas.

## Bloqueo de lanzamiento: rutas hacia pantalla sin construir

El router importa la vista principal de puntuacion y la construye en
tres constructores de ruta. Eso la hace alcanzable para el compilador
y direccionable por URL en web, aunque ningun menu lleve a ella.
Alcanzabilidad de compilacion, de navegacion y de direccion directa
son tres cosas distintas y las tres son verdad a la vez.

Precondicion de lanzamiento: antes de cualquier despliegue, o la
pantalla esta construida y probada, o las rutas se retiran o se
protegen por rol. No se despliega una ruta que renderiza una pantalla
a medio hacer cuyo modelo de datos falla con datos reales.

Verificacion pendiente que puede cambiar la prioridad: si el
redireccionamiento del router manda al rol de juez a una ruta de
puntuacion al iniciar sesion, entonces no hace falta escribir la URL,
es el camino normal, y un juez que entre hoy cae en la pantalla a
medias. Hasta leer el router no se afirma ni se descarta.
## Hallazgos del enrutador, medidos sobre el archivo real

Uno, defecto de inicio de sesion de tres roles de juez. El mapa de
ruta por rol manda al juez de arte a /judge/artistry, al de dificultad
a /judge/difficulty y al de ejecucion a /judge/execution, y esas tres
rutas construyen la vista principal de puntuacion. El redireccionamiento
posterior al login devuelve esa ruta cuando el usuario viene del login,
asi que no hace falta escribir la URL: es el camino garantizado. La
premisa de que la pantalla era practicamente inalcanzable queda
falsada con evidencia.

Dos, asimetria que confirma el diagnostico. El juez principal ya tiene
una vista marcadora propia, mientras los otros tres jueces reciben la
vista real a medio construir. Alguien sabia que puntuacion no estaba
lista y protegio a uno de cuatro.

Tres, mentira de estado al espectador. El mapa de rol manda al
espectador a /pending-approval, que es la pantalla de cuenta en espera
de aprobacion. Un espectador activo y aprobado ve que su cuenta esta
pendiente, lo cual es falso. No existe vista de visitante ni de
resultados, asi que el rol no tiene destino propio.

Cuatro, marcadores crudos en el propio enrutador. Las rutas de
entrenador y organizador construyen un texto centrado sin Scaffold ni
catalogo, y el constructor de error usa boton crudo y color cableado.

Cinco, recreacion del enrutador. El proveedor observa el estado de
autenticacion y construye un enrutador nuevo en cada cambio, lo que
reinicia la pila de navegacion. El patron correcto es un escucha de
refresco, no recrear la instancia.

Seis, diagnostico de rutas activo siempre. La bandera de registro de
diagnostico esta en verdadero sin condicion de compilacion, asi que
tambien registra en lanzamiento.

Prioridad: el hallazgo uno es defecto de la compilacion actual, no
bloqueo de lanzamiento, porque se alcanza por uso normal. Se corrige
enrutando a los tres jueces a un marcador, igual que ya esta el
principal, y se mantienen diferidos los 51 errores del modulo. Los
hallazgos tres a seis se registran como deuda de core y de producto.
## Hallazgo uno del enrutador: RESUELTO

Los cuatro roles de juez aterrizan ahora en el marcador generalizado,
con el titulo tomado de la etiqueta del catalogo de identidad. Ningun
juez alcanza la vista principal de puntuacion por inicio de sesion.
Los 51 errores del modulo siguen diferidos y el conteo del analizador
no baja, porque el analisis cubre archivos aunque no sean alcanzables.

Deuda menor derivada: el nombre de la clase del marcador conserva la
palabra principal aunque sirve a los cuatro roles. No se renombra
porque la vista esta destinada a ser absorbida por el marcador de
modulo del catalogo al auditar shared, y ese bloque ya lo registra.
## Frente de producto: gestion de usuarios como pantalla propia

Decision del autor, aceptada con evidencia visual. La gestion de roles
y usuarios se monta hoy desplegada dentro de la seccion de
configuracion. En telefono eso entierra los ajustes reales bajo N
tarjetas de usuario, y cada tarjeta crece al mostrar el estado de la
cuenta. El patron correcto ya existe en la propia app para colecciones:
pantalla con encabezado, chips de filtro, accion principal y lista. La
gestion de usuarios es una coleccion, no un ajuste.

Alcance acordado. Uno, seccion propia de administracion con entrada en
el menu lateral, al mismo nivel que equipos y eventos, no colgada de
configuracion. Dos, la seccion de configuracion queda solo con sus filas
de preferencias y el cierre de sesion, como lista de destinos que se
abren al pulsar. Tres, filtros por estado de cuenta y por rol, ademas de
la barra de busqueda actual, que se conserva para busquedas especificas.
Cuatro, el filtro por estado es el que hace descubrible la aprobacion,
que hoy exige recorrer la lista entera.

Decision de capa que abarata el frente. Los filtros se aplican en
cliente sobre la lista ya cargada, porque el repositorio de usuarios
usa lista completa y trae todos los registros. Por tanto el frente es
solo de presentacion mas el catalogo de secciones, sin tocar contrato
de repositorio ni backend. Si el volumen de usuarios crece hasta hacer
inviable traerlos todos, entonces se pasa el filtrado al servidor y eso
ya es deuda de escalabilidad registrada aparte.

Precondiciones y consecuencias verificadas. El catalogo de secciones de
administracion gana un valor, lo que rompe a proposito la prueba que
afirma que tiene seis; hay que actualizar el conteo a siete y anadir la
etiqueta nueva al mapa de etiquetas. El enrutador gana una subruta, el
menu lateral gana una entrada y el conmutador de seccion del panel gana
un caso. La seccion de configuracion pierde el montaje de la gestion y
el divisor que la separaba.

Orden acordado. Primero el cableado de aprobacion, que son dos archivos
y desbloquea la entrada de todo usuario que no sea administrador, y
cuyo codigo vive en la tarjeta y el notifier, asi que sobrevive intacto
al traslado. Despues este frente. No se mezclan en un commit porque uno
es defecto funcional y el otro es reestructuracion de arquitectura de
informacion.

Nota de naming. El widget actual se llama gestion de roles, pero pasa a
gestionar usuarios, roles y estados. Su nombre queda corto y se evalua
renombrarlo en este frente, no antes.
## Errata de historia: registro mezclado en un commit de arreglo

El commit 8cb9270 se publico con tres archivos cuando su mensaje declara
dos. Ademas del notificador y la vista de cuenta pendiente, arrastro este
documento con el registro del frente de gestion de usuarios como pantalla
propia, que estaba preparado en el indice desde el turno anterior y no
tenia commit propio.

Causa raiz. El lead entrego un bloque con preparacion del documento sin
su commit en el mismo bloque, dejando residuo preparado en el indice. Y la
guardia del commit siguiente describia el residuo como sin preparar,
cuando el riesgo real era que ya estuviera preparado. Es la segunda vez
del mismo patron: la primera fue el lote de documentaciones de equipos,
que se aplico sin commit y luego inflo la guardia de cinco a diez rutas.

Decision. No se reescribe la historia. El commit ya esta publicado y la
regla de no reescribir commits publicados es de seguridad, mas fuerte que
la de atomicidad, que es de higiene. El codigo del commit es correcto y
esta verificado, asi que revertirlo para rehacerlo en dos generaria ruido
sobre codigo bueno. Se acepta la impureza y se anota aqui.

Contramedida mecanica adoptada. Los commits pasan a limitarse por rutas
en la propia orden de commit, con separador de rutas y la lista explicita
despues. Esa forma commitea solo el contenido de las rutas nombradas e
ignora lo preparado en el indice para cualquier otra ruta, asi que el
residuo ya no puede colarse. La guardia de estado se mantiene como
verificacion, no como unica defensa. Salvedad: esa forma toma el contenido
del arbol de trabajo de las rutas nombradas, asi que no se usa con
preparacion parcial de un mismo archivo.

Segunda contramedida de proceso. El lead no entrega preparacion de
archivos sin su commit en el mismo bloque. Si un documento se prepara para
un commit futuro, se entrega el bloque completo o no se prepara.

## Nota de color semantico del estado de cuenta

En la tarjeta de usuario el estado activo se pinta con el color primario
del esquema y el pendiente con el terciario, que en este tema resulta
verdoso. El resultado es que pendiente parece exito y activo parece
neutro, semantica invertida por accidente del esquema. Se corrige en el
frente de tema con roles semanticos de exito y advertencia, no con
colores cableados.
## Regla operativa de recarga tras cambiar codigo

Tres defectos falsos se reportaron por compilar viejo: el boton de
verificar estado, las rutas de jurado y el listado de usuarios. El costo
fueron turnos de diagnostico sobre codigo correcto. La regla queda
escrita para no repetirlo.

Recarga en caliente. Inyecta codigo nuevo en la maquina virtual y
conserva el estado. No vuelve a ejecutar el punto de entrada ni los
inicializadores de nivel superior, y no recrea instancias ya cacheadas.
Sirve para cambios dentro del cuerpo de construccion de un widget o de
un metodo que se vuelve a invocar. No sirve para estructura.

Reinicio en caliente. Reinicia el aislamiento de Dart, vuelve a ejecutar
el punto de entrada y reconstruye todo el estado desde cero. Pierde el
estado, lo cual es deseable cuando el estado viejo es el problema. No
recompila codigo nativo ni relee configuracion de plataforma.

Parada completa y relanzamiento. Recompila Dart y nativo, relee el
manifiesto, el registro de plugins, los recursos declarados y los valores
de definicion de compilacion. Es el unico que sirve cuando cambia el
manifiesto de dependencias, un permiso de plataforma o un valor de
compilacion.

Trampas verificadas de este proyecto. El proveedor del enrutador cachea
una instancia con su lista de rutas, asi que cambiar rutas exige
reinicio en caliente como minimo. El notificador de autenticacion guarda
una marca de sesion restaurada que sobrevive a la recarga, asi que la
restauracion no se vuelve a ejecutar. El notificador de gestion de
usuarios dispara la carga una sola vez al construirse, asi que una
recarga no refresca la lista y parece que faltan registros.

Regla adoptada. Cambio de rutas, de proveedores, de clases selladas o de
enumeraciones exige reinicio en caliente antes de juzgar el resultado.
Cambio de manifiesto, de recursos, de definiciones de compilacion o de
codigo nativo exige parada completa. Y ninguna prueba viva se reporta
como fallo sin declarar antes que modo de recarga se uso.
## Regla de generacion: no correr el generador sin necesidad

Evidencia: las ultimas corridas del generador en cada puerta de calidad
reportaron cero salidas escritas, o sea no habia nada que regenerar. Se
pagaron entre cuarenta y cien segundos por corrida mas un demonio de
construccion residente que retiene memoria, en un equipo de ocho gigas.

Regla. El generador solo se corre cuando el commit toca fuentes con
anotaciones de generacion, clases con partes generadas, o el manifiesto.
Commits de documentacion, de presentacion sin anotaciones, de logica pura
o de pruebas no lo necesitan. La puerta de calidad de esos commits es
analisis mas pruebas, sin generador.

Contexto. El demonio de Flutter del editor se cayo durante este frente.
Es tooling, no la app ni el backend ni el repositorio. La hipotesis
principal es presion de memoria por procesos de Dart apilados, y se
confirma midiendo procesos residentes y memoria libre, no afirmando.
## Cierre del flujo de aprobacion de cuentas

Cerrado con evidencia en las dos ramas. Rama de exito: aprobar desde el
panel deja la tarjeta en activo y retira el boton; el usuario pendiente
pulsa verificar estado, el mensaje confirma la aprobacion y el
enrutador lo lleva al marcador de su jurado. Rama de fallo: con el
backend detenido a proposito por el autor, aprobar muestra el aviso de
fallo en lugar de silencio.

Con esto ningun usuario que no sea administrador queda encerrado por
falta de aprobacion, que era el defecto mas bloqueante del producto.

Queda abierto y registrado, no cerrado por este frente. El destino del
espectador en el enrutador, que lo manda a la pantalla de espera aunque
su cuenta este aprobada. La etiqueta de estado en ingles que ve el
usuario en la pantalla de espera. La copia que promete notificaciones
que no existen. El contraste y la posicion del aviso, que se pierde
sobre la barra de navegacion. La accion de refrescar el listado de
usuarios, que hoy no existe y hace que un cambio externo no se vea. Los
siete avisos de forma de la seccion de gestion, que absorbe el frente de
rediseno.

## Presion de memoria medida en el equipo de desarrollo

Medicion: memoria visible total 7.2 gigas, libre 0.7 gigas, cerca del
noventa por ciento en uso. La caida del demonio de Flutter del editor es
coherente con ese margen. El demonio no reincidio y el servidor de
analisis y el demonio de tooling quedaron en verde.

Matiz honesto sobre la hipotesis. Se esperaban los procesos de Dart como
consumidores principales por apilamiento de puertas de calidad, pero su
conjunto residente medido fue de decenas de megas y todos arrancaron en
el mismo minuto, o sea son la flota del editor y no acumulacion. Eso no
los exonera: Windows recorta el conjunto residente de los procesos
inactivos y los pagina, asi que residente no mide comprometido. La
medicion siguiente mira bytes privados y los mayores consumidores del
sistema, para no nombrar culpable sin dato.

Regla operativa derivada. No apilar la aplicacion en ejecucion con la
puerta de calidad completa, porque cada una anade maquinas virtuales
sobre un sistema ya al noventa por ciento. La omision del generador
cuando no hay fuentes anotadas baja ese pico. Y cerrar las pestanas del
navegador que no se usan, en especial el panel del backend cuando no se
esta consultando.
## Cierre de la hipotesis de memoria con bytes privados medidos

Medicion de compromiso. Los cinco procesos de Dart suman unos
seiscientos megas de bytes privados, con uno solo en quinientos
veintiseis, que es el servidor de analisis. Su residente estaba recortado
a setenta y cuatro megas, lo que confirma que Windows pagina los procesos
inactivos y que el residente no sirve para medir consumo.

Correccion de la prediccion del lead. Se esperaban gigas en Dart por
apilamiento de puertas de calidad. No fue asi: seiscientos megas es
consumo real pero no dominante, y los cinco procesos arrancaron juntos,
o sea son la flota del editor y no acumulacion.

Hallazgo decisivo. El mayor consumidor residente del sistema no es una
aplicacion: es la compresion de memoria de Windows, con mil setecientos
treinta y dos megas. Ese almacen es sintoma de presion severa, no causa:
Windows comprime paginas en RAM en lugar de mandarlas todas al disco, y
ahi caben varios gigas de datos comprimidos.

Reparto real. El editor aporta tres procesos con unos seiscientos megas
residentes entre ellos. El navegador aporta cuatro procesos en la lista
de los doce mayores, con unos quinientos megas. Mas el antivirus, el
explorador y el sistema. No hay un unico culpable: la suma del editor, el
navegador, Dart y Windows sobre siete gigas y dos es la causa.

Acciones de alivio, de mayor a menor efecto. Uno, ejecutar la app en un
dispositivo Android fisico, que la saca del equipo por completo y libera
la flota del navegador, ademas de dar experiencia movil real.
Precondicion barata de verificar: el manifiesto de depuracion de la
plantilla de Flutter ya suele declarar el permiso de red, asi que la
deuda registrada podria estar exagerada en su parte de dispositivo
fisico; falta comprobar el texto claro para HTTP en red local. Dos,
cerrar pestanas del navegador que no se consultan, en especial el panel
del backend. Tres, no apilar app en ejecucion con puerta de calidad
completa, ya registrado.

Alternativa con contrapartida. Ejecutar en escritorio Windows evita el
navegador, pero se pierde la emulacion de dispositivo y la verificacion
de ancho movil, que es justo lo que se usa para el pase visual. No se
adopta sin decidir esa contrapartida.
## Correccion de la deuda de Android con el manifiesto leido

Medicion. El manifiesto de depuracion y el de perfil SI declaran el
permiso de red, cada uno en su linea seis, como trae la plantilla de
Flutter. El manifiesto principal no lo declara. Y no hay declaracion de
texto claro en ninguno de los tres.

Correccion. La deuda registrada decia que la falta de permiso de red
bloquea release y dispositivo fisico. Es mitad falsa. En depuracion el
permiso existe, asi que un telefono fisico ya puede abrir sockets. Lo
que falta para desarrollo en dispositivo es el texto claro, porque
Android bloquea HTTP sin cifrar desde la version nueve y el backend de
desarrollo sirve HTTP en red local.

Alcance real que queda. Uno, desarrollo en telefono fisico: anadir texto
claro solo al manifiesto de depuracion, con lo que release sigue cerrado
por defecto y no se abre superficie de produccion. Dos, lanzamiento:
declarar el permiso de red en el manifiesto principal, porque sin el la
compilacion de release no tiene red en absoluto. Son dos cambios de una
linea cada uno, en archivos distintos y con naturalezas distintas, asi
que no se mezclan.

Nota de seguridad. El texto claro no se declara en el manifiesto
principal ni de forma global. Abrir HTTP sin cifrar en produccion seria
cambio de postura de seguridad, no ajuste de desarrollo, y exigia antes
decidir si el backend de produccion sirve HTTPS.
## Correccion mayor: la guia de catalogo describe widgets inexistentes

Inventario real medido por arbol. Catalogo Aero: doce archivos, alerta
de dialogo, avatar, fondo, insignia, boton, tarjeta, formulario, entrada
de texto, selector, esqueleto de carga, interruptor y area de texto.
Administracion: cuatro, accion rapida, tarjeta de metricas, tarjeta de
asignacion de rol y tarjeta de seccion. Puntuacion: dos, tarjeta y hoja
de formulario. Total dieciocho.

La guia de uso describe unos cincuenta y tres. Es un catalogo
aspiracional heredado de la estructura anterior a la migracion, no un
inventario del arbol actual. Prueba adicional: el grupo de toggles que
el autor recupero importa una ruta relativa de la estructura plana, usa
la fuente directa en vez de los roles del tema, no tiene documentacion y
cablea colores, asi que no es portable tal cual.

Correccion del lead. Varias deudas registradas por el lead apuntan a
widgets como si existieran: indicador de progreso, aviso temporal, grupo
de radios, separador y grupo de toggles. Ninguno existe. Esas deudas se
releen como crear la pieza, no como adoptarla. La causa es citar la guia
sin contrastar el arbol, el mismo vicio de suponer en vez de leer.

Catalogo que si hace falta crear, seis, con uso crudo probado. Estado
vacio, para listas sin datos y busquedas sin resultado. Barra de filtros
de seleccion unica, para usuarios y eventos. Aviso temporal con su tema,
por el defecto de contraste probado. Marcador de modulo, para los
destinos crudos de entrenador y organizador y el marcador de jurado.
Indicador de progreso, para los indicadores circulares crudos. Hoja
modal, porque el encabezado con degradado y el boton de cierre estan
duplicados en tres hojas.

Catalogo que ya existe y falta adoptar, cuatro. Insignia para los chips
de rol y estado hechos a mano. Dialogo de alerta para el borrado de
equipos. Avatar para los avatares crudos. Tarjeta para los contenedores
crudos.

Diferidos hasta que su superficie exista, tres. Tabla y paginacion para
resultados de visitante. Deslizador para captura de puntuacion.

Rechazados para esta app, unos treinta. Barra de menus, migas de pan,
menu contextual, tarjeta al pasar el raton, popover, redimensionable,
carrusel, area de scroll con estilo, comando con atajo y similares, por
ser de escritorio o de nicho sin superficie actual. Crearlos seria
sobreingenieria.

Accion pendiente. Reescribir la guia de uso para que refleje el
inventario real y la lista de lo que falta, con su justificacion. Mientras
no se reescriba, la guia no es fuente de verdad del catalogo y toda
decision de widget se contrasta con el arbol.
## Salvedad de la forma de commit limitada por rutas

La contramedida adoptada tras la errata del commit mezclado era
commitear con separador de rutas y la lista explicita, para que el
residuo del indice no pudiera colarse. Esa forma tiene un limite que el
lead no verifico antes de adoptarla: solo acepta rutas que git ya
conoce. Un archivo nuevo, sin rastrear, produce el error de que la ruta
no coincide con ningun archivo conocido, y el commit no se crea.

Prueba. Las dos piezas nuevas de catalogo y sus dos pruebas quedaron sin
commitear con ese error, mientras el analisis y las pruebas ya estaban en
verde. El arbol quedo con cuatro archivos sin rastrear y nada roto.

Regla refinada. Para archivos nuevos hay que prepararlos con add, lo que
los hace conocidos, y despues commitear con la forma limitada por rutas.
Las dos protecciones se componen: el add hace conocida la ruta nueva y el
limite por rutas sigue ignorando cualquier otro residuo preparado. Para
archivos ya rastreados el add es innecesario y la forma limitada basta.

Correccion de metodo del lead. Adoptar una contramedida sin probar su
caso de archivo nuevo es el mismo vicio de afirmar sin verificar que esta
bitacora viene registrando. Toda contramedida se prueba en los dos casos,
archivo modificado y archivo nuevo, antes de declararla estandar.
## Cierre de codigo del frente de gestion de usuarios y hallazgos del catalogo

Publicado con diez rutas, mas el refactor y la documentacion de la
entidad de usuario, la adopcion de los predicados de estado en la
tarjeta, y el arreglo de render del catalogo. Verificado despues de cada
commit: perimetro en vacio, sesenta y siete errores de linea base y
sesenta y cinco pruebas verdes.

Pase visual del frente PENDIENTE. Toca superficie, asi que el checklist
impide declararlo cerrado del todo sin el pase en claro y oscuro.

Correcciones de metodo del lead en este frente, tres. Uno, el filtro y la
etiqueta de estado se disenaron con dos estados tomados de una captura
del backend, cuando el contrato de dominio declara tres; la muestra no es
el contrato. Dos, el grep de los predicados uso coincidencia de subcadena
y caso una variable local del enrutador, lo que habria hecho creer que
habia consumidores. Tres, se cito la guia de catalogo como regla cuando
describe piezas que no existen en el arbol.

Decision sobre los predicados de estado. Se adoptan en la tarjeta en
lugar de eliminarse, porque expresan la semantica del dominio y retiran
de presentacion los literales duplicados. Deuda de raiz: el estado es una
cadena suelta en entidad, modelo, enrutador, filtro y tarjeta; el arreglo
es un enumerado con conversion desde almacenamiento, igual que el
catalogo de identidad, y toca unas siete rutas del frente de
autenticacion.

Enmienda del checklist por evidencia. El analizador no detecta desbordes
de render: dos Row del catalogo desbordaban y sus avisos eran invisibles
para el. Se adopta que toda pieza de catalogo nueva o tocada viaje con
prueba de render a ancho estrecho, ademas de su prueba de logica. La
desviacion de diferir pruebas de widget queda costeada con este episodio.

Causa real de la inconsistencia de botones, pendiente de decision. El
variante primario usa los tokens monocromos heredados, negro sobre claro
y blanco sobre oscuro, mientras la marca es el degradado fucsia. Solo los
sitios que pasan degradado explicito salen con marca, y de ahi la
apariencia aleatoria. Recomendacion del lead: que el primario use el
degradado de la casa por defecto, con el parametro explicito pudiendo
sobrescribirlo, lo que unifica todos los primarios sin tocar sitios de
llamada. Requiere aprobacion del autor y pase visual, y va en commit
aparte.

Maquinaria muerta del envoltorio de campo, probada. La notificacion
personalizada tiene tres ocurrencias, todas en su propio archivo, y cero
disparadores. La clave global de tipo estado de campo esta colgada de un
subarbol con clave, que no tiene estado, asi que su estado actual es nulo
siempre. Conclusión: la deteccion interna de errores y el aviso de foco
estan inertes, y los parametros de error y de foco son una API que
miente. El impacto visible es limitado porque el campo de texto muestra
sus propios errores. Decision preferida: eliminar la maquinaria en lugar
de repararla, porque repararla duplica lo que el campo ya hace, y de paso
retira el aviso de tipo crudo. Precondicion: grafo de consumidores, para
conservar los parametros que alguien si use.

Deuda abierta del frente de usuarios. Uno, refresco automatico al entrar
a la seccion, porque el proveedor sobrevive la navegacion. Frente de
disposicion. Dos, naming del widget y del proveedor, que dicen roles pero
gestionan usuarios, roles y estados. Tres, crudos conservados donde ya
existian, encabezado, busqueda y caja de error. Frente de shared.

Nota sobre documentos de referencia. Las copias subidas del informe y del
README son instantaneas previas al cierre de equipos, declaran
administracion en revision y equipos pendientes, e imponen anotaciones y
dobles con mocktail que el codigo contradice por decision escrita. La
fuente de verdad es el repo, no las copias. Su alineacion sigue siendo el
gesto independiente ya acordado.
## Regla de bloques autocontenidos en la terminal

Fallo de proceso del lead. Un bloque de commit uso la variable de
codificacion declarada en un bloque anterior, sin declararla de nuevo. En
una sesion nueva la variable era nula y la escritura del archivo de
mensaje fallo con error de argumento nulo, asi que el commit no se creo.

Regla adoptada. Todo bloque que escriba un archivo declara su propia
codificacion, su propia ruta y su propio mensaje. Ningun bloque depende
de variables de un bloque anterior, porque el autor puede ejecutarlos en
sesiones distintas o despues de reiniciar la terminal. Es la misma
familia que la regla de no entregar preparacion sin commit: cada bloque
se basta a si mismo.

## Cierre del arreglo del dialogo de alerta

Verificado en ambos modos con capturas. En oscuro el fondo toma la
superficie del esquema y el titulo, el contenido y Cancelar se leen. En
claro igual. Los dos sintomas, titulo invisible siempre y Cancelar
invisible en oscuro, desaparecieron con un solo cambio de roles
ambientales.

Linea base medida del archivo, nueve avisos previos. Cinco referencias de
comentario a piezas que no existen en el arbol, tres lineas largas y una
documentacion faltante del constructor. No se anadio ninguno.

Hallazgo derivado. Las cinco referencias rotas apuntan a dialogo, hoja,
aviso temporal, banner de alerta y menu contextual, todos descritos en la
guia de catalogo pero inexistentes. La ficcion de la guia se propago a los
comentarios de documentacion del codigo, y el analizador la marca como
referencia no visible. Se corrigen en el pase de documentacion del frente
de shared, junto con la reescritura de la guia.
## Requisito de producto: rechazo de solicitudes y acciones masivas

Requisito del autor, con motivo. Cualquiera que instale la app puede dejar
una solicitud de acceso sin tener relacion con la federacion, asi que el
administrador necesita limpiar la cola de pendientes. Y en un evento
aprobar uno por uno es lento, asi que hacen falta acciones masivas.

Decision de semantica, respondida al autor. Rechazar NO borra el
registro. El borrado fisico romperia la integridad referencial, porque el
entrenador de un equipo es una relacion a la coleccion de usuarios, y
borrarlo dejaria la relacion huerfana y el equipo sin entrenador visible.
Tambien perderia el rastro de que esa persona pidio acceso y se le nego,
y permitiria que se registre otra vez de inmediato. Rechazar pasa el
estado a inactivo, igual que el borrado logico de equipos, asi que la
cola se limpia, el acceso queda bloqueado y la decision es reversible.

Limitacion conocida. Inactivo no distingue solicitud rechazada de
miembro desactivado. Si la federacion necesita ese detalle de auditoria,
hace falta un estado propio de rechazado y un campo de motivo, lo que
toca esquema del backend y se registra como frente propio, no como
parche.

Diseno de las acciones masivas, pendiente de aprobacion. Uno, el alcance
es el conjunto visible tras los filtros activos, nunca toda la
coleccion; aprobar todos sin filtro aprobara tambien a los inactivos y
seria irreversible en segundos. Dos, confirmacion obligatoria con el
numero exacto de cuentas afectadas, destructiva para rechazar. Tres, se
salta a quien ya esta en el estado destino, para no escribir de balde.
Cuatro, ante fallo se continua con el resto y se informa el conteo real
de exitos y fallos, porque parar el lote por un registro malo es peor el
dia del evento. Cinco, sin cambio de contrato: el notificador itera el
metodo unitario que ya existe, y el lote del servidor queda como mejora
de escalabilidad registrada.