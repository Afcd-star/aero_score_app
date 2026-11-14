**Estado: CERRADA con desviaciones. Ver la reconciliacion al pie de este documento y la seccion de administracion del informe tecnico.**
**Veredicto de frontera, archivo por archivo**

Grupo A, lo que SE QUEDA en admin como shell más dashboard, condicionado a las reparaciones de más abajo:

| Archivo | Veredicto | Condición |
| --- | --- | --- |
| `domain/types.dart` | Se queda, pero se PARTIDA | El enum `AdminSection` puro se queda en dominio; la extensión con `label`, `icon`, `pathName` sale a `presentation` porque `IconData` no pisa dominio |
| `domain/entities/admin_stats_entity.dart` | Se queda | Migrar a Freezed |
| `domain/entities/activity_item_entity.dart` | Se queda, pero se PARTIDA | Datos a Freezed en dominio; `actionLabel`, `entityTypeLabel`, `iconLabel` salen a `presentation` |
| `domain/repositories/admin_repository.dart` | Se queda, PODADO | Quitar `getUsersPendingApproval`, `updateUserRole` y `logout`; eso es de `auth`. El contrato de admin se reduce a `getDashboardStats` y `getRecentActivity` |
| `data/repositories/admin_repository_impl.dart` | Se queda, PODADO y REHECHO | Eliminar los métodos de usuarios y logout; el mapeo de `AdminStats` y `ActivityItem` pasa por DTO en `data/models`; la heurística de dos segundos se sustituye por contrato de log de auditoría (decisión de backend, ver más abajo) |
| `data/di/admin_providers.dart` | Se queda, REHECHO | Todo a anotaciones `@riverpod` de Riverpod 3.x, sin mezcla manual; `env` por `watch` del provider de entorno, no hardcodeado; los `FutureProvider` dejan de lanzar `Exception` desde el `fold` y propagan el `Failure` tipado; `SelectedTeamIdNotifier` sale hacia `teams` o `competitors` |
| `presentation/providers/admin_dashboard_provider.dart` | Se queda, REHECHO | `AdminDashboardState` a Freezed; eliminar `getStats` hardcodeado y `syncData` simulado; la sección activa pasa a SER del notifier, y la vista deja de usar `_activeSection` local con `setState` |
| `presentation/views/admin_dashboard_view.dart` | Se queda, REHECHO | `_menuItems` y `_bottomNavItems` dejan de ser `List<Map<String,dynamic>>` y se vuelven una clase `AdminNavItem` tipada o se derivan del enum ya partido; el `addPostFrameCallback` que llama `setState` se sustituye por sincronización derivada de la ruta; el header a mano se reemplaza por catálogo; `logout` se espera antes de navegar; el `user!` forzado se protege |
| `presentation/views/sections/home_section.dart` | Se queda | Ajustar líneas largas y documentar; sus imports de `shared/presentation/widgets/admin` quedan pero anoto esa carpeta como deuda de `shared` para auditar después |
| `presentation/views/sections/admin_dashboard_header.dart` | Se queda, REHECHO | Arreglar el contrato de claves contra `AdminStats` real; quitar el ternario idiota `isSyncing ? refresh : refresh`; el `TODOVINCULAR` fuera de estilo se convierte en nota interna o se cierra |

Grupo B, lo que SE VA de admin:

| Archivo | Destino | Motivo |
| --- | --- | --- |
| `presentation/providers/coach_provider.dart` | `auth` (o feature de jueces si existe) | Consulta `users` por rol; es proyección de usuarios, no admin. Además hay que reescribirlo con repo, DTO y `Either`, sin `pb` directo y sin `catch` pelado |
| `presentation/providers/role_management_provider.dart` | `auth` | Gestiona usuarios y roles vía `userRepositoryProvider`; es dominio de auth |
| `presentation/views/sections/role_management_section.dart` | `auth/presentation/views/sections` | El shell de admin la importará igual que importa `teams_section` |
| `presentation/views/sections/rules_section.dart` | feature `rules` nueva (o `shared/config` si jamás será editable) | Reglamento es contenido de competición, no shell ni dashboard; sus `Map<String,dynamic>` hay que tiparlos |
| `presentation/views/sections/settings_section.dart` | SE QUEDA en admin como shell, con reparo | Es una sección del panel como `home`; PERO deja de montar `RoleManagementSection` dentro (roles tiene su propia ruta), y su `logout` se arregla igual que en la vista |
| `presentation/widgets/competitor_form_sheet.dart` | `competitors/presentation/widgets` | Ya consume `competitors_providers` y `CompetitorEntity`; no pinta nada en admin |
| `presentation/widgets/competitor_list_view.dart` | `competitors/presentation/widgets` | Ya consume `competitorListProvider`; no pinta nada en admin |
| `presentation/widgets/team_competitors_sheet.dart` | `teams/presentation/widgets` | Consume `TeamEntity` y `competitorSelectionProvider`; es hoja de equipo, no de admin |

## Reconciliacion con la ejecucion, cierre 0.1.0

El veredicto anterior se cumplieron la mayoria de puntos. Cuatro
desviaciones registradas por honestidad de auditoria:

- Proyectadores de etiqueta de la entidad de actividad. El veredicto
  mandaba sacarlos a presentacion por dependencia de Flutter. No la
  tienen: son proyecciones de cadena puras. Se quedaron en dominio y
  estan cubiertos por pruebas. El veredicto estaba equivocado en la
  premisa.
- Heuristica de dos segundos. El veredicto mandaba sustituirla por
  contrato de log de auditoria. No existe coleccion de auditoria en el
  backend, asi que la heuristica sigue viva y registrada como deuda con
  precondicion. No se invento un contrato inexistente.
- Proveedores de administracion. El veredicto mandaba todo a anotaciones
  de Riverpod 3.x. Se entregaron manuales tipados por decision expresa
  para no mezclar manual y generado dentro de la feature; la migracion a
  anotaciones viaja en el frente de toolchain. Desviacion deliberada y
  registrada.
- Header del panel. El veredicto mandaba rehacerlo. Resulto codigo muerto
  con cero consumidores probados por grep, asi que se elimino en vez de
  reescribirse. Rehacerlo habria sido trabajo sobre codigo que nadie
  ejecuta.

No previsto por el veredicto y corregido en el ciclo:

- Los dos casos de uso del panel estaban mal alojados en auth
  importando entidades y contrato de administracion. Se reubicaron a
  administracion, cerrando una sexta dependencia invertida que el
  veredicto no listaba porque los archivos no estaban en admin.

Cumplidos sin desviacion: contrato podado a dos metodos, DTO de
actividad en data models, impl con patron de competidores, view con
navegacion tipada y seccion desde la ruta, home con forma y documentacion,
y todas las mudanzas del grupo B a sus features.