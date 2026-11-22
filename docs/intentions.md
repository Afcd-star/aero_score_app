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

## Cierre del frente de gestion de usuarios, con pase visual verificado

Cerrado de punta a punta. Catalogo extendido con estado vacio y barra de
filtros controlada. Seccion propia de usuarios con encabezado, contador,
busqueda, dos filtros, refrescar y estado vacio. Configuracion reducida a
preferencias. Tarjeta con rol, estado y transiciones. Lote de aprobacion y
rechazo, y reactivacion, sobre el filtro que le da sentido.

Pase visual verificado en ambos modos con capturas. Con filtro todos no
hay botones de lote y queda un solo hueco. Con pendientes aparecen aprobar
y rechazar con el mismo conteo. Con inactivos aparece reactivar. Las
acciones de la tarjeta van apiladas con aprobar arriba. El estado
pendiente ya no se parte a mitad de palabra. Y el titulo de la
confirmacion se lee completo con su numero, en dos lineas si hace falta.

Balance del frente. Pruebas de cincuenta a sesenta y nueve. Errores de
sesenta y siete a sesenta y seis, primera bajada de la linea base en toda
la conversacion. Catalogo con dos piezas nuevas y cuatro adoptadas.

## Deuda diferida por decision del autor, dos

Uno, prueba de widget del guard de alcance. Hoy la restriccion del lote al
filtro vive en la vista y solo la cubre el pase visual, que ya la verifico
con captura. El autor decide diferirla porque implementarla ahora seria
pulir de mas. Archivo destino: suite nueva de la seccion en
test/features/auth/presentation/views/sections/, usando el doble que ya
existe en test/features/auth/support/fake_user_repository.dart. Casos
minimos: con filtro todos no existen los botones de lote, con pendientes
existen los dos, con inactivos existe reactivar. Razon para no olvidarla:
el riesgo que cubre es dejar a la federacion entera sin acceso en un clic,
y un guard de riesgo catastrofico no deberia depender solo de ojos.

Dos, anchura del dialogo de confirmacion. El titulo con un digito de
conteo salta a dos lineas. Se podria ensanchar un poco el dialogo para que
los conteos de dos a nueve quepan en una linea. Es pulido visual, no
defecto: el numero se lee completo, que era el requisito de seguridad.
Registrado como pulido, no como bloqueo.

## Correcciones de metodo recurrentes del lead en este frente

Tres, todas del mismo tipo: entregar sin verificar. Uno, tipos explicitos
en variables locales con inicializador, que este proyecto prohibe, y que
el autor o su editor corrigieron varias veces. Regla: var o final sin tipo
cuando hay inicializador, tipo explicito solo sin el. Dos, alcance
semantico incompleto: la regla de conjunto visible protegia contra operar
toda la coleccion pero no contra operar el conjunto equivocado, y el autor
lo detecto preguntando. Regla: el alcance de una accion masiva se valida
contra la semantica de la accion, no solo contra su tamano. Tres, entregas
sin ancla: una linea suelta para borrar, que aparece en varios archivos
donde es legitima. Regla: toda edicion se entrega con bloque unico
alrededor, o con sustitucion acotada al archivo y contada.

## Prioridad del interruptor de tema, pedida por el autor

El autor cambia el tema del sistema operativo a mano en cada pase
visual, porque la app lo sigue y no hay interruptor propio. Eso encarece
cada puerta de calidad con superficie, y el frente de shared necesita
muchas. El registro ya decia que el cableado existe en el punto de
entrada y que faltan persistencia e interfaz.

Recomendacion del lead: hacerlo antes de la guia y del frente de shared,
porque es una herramienta que abarata todo lo que viene despues, no un
pulido. Precondicion de lectura: punto de entrada, archivo de tema y
proveedor de preferencias, para no duplicar el cableado existente.
Destino de la interfaz: la fila de preferencias de configuracion, que
hoy es un marcador y con esto gana su primer destino real.

## Destinos de rol pendientes en el enrutador, ampliados por el autor

El bloque del espectador queda ampliado. No es solo el espectador: los
destinos de entrenador y organizador tambien son texto centrado crudo
sin Scaffold ni catalogo. El autor pide cubrirlos en el mismo frente de
destinos, con una salvedad explicita: el de organizador puede esperar
mucho mas porque su funcionalidad no esta planteada aun.

Alcance del frente cuando se abra. Espectador, con marcador honesto
mientras no exista vista de resultados. Entrenador, con marcador o con
su vista si para entonces existe. Organizador, marcador minimo, y su
funcionalidad queda como frente propio sin fecha. Los tres consumen el
marcador de modulo del catalogo, asi que el frente depende de que esa
pieza exista.

## Cuarta correccion de metodo del lead, mismo vicio que la primera

El defecto de entregar un import que el archivo no nombra se repitio por
cuarta vez, y por tercera en dos turnos. Primero fue fallos en el
notificador de lote, donde el escritor devolvia booleano y el tipo
Failure no intervenia. Ahora fue preferencias en el notificador de tema,
donde el tipo lo aporta la inferencia del proveedor y tampoco interviene.
El analizador lo marca como import sin uso y tiene razon.

Causa raiz, comun a las cuatro: razonar el import desde "este tipo
participa en la operacion" en vez de desde "este archivo escribe el
nombre del tipo". La inferencia resuelve tipos que el archivo nunca
nombra, y ahi el import es basura.

Contramedida reforzada: solo se importa lo que el archivo nombra
explcitamente en una anotacion, un cast, una declaracion o un literal de
tipo. Si el tipo llega por inferencia de un proveedor o de un metodo, no
se importa. Verificacion mecanica antes de entregar: correr el analizador
sobre el perimetro y confirmar que no hay import sin uso nuevo.

Diferencia legitiva que fija la regla: en el punto de entrada el import de
preferencias SI es correcto, porque ahi se escribe el nombre del tipo en
una llamada estatica. La misma dependencia, dos archivos, un import
basura y uno legitimo, y la diferencia es solo si el nombre aparece.

## Quinta correccion de metodo del lead, pase visual como verificacion posterior

Evidencia. Cuatro commits de correccion destapados por pases visuales
ejecutados DESPUES de commitear: el desborde de render del catalogo, el
titulo y el boton invisibles del dialogo, el alcance semantico del lote
que podia desactivar miembros activos, y la fila de tema descolgada. Un
quinto hallazgo, el contraste del estado pendiente en claro, se aplazo a
los tokens semanticos. El autor propone, con razon, que el pase visual sea
un gate previo al commit, como el arquitecto que revisa antes de mezclar a
master.

Causa raiz, misma que las cuatro anteriores: actuar sobre suposicion en
vez de sobre evidencia leida, aplicada a la superficie. El lead entregaba
codigo de superficie asumiendo que se veria bien, sin haberlo visto en
vivo y sin declarar los puntos de riesgo que el pase debia verificar. El
autor descubria el defecto al commitear y generaba un commit de
correccion. Un commit que se corrige varias veces no esta cerrado, esta
mal declarado, y viola la atomicidad real aunque el mensaje lo afirme. El
hot reload existe precisamente para no commitear a ciegas, y el proceso lo
ignoraba.

Contramedida adoptada. El pase visual pasa a gate PREVIO al commit. Flujo:
aplicar codigo, correr puerta estatica de analisis y pruebas, recargar la
app, ejecutar el pase visual en claro y oscuro contra la lista de puntos
de riesgo que el lead declara en la entrega, arreglar cualquier defecto
destapado, repetir la puerta estatica si se toco codigo, y commitear una
sola vez con la superficie ya vista en vivo. Toda entrega de superficie
del lead incluira esa lista; sin ella el pase es un ritual ciego.

Reconciliacion con el hardware del autor, ocho gigas y gpu integrada. La
puerta estatica y el pase visual no se apilan, se alternan: la app se
levanta para el pase y se para para la puerta pesada si el pico de memoria
molesta, o se acepta el pico puntual al final del ciclo. La regla dura no
negocia: no se commitea superficie sin haberla visto en vivo.

Consecuencia para el checklist del informe. La linea del pase visual se
enmienda para que diga gate previo y no verificacion posterior, en el
mismo gesto documental.

## Sexta correccion de metodo del lead, grep de la pieza y no solo de sus tokens

El autor hizo grep de AeroBadge y encontro dos consumidores vivos en
eventos, mientras yo habia declarado que el badge no tenia consumidor
vivo. Hice grep de los tokens de estado (consulta que si hice) pero no de
la pieza. Esa omision es el mismo vicio de suponer, aplicado a la
superficie de una pieza del catalogo.

Causa raiz: razonar el impacto de mutar una pieza desde "que tokens usa"
en vez de desde "quien construye la pieza". Una pieza puede tener
consumidores que la bypassan con parametros custom, y eso cambia por
completo si un cambio a su tabla interna es observable o no.

Contramedida adoptada: antes de mutar una pieza del catalogo, grep de la
pieza (su nombre de clase y su constructor), no solo de sus tokens. Y
leer los consumidores para ver si usan la variante o la sobrescriben con
custom. El gate de superficie aplica solo a lo que el cambio altera en
vivo; si los consumidores bypassan, el gate se reduce a no regresión y la
verificacion real es la prueba numerica.

## Hallazgos del gate del subfrente uno de shared, deuda de subfrentes futuros

EventStatusBadge cablea paleta de Material (blue, green, grey shade100 y
shade700) sin soporte de modo oscuro. En oscuro esos badges salen como
parches claros sobre la tarjeta oscura. Es defecto previo, no introducido
por el subfrente uno. Naturaleza de adopcion y descableado: debe migrar a
variantes semanticas del catalogo o al menos a tokens de la casa con
soporte de brillo. Subfrentes cuatro y cinco.

event_list_view destapa inventario de deuda de shared al leerlo: los
chips de filtro de estado y fecha son crudos (GestureDetector mas
Container con gradientes cableados, incluido un hex 0xFF8B00FF que
deberia ser glowViolet) en vez de AeroFilterBar; hay un
CircularProgressIndicator crudo (deuda de indicador de progreso,
subfrente tres); un Divider crudo; un debugPrint con un TODO y codigo
comentado; un Theme anidado en el selector de rango que cablea primary a
fucsia; y la cabecera del comentario del archivo dice admin cuando la
ruta real es events, residuo de renombrado. Nada de esto se toca en el
subfrente uno. Se registra para los subfrentes que les corresponden.

Confirmacion de naturaleza del subfrente uno: es fundamento sin consumidor
vivo hoy, porque los dos consumidores de eventos bypassan las variantes
con custom. Su verificacion es la prueba de contraste calculado, no el
ojo en eventos. El ojo en eventos solo confirma no regresión.

## Gate del subfrente uno de shared, sin regresión y defecto previo confirmado

Verificado con capturas en claro y oscuro. Los dos consumidores de eventos
sobrescriben texto y fondo con parametros custom, asi que la tabla nueva de
variantes no altera su aspecto, que es el resultado esperado de un commit
fundacional sin consumidor vivo. La foto oscura muestra ademas el defecto
previo registrado, la pil dora de azul claro de Proximo pegada sobre la
tarjeta oscura, mientras la pil dora de categoria se adapta porque usa
alfa sobre el fucsia. El defecto es de EventStatusBadge, que cablea tintas
claras de la paleta de Material sin ajuste por modo, no del subfrente uno.

## Septima correccion de metodo del lead, decidir estilo antes que tokens

El lead arreglo el contraste de las variantes semanticas del badge eligiendo
relleno solido por aritmetica de razon, sin contrastar esa eleccion con el
estilo que ya vive en la app ni con el contexto de render. El unico badge
vivo y los chips hechos a mano son de tinte suave, y el badge se usa a diez
y doce puntos en listas densas, donde el relleno solido anade ruido visual.
El lead fijo solido. La inversion es de orden, no de calculo: el conjunto de
tokens depende del estilo, asi que la decision de estilo debia preceder a
subfrente uno, no seguirlo.

Causa raiz, misma familia que las seis anteriores pero en una dimensión
nueva: verificar solo lo que la herramienta mide. La prueba de contraste
afirma razon mayor o igual a cuatro punto cinco y paso en verde, porque el
relleno solido es legible, pero legible no es lo mismo que adecuado al
contexto y al estilo del sistema. El numero no caza la inadecuación de
estilo.

Contramedida adoptada. Al corregir el estilo visual de una pieza del
catalogo, evaluar contra tres cosas antes de escribir, no solo contra la
razon de contraste. Uno, el uso vivo existente de esa pieza, por grep de la
pieza y lectura de sus consumidores. Dos, el contexto de talla y densidad
donde se renderiza. Tres, el estilo de facto del sistema. Y toda eleccion de
estilo que propague a muchos sitios va al autor antes de codificarse, porque
el gate caza defectos en superficie viva pero no puede cazar una
inconsistencia de estilo en un commit fundacional que aun no tiene
consumidor, ya que no hay nada que ver en vivo. Para commits fundacionales
la verificacion de estilo y contexto es del lead antes de commitear.

## Decision de estilo del badge abierta, pendiente del autor

La adopcion de insignia en chips de rol y estado, y la migracion de
EventStatusBadge a variantes, propagan el estilo de la tabla de variantes a
todas las superficies de estado de la app. Eso es identidad visual del
autor, no suposicion del lead. El lead no escribe codigo de estilo hasta que
el autor elija.

Opcion recomendada, tinte suave por modo. Restilar la tabla a fondo tenue y
texto saturado por modo para success, warning, destructive e info, retirar
los tres tokens de relleno solido de subfrente uno que quedan sin uso,
anadir ocho pares suaves, y actualizar la prueba de contraste para afirmar
cada par en su modo. Primario queda solido de enfasis y secondary queda
suave, que es la mezcla coherente de sistema. La adopcion preserva el look
suave de hoy y solo corrige el defecto de modo oscuro. Costo honesto: el
commit de correccion deja sin efecto la eleccion de tokens de subfrente uno,
por el error de orden del lead, no por defecto del diseño suave.

Opcion alternativa, relleno solido. Subfrente uno queda en pie, se anade un
token de azul solido para info con texto blanco, y la adopcion convierte las
insignias de eventos y los chips de estado en pil dora solida, un cambio de
look visible que el autor aceptaria en el gate. Menos agitacion, pero impone
un estilo no pedido, y si el autor lo rechaza en el gate, la agitacion
vuelve igual.

Sub decision de rol, declarada para no adivinarla. El rol es identidad con
nueve colores propios, no semantica de estado. No se inventan nueve variantes
de badge. Se enruta el color de rol a traves del contenedor de la insignia
con custom, usando el token de rol por modo que ya aporta el ayudante de
tema, de modo que la insignia pone forma, talla y tipografia y el rol pone
color. Variantes de rol explicitas se consideran sobreingenieria salvo que el
autor las pida.

Plan de ejecucion tras la eleccion. Si suave, dos commits, primero correccion
de tabla sin efecto vivo verificada por numero, luego adopcion con gate en
vivo en eventos y tarjeta de usuario en claro y oscuro. Si solido, un token
de info solido y adopcion que impone el cambio de look, con gate en vivo y
aviso de que es cambio de estilo no pedido.

## Gate del movimiento B de shared, pasado con evidencia

Verificado con capturas en claro y oscuro. Proximo sale azul tenue con
texto azul profundo y legible en oscuro, antes un parche claro sobre la
tarjeta oscura. En curso sale verde tenue. Finalizado sale neutro suave.
La pil dora de categoria queda intacta porque no se migro, y eso es el
detector de que la migracion no toco de mas. El diff del commit fue un
solo archivo, event_status_badge, con cinco sustituciones ancladas.

## Aclaracion de la X del miercoles en el selector de fechas

El autor pregunta por que el miercoles sale como X en el calendario. No
es defecto de la app ni del movimiento B. El diff de B fue un solo
archivo y el selector lo construye showDateRangePicker de Material con
locale es_ES. La X es la abreviatura de miercoles que fija CLDR para
espanol, convencion de la localizacion, no codigo nuestro. Cambiarla
seria pelear contra CLDR o escribir un builder propio del picker, lo que
es frente de lenguaje con decision propia, no shared. No se toca aqui.
Se registra para que no se reintroduzca como duda.

## Decision O3 confirmada para el chip de rol, con vencimiento

El autor apraza O1 y pide confirmacion tras leer la tarjeta. Se confirma
O3 por ahora, con vencimiento escrito en el frente de autenticacion, no
indefinido. Motivo de direccion de dependencia: el enumerado de estado
registra que retira los literales sueltos de entidad, modelo, enrutador,
filtro y tarjeta, y el codigo lo confirma con Active, Inactive y Pending
Approval en primaryAction, secondaryAction, statusLabel y statusColor.
El frente de autenticacion va a reescribir esta tarjeta de todos modos,
asi que el pase unificado es inminente y real. Diferir el chip un ciclo
no lo agrava porque ya esta roto hoy, y el pase unificado lo arregla con
el estado invertido y la adopcion del dialogo y los avisos en una sola
apertura, en vez de tres. O1 no se pierde: cuando llegue, la decision de
estilo de nueve roles se toma con el autor viendo la pantalla, no pegada
a un commit de tokens a ciegas, igual que el badge.

## Defecto de contraste del chip de rol, probado por calculo del lead

No es pulido diferible, es defecto de legibilidad preexistente. El chip
cablea texto saturado sobre tinte alfa 0.15 mezclado con la superficie.
Calculo a mano del lead, razon de contraste WCAG para texto pequeno:
admin claro 2.97, admin oscuro 4.09, espectador claro 3.85, todos bajo
el umbral de 4.5. El numero es evidencia humana del defecto, no una
prueba automatizada todavia. La prueba automatizada de roles viaja con
O1 en el pase unificado de autenticacion, donde el ayudante de tema se
extiende a pares de contenedor y texto por rol. Se registra el numero
para que el hallazgo no se evapore y para que O1 lo afirme.

## Deuda de documentacion destapada por el gate de B

El perimetro de event_status_badge trae cuatro avisos de informacion de
documentacion publica faltante, en el constructor y los tres campos. Son
previos, no anadidos por B, porque B no creo campos nuevos. Viajan al
subfrente dos de shared, documentacion publica de piezas existentes.

## Cierre del frente de pertenencia de shared, con evidencia mecanica y visual

El commit 69f2615 vacia shared de las seis piezas que no le pertenecian. Evidencia convergente de dos naturalezas independientes. Mecanica: el reescaneo de similitud no deja ningun renombrado al cien (95, 97, 99, 98, 99, 86), el grep de aceptacion sobre shared devuelve vacio, errores sin variar en sesenta y seis y pruebas en setenta y nueve, y el commit registra trece cambios efectivos con seis renombrados que conservan su porcentaje. Visual: el autor corrigio a mano las dos cabeceras que mentian (scoring_card y scoring_form_sheet) y presento capturas de su linea uno apuntando a features/scoring/presentation/widgets. Las dos senales coinciden, asi que la correccion esta probada por numero y por ojo a la vez, no por una sola fuente.

Valor del gate previo, primera aplicacion exitosa en superficie documental. El gate previo al commit, adoptado tras la quinta correccion, cumplio su funcion exacta: el escaneo de similitud detecto dos cabeceras al cien antes de commitear, o sea dos comentarios mintiendo sobre la ubicacion, que el analizador no ve porque son comentarios. El autor las arreglo a mano y el reescaneo confirmo la bajada por debajo del cien. Sin el gate, esas dos mentiras hubieran quedado horneadas en el arbol, sumando dos cabeceras con ruta vieja a las cuatro ya registradas. Esto valida la contramedida en el caso documental, no solo en el de render.

Octava correccion de metodo, cerrada con dato. El defecto era planificar un frente desde que piezas tocar en vez de desde que piezas pertenecen aqui. El grep de pertenencia detecto el acoplamiento tipado en dos archivos, pero la lectura completa destapo un tercero, scoring_card, que importa limpio y contrabandea semantica de dominio por su API y por hardcodear la maquina de estados con textos de negocio. Contramedida aplicada y verificada: antes de dividir un frente en subfrentes, correr el grep de pertenencia Y leer las piezas ambiguas, porque el grep solo ve acoplamiento tipado y no ve el contrabando semantico. El frente se cerro con las tres salidas por inversion (role_assignment_card a auth, scoring_card y scoring_form_sheet a scoring) y las tres por proposito (admin_quick_action y admin_stats_card a features/admin, section_card renombrada a aero_section_card dentro de shared).

Salvedad de atomicidad, gesto unico por estraddle de un consumidor. role_management_section importa a la vez role_assignment_card (inversion) y aero_section_card (proposito), asi que partir el cierre en dos commits por naturaleza dejaria un commit intermedio con un import apuntando a un archivo inexistente en ese commit, o sea compilacion rota en el bisect. Como nada estaba publicado, la atomicidad real se logra con un solo gesto que declara las dos razones en el mensaje, no con dos gestos que se rompen entre si. Esto no contradice la regla de commit atomico por naturaleza: la naturaleza aqui es un unico movimiento estructural de reubicacion con dos motivaciones, y el estraddle de un consumidor lo fuerza a ser uno.

## Deuda documental destapada por el frente de pertenencia, pendiente de edicion contra texto vivo

El movimiento de seis piezas fuera de shared deja obsoletos tres documentos que aun las listan como parte de shared. No se editan desde memoria ni desde las copias subidas como referencia, porque esas copias no son el texto vivo despues de 69f2615: la copia de widgets_usage subida es la guia aspiracional vieja de unas cincuenta y tres piezas, no la reescrita de veinte archivos; y las copias de README e informe aparecen duplicadas entre la version vieja que miente y la reclasificada, ninguna garantizada como la actual en disco. Se pide el texto vivo de los tres archivos y se edita con anclas contadas contra el, midiendo antes de afirmar numeros.

Puntos obsoletos detectados, para que la edicion sea dirigida y no adivinada.

widgets_usage.md, guia del catalogo que debe inventariar solo lo vivo en shared: el encabezado de veinte archivos baja a quince; el grupo Catalogo Aero de catorce sube a quince al entrar aero_section_card como contenedor puro; los grupos Administracion (cuatro) y Puntuacion (dos) salen por completo porque sus piezas ya no viven en shared; la linea que hablaba de deuda de documentacion de esos grupos se reescribe, pues esa deuda viaja ahora con las piezas a sus features y se registra en el informe y el README, no en la guia del catalogo; y se anade una linea de contrato que diga que este documento solo inventaria lo vivo en shared y que las piezas que salieron por pertenencia se buscan en su feature.

informe_tecnico.md: la linea de Puntuacion que dice dos widgets en shared pasa a dos widgets en su propia carpeta de presentacion; la distribucion de errores del cierre debe volver a medirse por archivo sobre el arbol vivo, porque el movimiento traslada el error de scoring_form_sheet del cubo de shared al cubo de puntuacion, pasando shared de cuatro a tres y puntuacion de cincuenta y uno a cincuenta y dos, con total estable en sesenta y seis; y existe una discrepancia previa entre el inventario global (shared cinco errores) y la metrica del cierre (shared cuatro) que solo una medicion fresca resuelve, asi que no se escribe ningun numero de distribucion sin volver a medirlo por archivo.

README.md: la linea de deuda que dice veintiun avisos en los tres widgets de administracion en shared queda obsoleta porque esos tres ya no estan en shared (dos en features/admin, uno renombrado a aero_section_card en shared), y esos avisos viajan con ellos; la concentracion de errores en puntuacion, eventos y catalogo compartido se ajusta tras la remedicion; y la linea de Puntuacion en estado por modulo incorpora los dos widgets y su error trasladado.

intentions.md misma: el bloque historico del delta al cierre de administracion menciona los tres widgets de administracion en shared como hecho; se anota, no se borra, que tras el frente de pertenencia admin_quick_action y admin_stats_card viven en features/admin y section_card paso a aero_section_card en shared, preservando el rastro historico sin mentir sobre el presente. El bloque de cabeceras con ruta vieja (competitor_repository, event_list_view, team_repository_impl, team_repository) no se ve afectado por pertenencia, porque son archivos distintos que no se movieron; y pertenencia no anadio cabeceras obsoletas netas, porque las dos que introdujo el movimiento fueron detectadas por el gate y corregidas antes de commitear.

Verificacion cosmetica pendiente. El arbol de trabajo debe quedar sin las subcarpetas admin y scoring de shared, vacias tras el movimiento. git no rastrea directorios vacios, asi que la limpieza es del explorador y de futuras listas de archivo; se confirma con el cmdlet Test-Path en falso sobre ambas rutas y con git status en vacio despues del commit, que el pegado anterior no mostro.

## Decima correccion de metodo del lead, confiar en un parser sin verificar que captura todo

Evidencia. El contador estricto con regex devolvio 880 infos a mano mientras el
editor del autor marca 885, con warnings (4) y errores (66) casando. El hueco de
cinco cae todo en info, o sea mi regex perdio cinco lineas de diagnóstico y las
descarto en silencio al no casar con el patron estricto. Es la misma familia que
la novena: usar la salida de un comando de medicion como verdad sin corroborarla
contra una cifra externa conocida (aqui, el 885 del editor) ni contra su propio
total.

Causa raiz. Razonar el conteo desde "mi regex extrae severidad, ruta y posicion"
en vez de desde "el comando emite N lineas de diagnostico y debo capturar las N".
Un parser lossy subcuenta, y un subcuento usado como verdad para afirmar booleans
de docs (cero avisos) puede dar por cero un area que en realidad tiene una de las
lineas perdidas.

Contramedida adoptada. Toda medicion que alimente una afirmacion de docs se
corrobora con un contador no lossy (toda linea que empiece por severidad) contra
una cifra externa conocida (el badge del editor) ANTES de fijar numero alguno.
Y las booleans de "cero avisos" se verifican listando las lineas de esa area con
el contador no lossy, no asumiendo que la ausencia en la tabla estricta significa
cero.

## Hallazgos de la medicion no lossy y del analysis_options leido, deuda de docs y de config

Distribucion de errores medida y fiable (strict y loose coinciden en error y
warning): total 66, shared 3, events 11, scoring 52. Valida el anexo del cierre
del frente de pertenencia (shared 4 a 3, scoring 51 a 52) y corrige con dato
fresco la discrepancia historica del inventario global (shared 5). Los infos por
area quedan pendientes del contador no lossy de esta vuelta.

Colapso de la afirmacion de cero avisos, destapado por la lectura del desglose.
Tras el frente de pertenencia, administracion ya no es cero (16 infos de
admin_quick_action y admin_stats_card movidos hacia dentro de la feature), la
seccion de usuarios y la tarjeta de asignacion tampoco (ahora en auth, 20 infos),
y solo equipos sobrevive en cero entre las areas con codigo. La linea de README e
informe que lista "administracion, equipos, seccion de usuarios y tarjeta de
asignacion" en cero avisos es falsa desde el commit 69f2615 y se corrige con el
desglose no lossy confirmado.

Typo real en analysis_options.yaml, latente. El exclude declara [build/,
/.g.dart, **/.freezed.dart]. El segundo patron, /.g.dart, no excluye nada util:
en glob, la barra inicial ancla a raiz y /.g.dart buscaba un archivo literal
llamado .g.dart en la raiz, no los generados. El patron correcto es
**/*.g.dart. Hoy es inocuo porque no hay .g.dart en disco (gen=0 y el listado de
generados lo confirman o lo desmienten segun esta vuelta), pero en cuanto corra
build_runner los .g.dart se analizaran sin excluir mientras los .freezed.dart si
quedan excluidos por el tercer patron, una asimetria que inflara los conteos de
info y warning sin que nadie lo espere. Correccion de una linea, naturaleza de
config, commit aparte del de docs, y sin cambio de conteo hoy.

Segunda mentira documental hallada leyendo el texto vivo, ajena a pertenencia.
Tanto el informe como el README listan todavia, en su bloque de deuda que degrada
calidad, la linea "guia de uso del catalogo, que describe piezas inexistentes y
cuyas referencias rotas llegaron a comentarios del codigo". Esa ficcion ya estaba
cerrada por los commits e3529f9 (reesitura de la guia al inventario real) y
e746fd0 (retirada de las referencias rotas de los comentarios). La linea sobra y
miente sobre deuda abierta; se elimina en el commit de docs. La regla operativa
del informe que remata "no con la guia de uso, que describe piezas inexistentes"
tambien se reescribe, porque la guia ya no describe inexistentes.

Deuda de documentacion reubicada por pertenencia. La linea de deuda "los tres
widgets de administracion en shared" (21 avisos) se desdobla tras el movimiento:
16 avisos viajan con admin_quick_action y admin_stats_card a features/admin, y 5
quedan en shared como aero_section_card; role_assignment_card llevava sus avisos
a auth. La guia del catalogo ya no inventaria esas piezas, asi que su deuda de
documentacion publica se registra en el informe y el README por feature, no en la
guia. La linea de deuda de catalogo se reescribe a "boton y envoltorio de
formulario" mas la nota de las piezas reubicadas.

## Reconciliacion de conteos cerrada, con causa exacta de las dos mitades

La diferencia entre el editor y el analizador tenia dos causas distintas,
no una. Los cinco que solo aparecian en el editor son entradas de tipo
por hacer que la extension sintetiza desde comentarios, no diagnosticos
del analizador; el CLI nunca las emite, asi que ochocientas ochenta mas
cinco igual a ochocientas ochenta y cinco. Los seis que solo aparecian en
el CLI son errores del formulario de evento que la exportacion del editor
no traia, porque esa exportacion era una instantanea vieja: sus errores
suman sesenta, no sesenta y seis, mientras el contador actual del editor
dice sesenta y seis e iguala al CLI. El editor ya los ve, el archivo
exportado no.

Aritmetica final verificada. Errores sesenta y seis, repartidos en
puntuacion cincuenta y dos, eventos once y catalogo compartido tres. Los
once de eventos son cinco de la vista de lista y seis del formulario.
Advertencias cuatro, todas de estilo de comentario por hacer.
Informaciones ochocientas ochenta del analizador, mas cinco marcadores
que solo el editor surfacea.

Regla de autoridad adoptada. Los numeros de los documentos son los del
analizador del CLI con el alcance del config. Los marcadores de por hacer
se declaran aparte como deuda, no se suman a la informacion del
analizador, porque mezclarlos fue lo que lanzo la persecucion de
fantasmas. El contador del editor corrobora, no subordina.

Numero caduco destapado en esta vuelta. Los tres documentos declaraban
sesenta y nueve pruebas cuando hoy son setenta y nueve: el frente de tema
sumo cuatro y el de contraste cinco mas uno. Se corrige en el mismo gesto
documental. Leccion: al cerrar un frente hay que remedir tambien el
conteo de pruebas, no solo el de errores, porque ambos se mueven.

## Regla de separacion de titulos, con su causa mecanica

El autor corrigio a mano titulos pegados al parrafo anterior. La causa no
era olvido del espacio, era el patron de escritura: la cadena de bloque
terminaba sin salto final, asi que cada anexion nueva pegaba su titulo a
la ultima linea del archivo. El defecto era reproducible y mio.

Contramedida determinista. Toda anexion lee el archivo, recorta el final
con TrimEnd, y escribe el contenido recortado mas dos saltos, mas el
bloque, mas un salto. Asi la separacion queda garantizada sin depender de
como termino el archivo antes. Y todo titulo lleva linea vacia antes y
despues dentro del propio bloque.

## Mapa medido del frente de documentacion de shared

Desglose de informaciones por archivo, medido y verificado contra el
total de shared, que suma ciento noventa y tres. Selector treinta y seis,
area de texto treinta y tres, boton veintiseis, interruptor diecinueve,
entrada de texto diecinueve, insignia dieciocho, envoltorio de formulario
doce, tarjeta siete, esqueleto seis, avatar cinco, tarjeta de seccion
cinco, dialogo de alerta cuatro, fondo tres.

Los tres errores de shared estan en dos archivos: dos en el selector y
uno en el esqueleto. Son los de mayor apalancamiento del arbol porque el
catalogo lo consumen todas las features, y van primero como arreglo, no
como documentacion. Bajararian la linea base de sesenta y seis a sesenta
y tres.

Leccion de costo. Las dos piezas que nacieron documentadas, estado vacio
y barra de filtros, tienen cero avisos. Las trece heredadas suman
ciento noventa y tres. Se adopta que toda pieza nueva nace con
documentacion publica completa, porque retrofitar cuesta dos ordenes de
magnitud mas que documentar al nacer.

## Hallazgos de la lectura del selector y el esqueleto, deuda de otros subfrentes

Defecto de modo oscuro del esqueleto. Cablea grises claros fijos en su
degradado, sin ajuste por brillo, asi que en oscuro el marcador de carga
sale como parche claro sobre la superficie oscura. Es el mismo defecto que
tenia la insignia de estado de evento. Naturaleza de descableado, no de
arreglo de errores, y no se toca en el commit que resuelve los futuros.

Hueco de validacion del selector, por verificar. La pieza expone texto de
error pero no expone validador, asi que un desplegable marcado como
obligatorio pinta el asterisco pero no participa en la validacion del
formulario que lo envuelve. Antes de afirmarlo como defecto hay que leer
sus consumidores y ver si validan por su cuenta en el notificador. Se
registra como verificacion pendiente, no como defecto probado.

Duplicacion de hoja modal confirmada con evidencia. El modal de seleccion
multiple del selector reproduce encabezado con color de marca, boton de
cierre y fila de acciones, el mismo patron que las hojas de competidor y
de equipos. Es la tercera ocurrencia leida, asi que la pieza de hoja modal
del catalogo tiene su justificacion probada y no especulativa.

Piezas por crear, cuatro, con regla de nacimiento. Marcador de modulo y
aviso temporal primero, porque el marcador desbloquea los destinos de rol
y el aviso temporal limpia los avisos crudos repetidos; hoja modal e
indicador de progreso despues, la hoja con tres ocurrencias probadas y el
indicador con uso crudo en la vista de lista de eventos. Las cuatro nacen
con documentacion publica completa y con prueba de render a ancho
estrecho, por la regla de costo adoptada: las dos piezas nacidas
documentadas tienen cero avisos y las trece heredadas suman ciento
noventa y tres.

## Errata de magnitud en el arreglo del catalogo, ya publicado

El commit 6a0a542 declara seis sustituciones contadas y su diff real es de
ciento setenta y cuatro inserciones y ochenta y tres borrados. La
diferencia es el formateador canonico, que refloweo completos dos archivos
heredados que nunca habian pasado por el. El arreglo funcional son seis
lineas; el resto es forma absorbida por ser el mismo archivo.

No es afirmacion falsa, es omision de magnitud. Las seis sustituciones
existen, pero el mensaje no dice que el formateador aporta el grueso del
diff. Se registra como errata y no se reescribe, porque el commit ya esta
empujado y la regla de la casa prohibe reescribir historia publicada.

Causa de proceso, del lead y nueva. Se entregaron en el mismo turno un
bloque de correccion del mensaje y un bloque de empuje, sin encadenarlos.
Con conexion inestable el autor empujo en cuanto pudo, que es conducta
razonable, y la ventana de correccion gratuita se cerro. El defecto es del
diseño del turno, no de la conducta del autor.

Contramedida adoptada. Cuando exista una correccion de mensaje pendiente
sobre commits locales, el empuje no se ofrece en paralelo: se entrega
dentro del mismo bloque, despues de la correccion, o se retira del turno
hasta que la correccion este hecha.

Leccion tecnica de paso. Elegir espera en vez de envoltura para evitar
reindentar fue inutil, porque los archivos eran heredados sin formatear y
cualquier corrida del formateador los reflowea igual. Lo correcto es
declarar el reflujo, no intentar evitarlo, porque la puerta exige
formatear.

## Refinamiento de la regla de medicion, cruce aritmetico antes de teorizar

Evidencia. Tras aplicar el lote uno de documentacion, una lectura del
analizador devolvio novecientas setenta y seis informaciones y cinco
avisos, cuando el lote debia bajar de ochocientas sesenta y tres a
ochocientas treinta y seis. El lead formulo la hipotesis de un registrante
de plugins bajo la carpeta de herramientas, regenerado por la corrida de
pruebas y no cubierto por la exclusion.

La medicion mato la hipotesis. El alcance de lib dio el mismo total que el
workspace completo, ochocientas treinta y seis, asi que nada fuera de lib
aporta diagnosticos. Y el numero coincide exactamente con la aritmetica
del cambio: dieciocho de la insignia, cinco de la tarjeta de seccion y
cuatro del dialogo, veintisiete en total. La lectura inflada fue
transitoria y no reproducible, con el analizador recien escritas tres
veces las mismas rutas y formateado despues. No hay causa probada y no se
inventa.

Refinamiento adoptado. Cuando un conteo contradice la aritmetica del
cambio, se remide antes de formular hipotesis, y la autoridad es una
lectura que cumple dos condiciones a la vez: autoconsistente entre
alcances, con lib mas test igual al total, y cuadrada con la delta
prevista del cambio. Una sola lectura no es evidencia, y toda hipotesis
sobre la causa de un conteo anomalo se somete a la medicion por alcance
antes de escribirse como hallazgo.

Nota de proceso. El bloque de diagnostico no corrio las pruebas, asi que
la puerta del commit debe incluirlas siempre, aunque el bloque previo
hubiera medido analisis. Un bloque de diagnostico no sustituye a la
puerta.

## Regla de los tres controles binarios, y por que se retiro el interruptor

Interruptor. Ajuste binario con efecto inmediato, sin boton de guardar.
El usuario lo toca y ya esta aplicado. Consumidores legitimos previstos:
notificaciones activadas, sincronizar solo con wifi cuando exista
sincronizacion, recordar sesion. Hoy esas filas de preferencias son
marcadores, asi que el consumidor no existe.

Casilla. Booleano cuyo efecto es diferido, porque forma parte de un
formulario con boton de guardar o de una seleccion multiple que se
confirma. Por eso la seleccion multiple del selector usa casillas.

Barra de filtros. Eleccion entre dos o mas alternativas nombradas. Por
eso el selector de tema usa la barra con sistema, claro y oscuro, y no un
interruptor, que solo representaria dos estados.

Boton con confirmacion. Transicion de estado destructiva, como activar o
desactivar una cuenta. Un toque no debe bastar para dejar a alguien sin
acceso, asi que la tarjeta de usuario usa boton y dialogo, nunca
interruptor.

Retiro del interruptor. El grep de la clase y de la ruta devolvio seis
coincidencias, todas dentro del propio archivo. Cero consumidores,
diecinueve avisos, nunca renderizado, mezcla de la API heredada de color
con la de propiedad de estado sin prueba que la valide, y semantica
incoherente en la fila, donde el aviso recibido solo se dispara al tocar
el interruptor y no al tocar la fila. Se retira y queda en el historial,
recuperable con un comando. Cuando preferencias tenga ajustes reales se
reescribe con consumidor, documentado al nacer y con prueba de render.

## Piezas muertas detectadas al documentar, pendientes de grep

Boton. El parametro isRequired esta declarado y documentado como
marcador sin efecto, porque no interviene en ningun punto del render.
Quitarlo exige grep de consumidores, porque es API expuesta, y es
naturaleza de refactor, no de documentacion.

Entrada de texto. Su clase con estado no guarda ningun estado, asi que
podria ser sin estado. Simplificarla es refactor con prueba de render, no
forma.

Ambas se registran aqui para que no se evaporen y se traten en el
subfrente de piezas muertas con su grep y su prueba.

## Hallazgos del lote tres de documentacion, deuda de otros subfrentes

Avatar. Declara un parametro de imagen que no interviene en ningun punto
del render, y su documentacion afirmaba que mostraba la inicial si no
habia imagen, lo que es falso porque no hay soporte de imagen. La
documentacion se corrigio con la verdad y el parametro se marco como
reservado sin efecto. Quitarlo exige grep de consumidores y es refactor.
Su degradado ademas esta cableado a mano en vez de tomar el de la casa.

Fondo decorativo. Su base es un color fijo oscuro y no sigue el brillo del
tema, asi que en modo claro se ve como marco oscuro alrededor del
contenido, visible en las capturas del autor. Su documentacion afirmaba no
depender del tema, que era literalmente cierto pero ocultaba que no se
adaptaba. Se documento la verdad. Cambiar la base es decision de diseno
del autor, no defecto que el lead corrija en silencio.

Esqueleto. Sus grises fijos siguen sin seguir el brillo, ya registrado.

Nota de instrumento, bajo la regla de medicion. La verificacion de
marcadores por hacer devolvio cuarenta y tres en vez de cinco porque la
busqueda de cadenas es insensible a mayusculas por defecto, y casaba con
metodo, todo y todos dentro de la documentacion en espanol que el propio
lead acababa de escribir. Los cinco marcadores reales estaban en la
lista. Contramedida: toda busqueda de marcadores en ingles se hace con
distincion de mayusculas, porque el codigo esta en ingles y la prosa en
espanol, y sin ella la prosa contamina el conteo.

## Borde muerto del boton primario, hallado leyendo la vista de acceso

Hecho cerrado y verificable sin paleta. El metodo de colores del boton
devuelve un borde fucsia de dos pixeles para la variante primaria, pero
el render lo descarta cuando hay degradado, con la condicion de lado
ninguno si hay degradado. O sea el borde de la variante primaria es
codigo muerto dentro de la propia pieza: se calcula y nunca se pinta,
igual que el marcador sin efecto del boton y la imagen reservada del
avatar.

La duda del autor sobre si hace falta borde queda respondida con el
codigo y no con opinion. No hace falta, porque el degradado delimita la
forma, y el feedback de presionado lo da la onda de Material interna del
boton elevado, activa aunque se ponga elevacion cero, mientras el giro de
carga es la capa de validando. Dos capas distintas, ambas presentes. El
borde solo volveria a importar si el degradado no contrasta con el fondo,
y eso se verifica con la prueba numerica en el frente de fondo.

Accion pendiente, naturaleza de refactor. Quitar el borde muerto exige
grep de consumidores de la variante primaria y prueba de render, porque
es API expuesta. Se registra aqui para que no se evapore y se trata en el
subfrente de piezas muertas junto con el marcador del boton y la imagen
del avatar.

## Contraste de la pestana de acceso, bug de la vista y no de la paleta

Hecho medido. El contenedor de la pestana era un color fijo oscuro y el
texto inactivo un token de texto sobre blanco con alfa cero coma siete.
Calculados con la formula de luminancia de WCAG, ambos modos daban un
ratio de uno coma cuatro, o sea ilegibilidad probada por numero, no por
ojo, y eso explica el reporte del autor de que era ilegible en los dos
modos.

El arreglo no muta la paleta. Los tokens correctos ya existian:
superficie tenue por modo y texto de superficie tenue por modo. Con
contenedor por brillo y texto inactivo por token de cada modo, los ratios
suben a cuatro coma seis ocho en oscuro y trece en claro, ambos por
encima del umbral de cuatro coma cinco que exige texto de catorce puntos
normal. El defecto era que la vista usaba un token de texto sobre blanco,
con alfa, sobre un fondo gris fijo.

Dependencia registrada con el frente de fondo. El logo de la vista de
acceso usa un token de texto casi blanco, legible hoy porque el fondo del
acceso es oscuro fijo. Si el fondo pasa a seguir el brillo, ese logo
blanco sobre claro seria ilegible, asi que el frente de fondo debe
decidir el color del logo por modo y no solo el del fondo.

Respuesta a la duda del borde muerto del boton. Funcionalmente no
importa, el render ya lo anula con la condicion de lado ninguno cuando
hay degradado. Legiblemente si importa, porque confunde a quien lea el
metodo de colores. No se quita ahora porque tocar el catalogo exige gate
de ojo y grep de consumidores del retorno del metodo de colores. Viaja al
subfrente de piezas muertas junto con el marcador sin efecto del boton y
la imagen reservada del avatar.

## Altura de control uniforme, frente de catalogo y no arreglo local

Decision del autor aceptada: un mismo campo de altura para campo y boton,
propuesta de cuarenta y ocho pixeles, que sube el campo desde unos
cuarenta y dos y conserva el suelo accesible del boton, importante para
los jueces mayores.

No es un arreglo local del acceso. Fijar la altura en la entrada de texto,
el selector simple y el boton propaga a todos los formularios del arbol,
eventos, competidores, equipos y acceso, porque son piezas del catalogo
con multiples consumidores. Por eso va como frente aparte, con una
constante compartida de altura de control, gate de ojo propagado y
medicion en telefono fisico, donde el campo de texto puede comportarse
distinto que en navegador. La entrada de texto multilinea y el selector
multiple quedan fuera por ser de alto variable.

No se mezcla con el arreglo de contraste de la pestana, que es local de la
vista y no toca el catalogo.

## Alcance del proveedor de tema confirmado, el control de acceso es local

Hecho medido, no asumido. El proveedor de tema se monta en el alcance
raiz: el ProviderScope de main envuelve el widget raiz, que construye el
MaterialApp.router, y la ruta de acceso es una ruta de ese router. La
vista de acceso ya es un widget consumidor con acceso al alcance, asi
que puede observar el proveedor de tema y escribir en el notificador sin
tocar infraestructura. La hipotesis de que el acceso viviera fuera del
alcance, planteada como riesgo a medir y no como afirmacion, queda muerta
por el codigo. El control de tema en el acceso es un anadido local a la
vista, no un refactor de montaje.

Esto valida el metodo de medir antes de afirmar: la hipotesis se declaro
como riesgo pendiente de dato, y el dato la resolvio a favor de un gesto
pequeno, igual que resolvio la hipotesis del registrante de herramientas.

## Deudas de adopcion del catalogo destapadas en el enrutador

Dos hallazgos de la lectura del archivo de rutas, naturaleza de
descableado, no del gesto actual. Las rutas de entrenador y organizador
pintan texto crudo del Material en vez de tipografia de la casa. El
constructor de error del enrutador usa un boton elevado crudo con
navegacion, en vez de la pieza del catalogo. Ambas se registran para que
no se evaporen y se tratan en el subfrente de descableado con su grep de
consumidores.

## Evidencia positiva del frente de Android

El estilo de la barra de estado ya esta montado a nivel de app con logica
de los tres modos: cuando el modo es sistema se lee el brillo de
plataforma, y cuando es claro u oscuro se fija el estilo correspondiente.
O sea el frente de Android no tiene que montar el overlay, solo verificar
en dispositivo fisico que los iconos de la barra de estado se ven bien en
los tres modos. Eso reduce el bloqueo de lanzamiento a verificacion y no
a construccion.

## Selector de tema en el acceso, aprobado por ojo en los tres modos

El selector emergente de la esquina superior derecha sustituye la barra
inferior rechazada por el autor. Muestra la opcion activa con su icono y
su etiqueta, abre menu con las tres opciones y marca la elegida, y al
cambiar afecta a toda la app incluido el propio acceso. Gate de ojo
pasado con capturas en claro, oscuro y sistema. El error de tipo del
intento previo fue inyectar un reference por constructor en un widget
consumidor, que ya lo recibe en su construccion; se borro el parametro.

## Area segura del selector, riesgo que el navegador no puede verificar

El posicionado estaba fuera del area segura, a doce pixeles del origen
del cuerpo, asi que en un telefono con muesca o barra de estado alta la
pastilla podia quedar debajo. Las capturas del autor son de navegador,
donde los recortes son cero, asi que ahi se ve bien y en dispositivo
podria no verse.

Se envuelve la pastilla en area segura con abajo e izquierda en falso y
relleno superior de doce. Con recortes cero el render es identico al
aprobado, porque el area segura no anade nada y el relleno devuelve los
mismos doce pixeles. Su efecto real solo aparece en dispositivo, y esa
verificacion vive en el frente de Android, que sigue siendo bloqueo de
lanzamiento.

## Deudas del selector, registradas y no mezcladas

Asimetria de fondo. La rama clara cablea blanco puro mientras la oscura
usa el esquema de color. Naturaleza de descableado.

Tipografia cruda. La pastilla y las opciones del menu usan estilo de
texto directo en vez del catalogo tipografico de la casa. Naturaleza de
descableado.

Alto de toque insuficiente. La pastilla mide unos treinta pixeles, por
debajo del minimo accesible de cuarenta y ocho, que importa porque los
usuarios finales pueden ser jueces mayores. No se sube aqui porque
cambiaria el aspecto que el autor acaba de aprobar; entra en el frente
de altura de control de cuarenta y ocho ya aceptado, junto con entrada
de texto, selector simple y boton, con su gate de ojo propagado.

Duplicacion de pares. Los pares de icono y etiqueta aparecen en la
expresion de seleccion y otra vez en los elementos del menu. Se
registran para extraerlos a una lista constante en el subfrente de
descableado.

## Frente de altura minima de control, y el error de caparla

Decision del autor aplicada. Se crea un archivo de dimensiones en el
tema, porque no existia y la altura no pertenece a la paleta. La
constante de cuarenta y ocho se aplica a la entrada de texto, al
selector simple, al boton y a la pastilla de tema.

Error de diseno del lead, cazado por el gate de ojo. La primera version
fijaba minimo y maximo a cuarenta y ocho para forzar igualdad exacta. Un
tope duro sobre un campo decorado es fragil, porque su alto natural
varia con la pista, el texto de error, el icono y las metricas de la
fuente; cuando el natural supera el tope, el decorador comprime la caja.
El autor lo reporto con capturas: los campos se encogian segun su
estado. La puerta estatica habia pasado sin variacion, asi que el
defecto solo era visible en pantalla, que es exactamente para lo que
existe el gate de ojo.

Contramedida. Se aplica solo el minimo, nunca el tope. La uniformidad se
cumple como todos los controles de al menos cuarenta y ocho, y una
diferencia de uno o dos pixeles por metricas de fuente es imperceptible.
Forzar igualdad exacta era el objetivo equivocado. Con solo el minimo,
la condicional de etiqueta flotante y multilinea deja de hacer falta y
el codigo queda constante. La documentacion de la constante se corrige
para decir minimo y no alto fijo.

Pieza pendiente registrada. El modo solo icono del boton sigue en
cuarenta y cuatro porque sus consumidores pasan cuarenta y cuatro
explicito, y subirlo sin tocarlos provocaria conflicto de
restricciones. Exige grep de consumidores y prueba de render.

## Deuda de variante en el formulario de equipo

Reporte del autor con captura. La accion de agregar competidores del
formulario de crear equipo usa la variante primaria, con degradado de
marca, cuando debe seguir el mismo estilo de contorno que la accion de
agregar equipos del formulario de crear evento. Es una accion
secundaria que abre un selector, no la accion principal de enviar, asi
que competir visualmente con el envio rompe la jerarquia.

Naturaleza de adopcion de variante en una vista de feature, no de
catalogo. Exige leer el archivo del formulario de equipo. Se registra
para tratarlo en el subfrente de descableado y adopcion.

## Cola confirmada por el autor

El frente de fuentes empaquetadas queda detras de este. Esta confirmado
por medicion que la tipografia se pide en tiempo de ejecucion, lo que
produce salto de layout en el arranque y deja la app con fuentes de
reserva si no hay red. Es bloqueo de lanzamiento por arranque sin
conexion, no solo estetica.

## Defecto de validacion destapado por el pase visual del frente de altura

Causa leida en codigo, no supuesta. El envoltorio de formulario declara
el modo de autovalidacion en interaccion del usuario a nivel de
formulario, y en Flutter eso valida todos los campos en cuanto cualquiera
recibe interaccion. Sintoma reportado por el autor con capturas: escribe
en un campo y saltan los errores de los que no toco.

Correccion propuesta. Cambiar el modo por defecto a validacion al perder
el foco, que valida cada campo cuando sale de el y deja en paz los no
tocados. El envio sigue validando todo porque eso lo hace la llamada
explicita de validacion. Es una linea, pero cambia el comportamiento de
todos los formularios, asi que exige gate de ojo propagado y verificacion
de que el valor existe en la version de Flutter del proyecto, cosa que el
analizador confirma solo.

## Deuda de coherencia de mensajes, frente propio

Peticion del autor. Las validaciones y los textos de los dialogos y
avisos estan dispersos y cada vista inventa su redaccion, asi que un
mensaje dice una cosa y otro dice otra para la misma situacion. Pide un
catalogo de mensajes con plantilla fija y un punto unico de validacion,
para que la estructura sea igual en toda la app.

Naturaleza: frente propio de dominio y presentacion, no parche. Mezclarlo
con un arreglo de formulario esconderia el alcance real, que es
transversal a todas las features.

## Hallazgo de tipografia, empaquetar no elimina el salto

La biblioteca de fuentes carga siempre de forma asincrona, incluso con
los archivos empaquetados en su carpeta convencional. Asi que
empaquetar cura el arranque sin red y la dependencia de la red, pero no
elimina el salto de metricas del primer fotograma.

Via correcta para eliminar el salto. Declarar las familias en la seccion
de fuentes del manifiesto y referenciarlas por nombre en el estilo de
texto, retirando la dependencia de la biblioteca. Las fuentes cargan con
el motor, sin paso asincrono, sin salto y sin red.

Pesos que el archivo de tipografia pide: Sora seiscientos y setecientos;
Manrope cuatrocientos, quinientos y seiscientos. Cinco archivos.

Verificacion pendiente. El metodo de precarga dice en su documentacion
que evita el parpadeo del primer fotograma, y eso no es cierto con carga
asincrona. Hay que comprobar si alguien lo llama y corregir su
documentacion o retirarlo segun el dato.
