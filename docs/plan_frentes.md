# Plan de frentes restantes

Estado verificado al abrir este plan.
- HEAD: 1437fdf (casco oscuro fijo con lavados radiales y acoplamiento).
- Arbol de trabajo: limpio.
- Base estable medida: 63 errores, 4 avisos, 685 informaciones, 81 pruebas verdes.
- Cifras del README desactualizadas (declara 66, 79, 880). Se corrigen en F6,
  no ahora, porque los frentes van a moverlas otra vez.

## Principios de orden
1. Cerrar lo abierto del frente de fondo ya commiteado.
2. UX viva reportada por el autor, con el què (mensajes) antes del cuàndo
   (hìbrido de validaciòn).
3. Arranque (splash), que mata el negro nativo.
4. Higiene de catàlogo (descableado y piezas muertas), divida en subfrentes.
5. Documentaciòn del catàlogo final (cierre de shared con versiòn y etiqueta).
6. Arquitectura no bloqueante (deuda de raìz del README).
7. Lanzamiento bloqueante (frente de Android), el màs grande y con
   precondiciones de backend.

Regla transversal: ningùn frente se commitea sin su puerta. Los frentes de
superficie exigen gate de ojo; los de forma se verifican por nùmero; los
documentales no exigen ojo. Cada frente declara su precondiciòn de lectura:
si el lead no ha leìdo el archivo, pide el archivo antes de anclar
sustituciones. Prohibido anclar contra `widgets_usage.md`, que es corpus
viejo con grupos movidos y deuda de contraste ya corregida.

## Tabla de frentes en orden

| # | Frente | Naturaleza | Puerta | Precondiciòn de lectura |
|---|--------|-----------|--------|------------------------|
| F1 | Regla de dos niveles de fondo y correcciòn de la guìa de widgets | Documental | Sin ojo | Leer la guìa real del catàlogo (no el corpus viejo) |
| F2 | Coherencia de mensajes: catàlogo con plantilla fija y punto ùnico de validaciòn | Forma y lògica | Ojo parcial (los textos se ven) | Leer las vistas con validadores y los diàlogos de alerta |
| F3 | Hìbrido de validaciòn: callar hasta el primer desenfoque y validar en vivo al corregir | Superficie | Ojo propagado a todos los formularios | Leer `aero_select.dart` y el tàrea de màs de una lìnea |
| F4 | Splash nativa con `flutter_native_splash` | Superficie y nativo | Parada completa en dispositivo | Decidir arte: procedural vectorial o raster regenerado a resoluciòn |
| F5 | Descableado y piezas muertas, en tres subfrentes | Mixto | Ojo y prueba de render | Leer tema, input, botòn, selector, enrutador y formulario de equipo |
| F6 | Cierre documental de shared con versiòn y etiqueta | Documental | Sin ojo | Estado final del catàlogo tras F5 |
| F7 | Deuda de arquitectura no bloqueante | Forma | Sin ojo o nùmero | Leer entidad de usuario, modelo, enrutador, filtro y tarjeta |
| F8 | Lanzamiento Android bloqueante | Nativo y backend | Dispositivo fìsico | Precondiciones de backend que hoy no existen |

## Desglose de subfrentes

### F5a Descableado de catàlogo
- Colores cableados del tema fuera de la paleta (literales hex y blancos/negros
  con alfa en `app_theme.dart`).
- Borde fucsia a nivel de botòn elevado en el tema, causa del aspecto viejo de
  botòn blanco con canto fucsia.
- Relleno y radio de la decoraciòn de entrada que no coinciden con los de la
  pieza del catàlogo (radio 12 contra 10, relleno de esquema contra token).
- Blanco cableado y tipografìa cruda del selector de tema, y pares duplicados
  de icono y etiqueta.
- Modo solo icono del botòn en 44, con grep de consumidores y prueba de render.

### F5b Descableado de vistas
- Variante primaria indebida del formulario de equipo (agregar competidores
  primary cuando debe ser contorno, como agregar equipos del evento).
- Texto crudo del Material en las rutas de entrenador y organizador del
  enrutador.
- Botòn crudo con icono rojo fijo en el constructor de error del enrutador.

### F5c Piezas muertas
- Borde muerto del botòn primario (ya registrado).
- Marcador sin efecto del botòn.
- Imagen reservada del avatar.
- Escape de filtro de competidores pendiente de adoptar (README).
Cada pieza con grep de consumidores y prueba de render a ancho estrecho. Si el
grep no da consumidores, se retira; si los da, se arregla el uso.

## Deuda del README clasificada (para no perderla)

No bloqueante, va en F7:
- Enumerado de estado de cuenta, para retirar literales sueltos de entidad,
  modelo, enrutador, filtro y tarjeta.
- `AppEnvironment` como segunda fuente de verdad de entorno frente al define
  de compilaciòn.
- Notifiers de estado de interfaz alojados en data di, violaciòn de direcciòn
  de dependencia.
- Log de auditorìa inexistente en el backend; actividad reciente usa heurìstica
  de marcas de tiempo.
- Registro de rol desconocido solo de depuraciòn.
- Prueba de widget del guard de alcance del lote, diferida.
- Repositorios sin prueba por cliente no inyectable.
- Aviso de build_runner clavado por la cadena de riverpod_lint.

Bloqueante, va en F8:
- Manifiesto principal de Android sin permiso de red.
- URL de producciòn del entorno como marcador.
- Rutas de puntuaciòn apuntando a pantalla sin construir.
- Espectador sin destino propio, hoy acaba en cuenta pendiente, que le miente.
- Guard de rutas por prefijo, no por permisos dinàmicos de la colecciòn Roles.
- Sincronizaciòn sin conexiòn no iniciada, con precondiciòn de backend: una
  colecciòn de cola o de estado que hoy no està en ninguna migraciòn.

## Notas de riesgo del plan
- F4 tiene un bloqueador real: no hay arte de arranque en disco. La decisiòn
  procedural versus raster se toma con el autor antes de escribir còdigo.
- F5 sin dividir es inauditable; los tres subfrentes commitean por separado.
- F8 depende de backend que no existe en este repo; no se puede cerrar solo
  desde el lado Flutter.
- El cierre F6 documenta el catàlogo final; si F5 cambia despuès de F6, F6 se
  reabre. Por eso F6 va al final del eje de catàlogo.