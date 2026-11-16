# Changelog de AeroScore

Formato basado en Keep a Changelog y SemVer. Previo a 1.0 se usa
0.MINOR.PATCH, con minor por cierre de funcionalidad.

## 0.2.0 - Equipos cerrada

### Anadido
- Utilitario de escape de filtros de PocketBase en core, con siete
  pruebas, adoptado por equipos y pendiente en competidores y eventos.
- Suite de pruebas de equipos: veintidos casos de entidad y de los
  notifiers de lista y formulario, con doble del contrato hecho a mano.
- Anotacion de inmutabilidad en la entidad, con meta declarado como
  dependencia directa del manifiesto.
- Registro de casos borde de disponibilidad, correccion de vocabulario
  a puntuacion y orden de frentes por direccion de dependencia.

### Cambiado
- Validacion de negocio unificada en la entidad, que exige la relacion
  del entrenador y al menos un competidor.
- Igualdad sobre campos de contenido, excluyendo la proyeccion del
  entrenador y las marcas de tiempo.
- Modelo tipado contra el esquema vivo, con marca de actualizacion y
  sin enviar campos que no son columnas.
- Repositorio sin comprobacion de rol en cliente, con clausulas de
  excepcion tipadas y valores de filtro escapados.
- Borrado logico coherente: la lista filtra inactivos en carga y
  recarga, asi que un equipo borrado no reaparece.
- Notifier de formulario sin error fantasma entre reintentos.
- Confirmacion del selector de entrenador deshabilitada sin seleccion.
- Forma completa de la feature: documentacion publica, ochenta columnas
  y formateador canonico.

### Corregido
- Inyeccion de filtro por interpolacion sin escapar en las consultas.
- Etiqueta de identificacion del selector de competidores, en ingles.
- Cabecera del contrato, que apuntaba a administracion.
- Trazas de depuracion con emojis en el selector de entrenador.

### Eliminado
- Selector de planilla, que recogia un archivo sin campo donde
  persistirlo. La funcionalidad vuelve como fase obligatoria.
- Comprobacion redundante de rol en el cliente, que el server ya
  garantiza por reglas de coleccion.
- Chequeos de negocio duplicados en el formulario.
## 0.1.0 - Administracion cerrada

### Anadido
- Suite de pruebas de administracion: veintiun casos en cinco archivos
  de dominio, datos y casos de uso, con doble hecho a mano.
- Catalogo tipografico completo con los quince roles de TextTheme.
- Configuracion de lanzamiento del editor con URL de backend por
  plataforma.
- Documento de intenciones con deudas de toolchain, cabeceras, layout y
  pase visual.

### Cambiado
- Repositorio de administracion podado a dos metodos y rehecho con el
  patron de inferencia del repositorio de competidores.
- Proveedor de administracion con cliente global inyectado que restaura
  la sesion, y AsyncValue que conserva el Failure tipado.
- Vista del panel con seccion derivada de la ruta, navegacion tipada
  desde el enum, cierre de sesion esperado y usuario protegido.
- Reglamento con datos tipados en lugar de mapas dinamicos.
- Tarjeta de roles, configuracion y gestion de roles legibles en modo
  claro y oscuro mediante el esquema de tema.

### Corregido
- Tres bloqueos reales de compilacion en los formularios de evento y
  equipo.
- Carga infinita de la gestion de roles por falta de disparo inicial,
  con espera de trescientos milisegundos en el buscador.
- Rol desconocido ofrecido como asignable.
- Asercion de ListTile y desborde de un pixel del panel.
- Subtitulo del reglamento invisible que desplazaba el titulo.
- Salto final en sesenta y ocho archivos del arbol.

### Eliminado
- Provider y header muertos del panel, probados por grep de consumidores
  vacio.
- Hojas de competidor y equipos, provider de coaches y gestion de roles
  reubicados a sus features, cerrando cinco dependencias invertidas.

### Historico sin etiqueta
- Saneamiento parcial de autenticacion, competidores y eventos en
  sesiones anteriores, plegado aqui sin etiquetas retroactivas porque no
  se planearon para etiquetar.