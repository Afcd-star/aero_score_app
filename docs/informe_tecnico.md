# Informe tecnico de AeroScore

## 1. Proposito

Radiografia honesta del estado real de la aplicacion y base para auditoria
de calidad. No es material de marketing. Se actualiza en el mismo commit
que cierra cada funcionalidad, junto con el changelog y la version.

La bitacora de decisiones, el registro de deuda con precondiciones y las
correcciones de metodo del lead viven en `docs/intentions.md`. Este
informe no las duplica: las apunta.

## 2. Arquitectura

Organizacion feature first con Clean Architecture en cuatro capas por
funcionalidad: dominio, datos, inyeccion y presentacion. El orden de
ataque dentro de cada funcionalidad es fijo y no negociable.

Dominio: tipos, enums, entidades y contratos de repositorio. Se valida con
analisis estatico y prueba de unidad de igualdad y validacion. El modelado
es mixto por decision: administracion usa Freezed, equipos y usuario son
clases manuales con migracion registrada. No se impone Freezed como
mandato unico mientras esa migracion no se ejecute.

Datos: modelos con mapeo explicito y lectura segura de mapas,
implementaciones de repositorio con manejo explicito de errores. Se valida
con analisis estatico. La prueba de repositorio con dobles esta diferida
por desviacion registrada: el cliente de PocketBase no es inyectable.

Inyeccion: proveedores de datos, unicos por funcionalidad, con cliente
global inyectado para que todas las consultas lleven token.

Presentacion: estados, notificadores, vistas y widgets del catalogo de
marca. Se valida con analisis estatico y pase visual. Las pruebas de
widget se exigen para pieza de catalogo nueva o tocada, con render a ancho
estrecho; para vistas de feature siguen diferidas al frente de shared.

Cierre: commit atomico por naturaleza con mensaje que refleje el cambio
real.

Arbol de lib:

- `lib/src/core`: tema, rutas, inyeccion global, errores y utilidades.
- `lib/src/shared`: catalogo de widgets Aero y componentes comunes.
- `lib/src/features/admin`: panel de administracion.
- `lib/src/features/auth`: autenticacion, sesion, aprobacion y gestion de
  usuarios con sus roles y estados.
- `lib/src/features/competitors`: gestion de competidores.
- `lib/src/features/events`: gestion de eventos.
- `lib/src/features/teams`: gestion de equipos.
- `lib/src/features/scoring`: modulo de puntuacion, en construccion.

## 3. Stack y decisiones

Estado: Riverpod 3.x con proveedores manuales tipados. La migracion a
anotaciones viaja en el frente de toolchain, no dentro de una feature a
mitad de ciclo, para no mezclar manual y generado en la misma
funcionalidad.

Enrutamiento: GoRouter con la ruta como fuente de verdad de la seccion
activa donde aplica.

Modelado: mixto y declarado. Freezed en administracion; clases manuales en
equipos y usuario, con la limitacion de copia nulable registrada y test
canario que avisara cuando Freezed la resuelva. Regla: nunca editar el
generado, regenerar con build_runner.

Errores: either_dart con Left de Failure tipado. La clase base Failure
implementa Exception para permitir propagar el fallo por throw sin violar
el lint de solo lanzar errores.

Backend: PocketBase con cliente global que restaura la sesion desde
SharedPreferences. Los repositorios reciben el cliente inyectado, no
construyen el suyo.

UI: Material 3 con catalogo Aero propio. Regla operativa: si un widget del
catalogo cubre la necesidad, se usa el catalogo; si no, se extiende el
catalogo antes de improvisar en la vista. Toda decision de widget se
contrasta con el arbol y con la guia de uso, que ya inventaria solo lo
que existe.

Tipografia: Sora para titulos y Manrope para cuerpo, con los quince roles
de TextTheme declarados. Un rol ausente anula en silencio tamano, peso y
color via copyWith.

Idioma: codigo en ingles, comentarios e interfaz en espanol.

## 4. Estado por modulo

- Administracion: CERRADA en 0.1.0. Panel con navegacion tipada derivada
  del enum y seccion sincronizada desde la ruta. En 0.3.0 gano la seccion
  de usuarios, asi que el catalogo de secciones paso de seis a siete.
- Equipos: CERRADA en 0.2.0. Validacion unificada, igualdad sobre campos
  de contenido, modelo tipado contra el esquema vivo, escape de filtros y
  borrado logico coherente. Incrementos funcionales registrados como
  frentes propios: disponibilidad de asignaciones y coherencia de
  modalidad del roster. La planilla es fase obligatoria.
- Usuarios y aprobacion: CERRADA en 0.3.0. Seccion propia con filtros en
  cliente, busqueda, refrescar y estado vacio del catalogo. Transiciones
  de cuenta con confirmacion para las destructivas, y lote sobre el filtro
  que le da sentido.
- Autenticacion: flujo de aprobacion cerrado de extremo a extremo y
  entidad documentada. Deuda funcional abierta: la clase de aprobacion
  pendiente no esta marcada como final, la ventana de solapamiento en
  restauracion de sesion requiere prueba, y el cierre de sesion abandona
  la llamada remota sin error recuperable. Deuda de raiz: el estado de
  cuenta es cadena suelta y pide enumerado con conversion.
- Competidores: saneada en analisis estatico. Cabecera con ruta vieja y
  adopcion del escape de filtro pendientes.
- Eventos: saneada en analisis estatico, con once errores de severidad
  ocho en presentacion, de las mismas clases ya corregidas en equipos.
  Cabecera con ruta vieja pendiente.
- Puntuacion: en construccion, no codigo muerto. Tiene tres modelos,
  repositorio, notificador, vista y dos widgets en su carpeta de
presentacion, con cincuenta y dos errores concentrados en lecturas implicitas de dinamico. Sus rutas ya
  no se alcanzan por inicio de sesion. Se reaudita y reescribe en su
  frente, con el esquema real delante.
- Visitante y resultados: no existe. El espectador acaba en la pantalla de
  cuenta pendiente aunque este aprobado, lo cual es falso.
- Sincronizacion: no iniciada.

## 5. Metricas medidas al cierre 0.3.0

- Pruebas: setenta y nueve, verdes.
- Errores de analisis: sesenta y seis. Primera bajada de la linea base,
  que estaba en sesenta y siete.
- Distribucion de errores: puntuacion cincuenta y dos, eventos once,
catalogo compartido tres. Los once de eventos son cinco en la vista de
lista y seis en el formulario.
Advertencias: cuatro, todas de estilo de comentario por hacer.
Informaciones: ochocientas ochenta del analizador. El editor muestra
ochocientas ochenta y cinco porque sintetiza cinco entradas desde
comentarios por hacer, que no son diagnosticos del analizador. La
autoridad de este informe es el analizador, no el contador del editor.
- Modulos en cero avisos: solo equipos. Administracion dejo de serlo al
recibir los dos widgets del panel con dieciseis informaciones, y la
seccion de usuarios con su tarjeta tampoco, porque la tarjeta vive ahora
en autenticacion, que suma veinte.

## 6. Deuda tecnica, por bloqueo de lanzamiento

Primero lo que impide publicar:

- Manifiesto principal de Android sin permiso de red. Correccion de la
  deuda previa: depuracion y perfil si lo declaran, asi que el bloqueo es
  de lanzamiento, no de dispositivo fisico. Depuracion ya permite texto
  claro para el backend en red local.
- URL de produccion del entorno como marcador.
- Rutas de puntuacion hacia pantalla sin construir.
- Destino del espectador inexistente.
- Guard de rutas por prefijo, no por permisos dinamicos. La coleccion Roles
  existe sin datos sembrados ni consumidor.
- Sincronizacion sin conexion, con precondicion de coleccion de cola.

Despues lo que degrada calidad sin impedir publicar:

- Tokens semanticos de marca. Los de estado ya se cerraron: las variantes
del badge usan tinte suave con texto saturado por modo y su contraste
esta verificado por prueba numerica. Queda el fucsia de la variante
primaria, marginal con blanco para texto pequeno.
- Cuatro piezas de catalogo por crear: aviso temporal con su tema,
  marcador de modulo, indicador de progreso y hoja modal.
- Documentacion publica: boton, envoltorio de formulario y tarjeta de
seccion en el catalogo; los dos widgets del panel en administracion; la
tarjeta de asignacion en autenticacion; y la insignia de estado en
eventos, con cuatro avisos.
- - Enumerado de estado de cuenta.
- AppEnvironment como segunda fuente de verdad de entorno.
- Notifiers de interfaz dentro de data di.
- Prueba del repositorio de administracion contra PocketBase, con
  precondicion de cliente inyectable.
- Heuristica de dos segundos de la actividad, con precondicion de
  coleccion de auditoria.
- Vinetas del reglamento camufladas sobre su fondo.
- Monograma fijo en el menu lateral en lugar de avatar de usuario.
- Selector de tema con persistencia e interruptor.
- Aviso de build_runner contra el analyzer, clavado por la cadena de
  riverpod_lint. No se resuelve con actualizacion suelta.
- Cabeceras con ruta vieja en archivos de competidores y eventos.
- Registro de rol desconocido solo de depuracion.
- Prueba de widget del guard de alcance del lote, diferida con ruta y
  casos escritos.
- Anchura del dialogo de confirmacion, registrada como pulido y no como
  bloqueo, porque el conteo ya se lee completo.

## 7. Checklist de cierre de funcionalidad

- Dominio, datos, inyeccion y presentacion en el orden fijo.
- Proveedores tipados, sin mezcla de manual y generado en la feature.
- Vistas usando el catalogo, sin widgets crudos duplicados.
- Documentacion publica en espanol completa.
- Lineas dentro de ochenta columnas y salto final.
- Directivas ordenadas alfabeticamente.
- Pruebas de unidad de dominio y de logica de presentacion. La prueba de
  repositorio esta diferida por desviacion registrada.
- Pieza de catalogo nueva o tocada: prueba de render a ancho estrecho,
  porque el analizador no detecta desbordes.
- Pase visual en modo claro y oscuro como gate PREVIO al commit cuando la
  feature toca superficie: se ejecuta con la app recargada contra la lista
  de puntos de riesgo que el lead declara en la entrega, y todo defecto
  destapado se arregla antes de commitear, no despues. No se commitea
  superficie sin haberla visto en vivo.
- Commit atomico por naturaleza con mensaje descriptivo.
- Cierre documental: un commit que sube version, escribe changelog,
  actualiza este informe e intentions, y etiqueta. Antes de abrir la
  siguiente feature.

## 8. Ritual de puerta de calidad

- Generador solo cuando el cambio toca fuentes anotadas, clases con partes
  generadas o el manifiesto. En el resto, analisis mas pruebas.
- Analisis filtrado al perimetro tocado, sin severity ocho nuevo. Los
  avisos previos de otros frentes no bloquean, se anotan como deuda de su
  frente. La linea base del perimetro se mide antes de afirmar que esta
  vacio.
- Pruebas en verde.
- Guardia de estado antes de cada commit: solo las rutas esperadas.
- Mensaje en archivo temporal UTF8 sin BOM, commit limitado por rutas,
  borrado del temporal, estado final vacio. Los archivos nuevos se
  preparan antes porque esa forma solo acepta rutas conocidas.
- Cada bloque de terminal declara su propia codificacion, ruta y mensaje.
- Toda prueba viva se reporta declarando el modo de recarga usado.

## 9. Versionado

Esquema SemVer previo a 1.0: 0.MINOR.PATCH. Minor por cierre de feature,
patch por correccion. 1.0.0 exige esquema de PocketBase congelado y las
features auditadas con pruebas.

Hito actual: 0.3.0, gestion de usuarios y flujo de aprobacion cerrados.
Hitos previos: 0.1.0 administracion, 0.2.0 equipos. El trabajo parcial de
auth, competidores y eventos de sesiones anteriores se pliega en el
changelog como historico sin etiquetas retroactivas.

Mecanismo: en el commit de cierre documental se sube la linea version del
manifiesto, se anade entrada en el changelog, se actualiza este informe e
intentions, y se crea etiqueta anotada. Un solo gesto ata docs y version.

Sufijo de prelanzamiento para estados no auditados que necesiten build:
0.X.0-rc.N.

## 10. Registro de metodo

Las correcciones de metodo del lead no se listan aqui. Viven en
`docs/intentions.md`, con su causa raiz y su contramedida, porque son
bitacora interna de proceso y no estado del producto. El patron recurrente
registrado es actuar sobre suposicion en vez de sobre evidencia leida, y
las contramedidas adoptadas son leer el contrato o el grafo antes de
escribir, medir la linea base antes de afirmar que un perimetro esta
limpio, entregar toda edicion con ancla unica, y probar cada contramedida
en sus dos casos antes de declararla estandar.