# Plan de frentes restantes, con criterios de aceptacion

Estado verificado al abrir este plan.
- HEAD al redactar: 54ed035.
- Base medida en la ultima puerta: 63 errores, 4 avisos, 685 informaciones, 81 pruebas verdes.
- El README y el informe declaran 66 errores, 79 pruebas y 880 informaciones mas 5 del editor. Ese hueco de 3 errores y esas cifras caducas se reconcilian en F0.1 con el texto vivo en mano, no desde copias.
- El intentions en disco trae bloques duplicados por el auxiliar de anexión del lead. Se deduplica en F0.1.
- El widgets_usage en disco es la guia aspiracional vieja de unas 53 piezas. El plan no ancla contra el. La guia viva del catalogo es el inventario de 15 archivos en shared.

## Principios de orden, tomados del propio intentions
1. Direccion de dependencia manda: shared final antes que las features que lo adoptan, para que eventos y demas adopten el catalogo una sola vez.
2. Puntuacion se construye al final de su eje, porque consume identidad de juez, roster, categoria y evento. Construir al consumidor antes que sus dependencias obliga a reescribir su capa de consumo cada vez que algo de abajo se mueve.
3. La vista de visitante consume la salida de puntuacion y va despues de ella.
4. La fase inicial es CONSTRUIR puntuacion y visitante de verdad, no solo sanear gestion. Eso reencuadra el eje del plan.
5. El reordenamiento de produccion (Android, sincronizacion, seguridad por rol) va al final, cuando exista juez que consuma el permiso y visitante que vea el resultado protegido.
6. Cerrar lo abierto de identidad y arranque antes de abrir el eje de construccion.

Regla transversal: ningun frente se commitea sin su puerta. Los frentes de superficie exigen gate de ojo previo al commit, con la lista de puntos de riesgo que el lead declara en la entrega. Los de forma se verifican por numero. Los documentales no exigen ojo. Cada frente declara su precondicion de lectura: si el lead no ha leido el archivo, pide el archivo antes de anclar sustituciones. Prohibido anclar contra widgets_usage. Prohibido el guion medio y la raya en cualquier literal, comentario o texto de este plan y del codigo. Prohibidas las formas verbales de mejora forzada de rendimiento; se emplean ajuste, afinamiento, mejora, rendimiento o eficiencia segun contexto.

## Fase 0, higiene y reconciliacion, antes de construir nada

### F0.1 Reconciliacion de metricas y limpieza documental
Naturaleza: documental y de medida. Puerta: sin ojo, se verifica por numero y por grep. Precondicion de lectura: texto vivo de README, informe, changelog e intentions desde disco, no desde copias.
Criterios de aceptacion:
- El total de errores del doc coincide con el medido por area, y el desglose por area cuadra con el total. Si shared tiene 3 errores, se registran y se arreglan o se declara que el doc estaba mal. Si shared tiene 0, se registra el frente que los bajo.
- intentions sin bloques duplicados: cada titulo de frente aparece una sola vez.
- README sin linea de guion suelto huérfano y sin contradiccion interna entre cero avisos y dieciseis informaciones por modulo.
- Las cifras de pruebas, errores e informaciones del doc son las del analizador del CLI con el alcance del config, y los marcadores por hacer se declaran aparte como deuda, no sumados a la informacion.
- El conteo de pruebas se remide al cerrar cada frente, no solo el de errores, porque ambos se mueven.

### F0.2 Cierre de splash, capa nativa y deuda del logo
Naturaleza: superficie y nativo. Puerta: parada completa en dispositivo, gate de ojo. Precondicion de lectura: main.dart, app_colors.dart (hex de backgroundBase ya leido como 0A0515), y el enrutador ya completo.
Criterios de aceptacion:
- flutter_native_splash con color 0A0515 identico a la base oscura y el logo real centrado, android en verdadero, web en falso. El negro anterior al motor desaparece en parada completa.
- El corte de la capa nativa a la capa Dart es invisible, porque el color de fondo es el mismo hex.
- El conjunto de marca de la capa Dart sube el logo de 132 a unos 156 y añade un velo localizado detras, degradado vertical suave de transparente abajo a semioscuro arriba solo en esa franja, para que el nombre lea con contraste garantizado sobre el cruce de cintas. No se centra el conjunto en el medio exacto, porque el cruce magenta y violeta mata la separacion del logo de degradado rosa.
- Puerta estatica en 63, 4, 685 y 81 antes del ojo, y el commit limitado por rutas con el recurso y los archivos nativos generados.

## Fase 1, catálogo final shared, eje por dirección de dependencia

Regla de frontera de la fase. Fase 1 es shared puro más el primer
consumidor de cada pieza, porque crear la pieza y darle un consumidor vivo
que la pruebe son la misma unidad, como ya bundea F1.1 al pedir que el
marcador sustituya destinos y la hoja absorba encabezados. Todo consumidor
más allá del primero, y todo descableado de código de funcionalidad, sale
de fase 1 y va a los frentes funcionales y de seguridad del final.

### F1.1 Las piezas por crear y su gate de ojo
Naturaleza: forma y superficie, con piloto de primer consumidor.
Puerta: prueba de render a ancho estrecho y gate de ojo sobre un
consumidor vivo. Precondición de lectura: grep de la pieza excluyendo su
propia línea de definición, y lectura de los sitios crudos que debe
sustituir.
Estado medido en la auditoría de inventario. Veinte piezas reales en el
catálogo. Seis nuevas creadas, documentadas y con prueba de render: aviso
temporal, marcador de módulo, indicador de progreso, hoja modal,
andamiaje de formulario y retorno al principio, más la variante de marca
suave y sus seis tokens. Cinco cumplen los tres criterios con consumidores
vivos, aviso tres, marcador cuatro, progreso uno, andamiaje tres y retorno
uno. La hoja falla el tercero con cero consumidores vivos, víctima de que
la práctica de probar al nacer se adoptó tarde.
Criterios de aceptación.
* Cerrar el residual único: dar a la hoja un consumidor vivo y su gate de
  ojo, pilotándola en un sitio crudo de showModalBottomSheet, por ejemplo
  el más simple de teams_section o event_form, envolviendo su constructor
  de contenido con la pieza. Sin esto F1.1 no cierra, porque el criterio
  de gate donde haya consumidor vivo es estructuralmente imposible para
  una pieza huérfana.
* Verificar que los cuatro consumidores del marcador cubren los destinos
  crudos de entrenador, organizador y la vista temporal de juez principal,
  con lectura dirigida y no con regex, subpunto de baja prioridad.
* Registrar como hallazgo de proceso que la prueba de render y el gate de
  ojo al nacer se adoptaron a mitad de camino, y que la hoja es la única
  casualty de ese retraso, pues las demás recibieron su piloto en la
  presentación de competidores.

### F1.2 Documentación pública y normalización de idioma
Naturaleza: documental. Puerta: sin ojo, se verifica por número.
Precondición de lectura: mapa medido de informaciones de documentación
pública por archivo, ampliado a shared y a core y theme.
Estado medido en la auditoría de inventario. Shared widgets en cero
documentación faltante, así que el mapa viejo del plan, selector treinta
y seis y demás, está vencido. La deuda real son setenta y cuatro
informaciones en app_colors, más la violación de Idioma de la App.md en
comentarios y documentación escritos en ASCII sin tildes, incluidos los
bloques que el lead autoró en la bitácora y el cuerpo del propio plan.
Criterios de aceptación.
* Documentar los setenta y cuatro tokens de app_colors con documentación
  pública en español con tildes, cero informaciones de
  public_member_api_docs en ese archivo.
* Normalizar tildes y eñe conforme a Idioma de la App.md en
  docs/intentions.md, en el plan frentes y en los comentarios heredados y
  en los del lead, y unificar los marcadores de lista a asteriscos.
* Mantener en cero la documentación de las piezas nacidas documentadas,
  que ya lo están, y no tocarlas salvo por tildes.

### F1.3 Piezas muertas
Naturaleza: refactor. Puerta: grep de consumidores y prueba de render tras
el retiro. Precondición de lectura: grafo de consumidores de cada
parámetro.
Estado medido en la auditoría de inventario. La lista del plan sigue
vigente. Las discrepancias de conteo de andamiaje cuatro y retorno dos NO
son piezas muertas, eran ruido de instrumento por no excluir la línea de
definición, y se excluyen de este frente.
Criterios de aceptación.
* Cerrados con grafo vacio y prueba de render: el borde muerto del
  boton primario, el marcador isRequired y la imagen reservada del
  avatar, mas los doce tokens de la paleta sin consumidor. La
  capacidad de imagen del avatar se extiende con el consumidor
  delante cuando el perfil la requiera, decision del autor.
* Aplazada a F2.2 con razon de costo: la simplificacion de la entrada
  de texto a sin estado. Su estado esta muerto hoy, pero F2.2 le
  anade nodo de foco y rastreo del primer desenfoque, asi que
  convertirla ahora y devolverle estado despues es trabajo doble y
  decidir la API dos veces.
* Si el grep da consumidores, se arregla el uso en lugar de retirar la
  pieza.

### F1.4 Descableado interno de shared y tema
Naturaleza: mixto, forma y color. Puerta: grep de literales y prueba de
render, gate de ojo propagado. Precondición de lectura: app_theme.dart,
entrada de texto, botón, selector, aero_section_card y app_dimens.
Estado medido en la auditoría de inventario. Frente que la numeración
previa del lead omitió. Incluye el cuarenta y cuatro cableado del modo
solo icono, por debajo del mínimo accesible de la casa, y el ternario de
brillo de aero_section_card que causa la divergencia de superficie en
oscuro aceptada como costo al migrar competidores.
Criterios de aceptación.
* Cero literales hex en app_theme fuera de AppColors, y cero
  referencias a la paleta de Material en app_theme, en core y theme y
  en shared. Enmienda medida: la clausula original solo prohibia
  Material en shared, lo que perdonaba al tema, donde viven cuatro
  literales hex y cinco referencias de Material. Inventario medido en
  shared: doce deudas cromaticas, rojo y verde semanticos del dialogo
  de alerta, seis grises de insignia, selector y esqueleto, y cuatro
  sombras con negro, mas dos ternarios de superficie con blanco
  literal en tarjeta de seccion y selector. El resto de coincidencias
  son primitivas legitimas, transparente y blanco sobre degradado
  fijo de marca.
* Retirar el borde fucsia del botón elevado a nivel de tema. Alinear
  relleno y radio de la decoración de entrada con los de la pieza del
  catálogo. Tipografía cruda del selector de tema al catálogo
  tipográfico, y pares duplicados de icono y etiqueta a una lista
  constante.
* Subir el cuarenta y cuatro del modo solo icono a AppDimens.controlHeight
  para respetar el mínimo accesible sin tocar consumidores.
* Bajar el ternario de brillo de aero_section_card a colorScheme.surface,
  lo que unifica la superficie de lista y formulario en oscuro y cierra la
  divergencia declarada como costo.

### F1.5 Guía viva de dos niveles
Naturaleza: documental. Puerta: sin ojo. Precondición de lectura: la guía
viva del catálogo, no widgets_usage como estaba.
Estado medido en la auditoría de inventario. La guía inventaría catorce
piezas contra veinte reales, y tres hojas contra seis reales, y anuncia
cuatro por crear que ya existen, más dos que nunca anticipó, andamiaje y
retorno al principio. Vencida en dos direcciones.
Criterios de aceptación.
* La guía inventaria solo lo vivo en shared, veinte archivos, y añade una
  línea de contrato que diga que este documento solo inventaria lo vivo en
  shared y que las piezas reubicadas por pertenencia se buscan en su
  feature.
* Corregir los conteos vencidos, piezas catorce a veinte y hojas tres a
  seis, y marcar como creadas las cuatro que anunciaba por crear.
* Declarar el sistema de dos niveles, marca con arte raster en entrada,
  trabajo con casco oscuro y lavados radiales en ambos modos, y prohibido
  arte a sangre en pantallas de datos.
* Normalizar tildes de la guía, cruzado con F1.2.

### Fuera de fase 1, frentes que la auditoría destapó
* Descableado funcional masivo, en las fases de funcionalidad. Los
  dieciocho avisos restantes, los nueve indicadores circulares y dos
  lineales restantes, las cinco hojas restantes tras el piloto de F1.1,
  los cinco diálogos de alerta, los dos avatares, los seis contenedores
  fucsia al diez por ciento y los cuarenta grises de funcionalidad, más
  los sitios de estado y rol de la insignia, que hay que leer con objetivo
  en competitor_list_view, team_list_view, role_assignment_card,
  role_management_section, judge_selection_sheet y home_section, y no con
  el regex de doscientos trece que tragó código generado y enumeraciones.
* Seguridad de filtros de backend, frente propio. Los nueve escapes de
  team_repository_impl, user_repository_impl y pocketbase_filter son
  saneamiento de consultas, no descableado de piezas, y no entran en
  shared.
* Frente de idioma y mensajes, donde vive el mapeo del error del backend
  al catálogo en español, deuda declarada desde competidores.

## Fase 2, UX viva transversal

### F2.1 Coherencia de mensajes
Naturaleza: dominio y presentacion. Puerta: grep y gate de ojo en los formularios. Precondicion de lectura: vistas con validadores y dialogos de alerta, y decision previa de si dominio devuelve codigos o cadenas.
Criterios de aceptacion:
- Catalogo de mensajes con plantilla fija y punto unico de validacion. Grep de cadenas de validacion y error manuscritas en dominio y datos vacio, porque esos mensajes salen del catalogo. Un solo punto de validacion por formulario. La estructura es igual en toda la app.

### F2.2 Hibrido de validacion
Naturaleza: superficie. Puerta: prueba de widget y gate de ojo propagado a todos los formularios. Precondicion de lectura: aero_select.dart y el area de texto multilinea, que no se han leido en este hilo.
Criterios de aceptacion:
- El campo calla hasta su primer desenfoque y desde ahi valida en vivo. Prueba de widget que afirma que el error aparece al desenfoque y desaparece al corregir sin tocar otro campo. Nodo de foco rastrea el primer desenfoque en entrada, selector simple y area, y el area pasa a tener estado.

## Fase 3, features de gestion saneadas, shared ya final

### F3.1 Eventos
Naturaleza: forma y adopcion. Puerta: grep, prueba y gate de ojo. Precondicion de lectura: event_list_view, formulario de evento y EventStatusBadge.
Criterios de aceptacion:
- Los 11 errores de presentacion (5 lista y 6 formulario, mismas clases ya corregidas en equipos) desaparecen. El escape de filtro de core se adopta. EventStatusBadge migra a variantes semanticas del catalogo. Los chips de filtro crudos (GestureDetector mas Container con hex cableado, incluido 8B00FF que deberia ser glowViolet) pasan a AeroFilterBar. El CircularProgressIndicator crudo pasa al indicador del catalogo. El Divider crudo y el debugPrint con TODO y codigo comentado se retiran. La cabecera con ruta vieja se corrige.

### F3.2 Competidores
Naturaleza: forma y adopcion. Puerta: grep y prueba. Precondicion de lectura: repositorio y vista de lista de competidores.
Criterios de aceptacion:
- El escape de filtro se adopta, grep de interpolacion de filtro sin escapar vacio. Cabecera con ruta vieja corregida. Crudos migrados al catalogo.

### F3.3 Autenticacion
Naturaleza: forma y dominio. Puerta: prueba numerica de contraste y gate de ojo. Precondicion de lectura: entidad de usuario, modelo, enrutador, filtro y tarjeta de asignacion.
Criterios de aceptacion:
- Enumerado de estado de cuenta con conversion desde almacenamiento, que retira los literales sueltos Active, Inactive y Pending Approval de las siete rutas. Cero literales de estado en entidad, modelo, enrutador, filtro y tarjeta. Chip de rol O1 con pares de contenedor y texto por modo para los nueve roles, prueba numerica de contraste que afirma cada par por encima del umbral de 4.5 para texto pequeno. Pase unificado de la tarjeta con el dialogo y los avisos en una sola apertura.

## Fase 4, toolchain

### F4.1 Migracion coherente de la cadena riverpod
Naturaleza: forma y generacion. Puerta: gate global, pub outdated y cero regresión en pruebas. Precondicion de lectura: versiones objetivo verificadas, no upgrade suelto.
Criterios de aceptacion:
- La cadena completa de riverpod (annotation, generator, lint, analyzer_utils y custom_lint_visitor) migra de forma coherente. El aviso de build_runner que compara el SDK con el analyzer desaparece. build_runner conserva la bandera de salidas en conflicto o se actualiza el ritual de gate. La capa cuatro de admin migra a anotaciones en el mismo gesto, sin mezcla de manual y generado en la misma funcionalidad.

## Fase 5, construccion de la fase inicial, el corazon

### F5.1 Puntuacion
Naturaleza: construccion, no limpieza. Puerta: gate de pruebas y esquema real delante. Precondicion de lectura: esquema vivo de PocketBase, no migraciones viejas.
Criterios de aceptacion:
- Los 52 errores de lecturas implicitas de dinamico en los tres modelos desaparecen con conversiones estrictas contra el esquema vivo. Prueba de repositorio con cliente inyectable, precondicion de refactorizar el contrato de acceso. Las rutas de juez apuntan a la vista real construida, no al marcador provisional. Orden de capas fijo: dominio, datos, inyeccion, presentacion.

### F5.2 Visitante y resultados
Naturaleza: construccion. Puerta: gate de ojo con datos reales. Precondicion de lectura: salida de puntuacion ya construida.
Criterios de aceptacion:
- El rol espectador tiene destino propio, no la pantalla de cuenta pendiente que le miente. Tabla y paginacion del catalogo adoptadas. La vista consume la salida de puntuacion.

### F5.3 Planilla de equipo, fase obligatoria
Naturaleza: backend, datos y presentacion. Puerta: gate de ojo y prueba de subida. Precondicion de lectura: historial de migraciones de Teams reconciliado.
Criterios de aceptacion:
- Backend anade un campo de archivo a Teams y su migracion, reconciliando el historial que hoy no cuadra con el esquema vivo. Datos mapea el campo con lectura segura y decide si la entidad expone id de archivo o objeto de archivo. Presentacion restaura la subida real con validacion de extension y tamano y la llamada multipart de PocketBase, en lugar del selector muerto que se quito.

## Fase 6, lanzamiento, reordenado al final

### F6.1 Android
Naturaleza: nativo y seguridad. Puerta: dispositivo fisico y build de release. Precondicion de lectura: manifiesto principal y de depuracion leidos.
Criterios de aceptacion:
- Permiso de red declarado en el manifiesto principal, porque sin el la release no tiene red. Texto claro solo en depuracion, no global, porque abrir HTTP sin cifrar en produccion seria cambio de postura de seguridad. URL de produccion real, no marcador. Guard de rutas por permisos dinamicos de la coleccion Roles, con datos sembrados y consumidor real, no por prefijo.

### F6.2 Sincronizacion sin conexion
Naturaleza: backend y dominio. Puerta: ciclo de punta a punta offline. Precondicion de lectura: coleccion de cola en migracion.
Criterios de aceptacion:
- La coleccion de cola o de estado existe en una migracion. El ciclo registro, equipos, competidores, entrenadores y jueces emitiendo puntuaciones se ejecuta de punta a punta offline y reconcilia al reconectar.

## Fase 7, cierre documental

### F7.1 Cierre de shared y version
Naturaleza: documental. Puerta: sin ojo, se verifica por numero. Precondicion de lectura: estado final del catalogo tras F5 y F3.
Criterios de aceptacion:
- Un solo gesto ata version, changelog, informe, intentions y etiqueta anotada. Las cifras del doc son la medicion fresca, incluida la reconciliacion de F0.1. El changelog tiene entrada de los frentes de marca, tipografia y splash, y se decide con el autor si son minor 0.4.0 de identidad y arranque o patches 0.3.x. La guia del catalogo es el inventario vivo.

## Notas de riesgo del plan
- F0.2 y F1.1 a F1.4 tocan superficie y catalogo, asi que su gate de ojo es previo al commit y con lista de puntos de riesgo.
- F5.1 y F5.2 son construccion con precondiciones de backend y de esquema que hoy no estan del todo; no se commitea sin el esquema real delante.
- F6 depende de backend que no existe en este repo; no se cierra solo desde el lado Flutter.
- F7 documenta el catalogo final; si F1 o F3 cambian despues de F7, F7 se reabre.

## Estado medido al cierre de F1.3

Base medida con analizador de CLI, alcance del config, conteo deduplicado y
autoconsistente por suma de severidades: sesenta y tres errores, cuatro
avisos, quinientas ochenta y nueve informaciones y ciento una pruebas
verdes. HEAD al redactar este anexo: 3db2ae6.

Frentes cerrados. F1.1, las piezas por crear con su piloto, incluida la
hoja modal con primer consumidor vivo. F1.2 a, la paleta documentada en
español con tildes y en cero documentacion publica faltante. F1.3, API
muerta del boton y del avatar y los doce tokens sin consumidor, con sus
citas reconciliadas.

Frentes pendientes de fase 1. F1.2 b, normalizacion de tildes de las piezas
del catalogo que siguen en ASCII y de los archivos de core y theme sin
documentacion faltante. F1.4, descableado interno de shared y tema, con la
clausula de Material ya enmendada. F1.5, guia viva contra el arbol.

Decisiones del autor ya fijadas para F1.4. El contenedor de superficie en
claro pasa a un token propio con valor ECECF0, documentado al nacer, porque
reutilizar el token de superficie tenue como contenedor seria desajuste de
rol; con eso la separacion contra el fondo sube de 1.044 a 1.178 y la
colision de hex con el texto primario oscuro desaparece. El texto de
superficie en oscuro se realinea al token de texto primario oscuro del
catalogo, con contraste 16.34 verificado, frente a 17.06 del blanco puro,
diferencia imperceptible que unifica catalogo y esquema en un solo token.

Deuda medida pendiente de clasificar. El texto blanco del boton primario
sobre el extremo fucsia del degradado da 3.14, y sobre el violeta 5.93. El
umbral aplicable depende del peso real de la etiqueta en el archivo de
tipografia, que no se ha leido, asi que la deuda esta medida pero no
clasificada y no se afirma ilegibilidad sin ese dato.

Documentos vencidos, con correccion en F1.5 y F7.1. La guia del catalogo
declara catorce piezas y tres hojas frente a veinte y seis reales, y el
README declara setenta y nueve pruebas, sesenta y seis errores y
ochocientas ochenta informaciones frente a las reales. La autoridad es el
arbol, no el documento.
