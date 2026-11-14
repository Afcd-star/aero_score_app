# Changelog de AeroScore

Formato basado en Keep a Changelog y SemVer. Previo a 1.0 se usa
0.MINOR.PATCH, con minor por cierre de funcionalidad.

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