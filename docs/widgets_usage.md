# Guia de uso del catalogo de widgets

Estado de este documento: inventario verificado contra el arbol. La
version anterior describia unas cincuenta y tres piezas de las que solo
existian dieciocho, y sus referencias rotas llegaron a los comentarios de
documentacion del codigo. Esta version la sustituye.

Regla de firma: este documento dice que pieza usar y para que. La firma
exacta se lee en el archivo de la pieza antes de usarla. No se duplican
constructores aqui porque se desactualizan y esta guia ya fallo una vez
por describir lo que no existia.

Regla de decision: si una pieza del catalogo cubre la necesidad, se usa
la pieza. Si no la cubre, se extiende el catalogo antes de improvisar en
la vista. Y toda decision se contrasta con el arbol, no con este
documento.

## Inventario real, quince archivos

Este documento inventaria solo lo que vive en `shared`. Las piezas que
salieron por pertenencia se buscan en su feature: la tarjeta de
asignacion en auth, la accion rapida y la tarjeta de metrica del panel en
admin, y la tarjeta y la hoja de puntuacion en scoring.

Catalogo Aero, quince archivos:

- aero_alert_dialog: confirmacion de accion destructiva o error que
  exige decision. Fondo, borde y textos del esquema ambiental, asi que
  se lee en claro y en oscuro. Su titulo salta de linea, no se trunca,
  porque puede llevar un conteo de seguridad.
- aero_avatar: representacion visual de persona o equipo, con iniciales
  de reserva.
- aero_background: fondo decorativo de la casa, con variante de panel.
- aero_badge: etiqueta pequena de estado o rol, con variantes
  semanticas y tres tamanos. Sus variantes de estado usan tinte suave
  con texto saturado por modo, verificado por prueba de contraste
  calculado. La variante primaria conserva el fucsia de marca, cuyo
  contraste con blanco queda marginal y es deuda de marca abierta.
- aero_button: accion. Cinco variantes y tres tamanos, con modo solo
  icono y estado de carga. El primario toma el degradado de marca por
  defecto; el parametro de degradado explicito puede sobrescribirlo.
- aero_card: contenedor de superficie agrupada.
- aero_empty_state: ausencia de datos o busqueda sin resultado, con
  icono, titulo, mensaje opcional y accion opcional.
- aero_filter_bar: filtro de seleccion unica con desplazamiento
  horizontal y titulo opcional. Es controlada: el indice activo lo
  decide el consumidor, nunca el propio widget.
- aero_form: envoltorio de formulario con autovalidacion. Este archivo
  aloja dos piezas, el envoltorio y el par etiqueta y campo. El par
  muestra error externo opcional; el error interno del campo lo muestra
  el propio campo, no el envoltorio.
- aero_input: entrada de texto de una linea.
- aero_section_card: contenedor de seccion, con hijo, relleno y radio.
  Pieza generica de superficie, sin semantica de ningun modulo.
- aero_select: seleccion de una opcion en lista.
- aero_skeleton: marcador de carga con forma de contenido.
- aero_switch: interruptor de encendido y apagado.
- aero_textarea: entrada de texto multilinea.

El catalogo arrastra deuda de documentacion publica y de lineas largas,
mas tres errores de severidad ocho en el selector y el esqueleto. Se
resuelve en el frente de shared.

## Que falta crear, cuatro piezas con uso crudo probado

- Aviso temporal con su tema. Hoy los avisos usan el mecanismo crudo de
  la plataforma, salen con contraste pobre sobre la barra de navegacion
  y se pierden. Necesita tema propio y posicion decidida.
- Marcador de modulo. Los destinos de entrenador y organizador en el
  enrutador son texto centrado sin Scaffold, y el marcador de jurado es
  una vista temporal que esta pieza debe absorber.
- Indicador de progreso. Hay indicadores circulares crudos repetidos en
  selectores, listas y secciones.
- Hoja modal. El encabezado con degradado y el boton de cierre estan
  duplicados en tres hojas. Es la duplicacion mas clara del arbol.

## Que existe y falta adoptar

- Insignia para los chips de rol y estado hechos a mano. Sus tokens de
contraste ya estan corregidos y verificados por prueba numerica, asi que
la adopcion esta desbloqueada. El color de rol se enruta por parametro
custom, porque el rol es identidad con nueve colores propios, no
semantica de estado.
- Tarjeta para los contenedores crudos de listas y selectores.
- Avatar para los avatares crudos fuera de la tarjeta de usuario, que
  ya lo usa.
- Dialogo de alerta para el borrado de equipos, que hoy usa dialogo
  crudo. Ya se adopto en las transiciones de cuenta y en el lote.

## Diferidos hasta que su superficie exista

- Tabla y paginacion, para resultados de visitante.
- Deslizador, para captura de puntuacion.

No se crean antes de que exista la pantalla que los consume, porque
crear catalogo sin consumidor es codigo muerto con otro nombre.

## Rechazados para esta app

Barra de menus, migas de pan, menu contextual, tarjeta al pasar el raton,
popover, informacion al pasar el raton, redimensionable, proporcion
forzada, carrusel, area de scroll con estilo, comando con atajo,
acordeon, colapsable, grupo de radios, interruptor de dos estados,
entrada de codigo de verificacion, calendario y separador.

Razon: son de escritorio o de nicho sin superficie actual en esta app, o
duplican lo que Material ya resuelve con el esquema de tema. Crearlos
seria sobreingenieria y anadiria mantenimiento sin valor. Si una
superficie futura los necesita, se crean entonces con su consumidor
delante.

## Normas de uso

Toda pieza nueva o tocada viaja con prueba de render a ancho estrecho,
porque el analizador no detecta desbordes. El texto de etiqueta y de
accion es flexible y salta de linea, nunca se trunca, porque truncar el
rotulo de una accion deja al usuario sin saber que pulsa. Superficies y
textos salen del esquema de tema, no de constantes cableadas, para que
la pieza sea legible en claro y en oscuro. Y ninguna pieza guarda estado
que el consumidor deba conocer: si el consumidor tiene un notificador,
el indice o el valor activo vive ahi.