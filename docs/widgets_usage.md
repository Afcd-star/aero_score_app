**Análisis Crítico**
Tienes ~53 widgets personalizados pero sin una guía clara de uso. Esto genera inconsistencia: desarrolladores usando `AeroCard` donde debería ir `AeroSheet`, o `AeroDialog` donde `AeroAlertDialog` es más apropiado. Sin criterios de selección, tu sistema de diseño se vuelve impredecible y la UX inconsistente.

**Recomendación Técnica**
Proporciono guía práctica de uso por contexto. Cada widget resuelve un problema específico de UI/UX.

**Guía de Uso por Escenario**

### 📝 **FORMULARIOS E INPUTS**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_select.dart** | Cuando necesitas un dropdown simple (sin búsqueda) | Seleccionar categoría (Solo M, Solo F, Dúo Mixto) |
| **aero_checkbox.dart** | Opciones binarias independientes | "¿Acepta términos?", "Notificarme resultados" |
| **aero_radio_group.dart** | Selección única entre 2+ opciones | Sexo (Masculino/Femenino), Estado (Activo/Inactivo) |
| **aero_switch.dart** | Toggle on/off inmediato | Activar/desactivar notificaciones, modo oscuro |
| **aero_toggle.dart** | Alternar entre 2 estados | Vista lista/grid, mostrar/ocultar contraseña |
| **aero_toggle_group.dart** | Múltiples toggles relacionados | Filtros: "Activos", "Pendientes", "Completados" |
| **aero_otp_input.dart** | Códigos de verificación | Confirmar email, 2FA, recuperación de contraseña |
| **aero_textarea.dart** | Texto largo multilínea | Observaciones del jurado, descripción del evento |
| **aero_slider.dart** | Seleccionar valor en rango | Calificación 0-10, ajustar volumen, precio mínimo/máximo |

### 🎨 **LAYOUT Y ESTRUCTURA**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_aspect_ratio.dart** | Mantener proporción fija | Cards de competidores (16:9), avatares (1:1) |
| **aero_separator.dart** | Dividir secciones visualmente | Entre items de lista, después de headers |
| **aero_resizable.dart** | Usuario ajusta tamaño | Panel de calificaciones, consola de logs |
| **aero_scroll_area.dart** | Scroll con estilos personalizados | Lista larga de competidores, historial de eventos |
| **aero_collapsible.dart** | Expandir/colapsar 1 sección | Detalles adicionales de competidor, FAQ simple |
| **aero_accordion.dart** | Múltiples secciones expandibles | Configuración por categorías (Cuenta, Notificaciones, Privacidad) |

### 🔘 **BOTONES Y ACCIONES**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_command.dart** | Acción con atajo de teclado | "Guardar (Ctrl+S)", "Buscar (Ctrl+F)" |

### 📊 **VISUALIZACIÓN DE DATOS**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_table.dart** | Datos tabulares con sorting | Ranking de competidores, resultados por jurado |
| **aero_avatar.dart** | Representación visual de usuario/equipo | Lista de competidores, perfil de usuario |
| **aero_badge.dart** | Etiquetas pequeñas de estado/rol | "Activo", "Admin", "Judge D", "Pendiente" |
| **aero_skeleton.dart** | Placeholder mientras carga | Durante fetch de competidores, mientras carga perfil |
| **aero_progress.dart** | Mostrar progreso | Upload de planilla, cálculo de puntuaciones, login |

### 📂 **NAVEGACIÓN Y MENÚS**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_drawer.dart** | Navegación lateral en móvil | Menú principal en smartphones |
| **aero_menubar.dart** | Menú estilo desktop (top bar) | File, Edit, View en versión tablet/desktop |
| **aero_context_menu.dart** | Menú right-click | Opciones sobre competidor (Editar, Eliminar, Ver) |
| **aero_breadcrumb.dart** | Navegación jerárquica | Home > Eventos > Evento 2024 > Resultados |

### 🪟 **DIÁLOGOS Y OVERLAYS**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_dialog.dart** | Diálogo personalizado genérico | Configuración avanzada, preview de PDF |
| **aero_alert_dialog.dart** | Alertas críticas | "¿Eliminar competidor?", "Error de conexión" |
| **aero_alert_banner.dart** | Notificaciones persistentes | "Mantenimiento programado", "Nueva versión disponible" |
| **aero_popover.dart** | Info emergente al click | Detalles rápidos de competidor sin navegar |
| **aero_hover_card.dart** | Preview al hacer hover | Vista previa de evento al pasar mouse |
| **aero_sheet.dart** | Bottom sheet (mobile) | Filtros de búsqueda, seleccionar fecha, acciones rápidas |
| **aero_tooltip.dart** | Info rápida al hover | Explicación de campo, atajo de teclado |
| **aero_toast.dart** | Notificación temporal | "Guardado exitoso", "Error al cargar", "Sesión expirada" |

### 📅 **CALENDARIO Y FECHA**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_calendar.dart** | Seleccionar fecha/rango | Programar evento, seleccionar fecha de competencia |
| **aero_pagination.dart** | Navegar páginas de datos | Tabla de 100 competidores (10 por página) |

### 🎡 **COMPONENTES INTERACTIVOS**

| Widget | Cuándo usarlo | Ejemplo concreto |
|--------|---------------|------------------|
| **aero_carousel.dart** | Galería deslizable | Fotos del evento, logos de patrocinadores |
| **aero_tabs.dart** | Cambiar entre vistas | Pestañas: "Dificultad", "Ejecución", "Arte" |

---

**Ejemplos de Combinaciones Comunes**

1. **Formulario de Competidor:**
   - `AeroInput` (nombre, email)
   - `AeroSelect` (categoría, facultad)
   - `AeroRadioGroup` (sexo)
   - `AeroCheckbox` (acepta términos)
   - `AeroButton` (guardar)
   - `AeroCard` (contenedor)

2. **Dashboard de Resultados:**
   - `AeroTable` (ranking)
   - `AeroBadge` (estado, rol)
   - `AeroAvatar` (competidor)
   - `AeroPagination` (navegación)
   - `AeroTabs` (por categoría)
   - `AeroProgress` (carga inicial)

3. **Configuración de Usuario:**
   - `AeroAccordion` (secciones: Cuenta, Notificaciones, Privacidad)
   - `AeroSwitch` (activar/desactivar notificaciones)
   - `AeroInput` (cambiar email, contraseña)
   - `AeroButton` (guardar cambios)

**Próximos Pasos**
1. **Crea documentación** en `docs/widgets_usage.md` con esta guía.
2. **Añade ejemplos** en `example/` o `lib/examples/` mostrando cada widget en contexto.
3. **Implementa Storybook** o herramienta similar para visualizar widgets aislados.
4. **Establece reglas**: "Si necesitas X, usa Y widget" para mantener consistencia.

¿Necesitas que profundice en algún widget específico o que te muestre código de ejemplo para alguno?