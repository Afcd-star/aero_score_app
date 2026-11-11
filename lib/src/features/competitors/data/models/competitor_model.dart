// lib/src/features/competitors/data/models/competitor_model.dart
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';

/// Modelo de datos para transferir competidores entre PocketBase y dominio.
class CompetitorModel extends CompetitorEntity {
  /// Crea un modelo con los valores del competidor.
  const CompetitorModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.nationalId,
    required super.sex,
    required super.academicYear,
    required super.category,
    super.solapin,
    super.teamId,
    super.teamName,
    super.status,
    super.created,
    super.updated,
  });

  /// Construye un modelo desde una entidad de dominio.
  factory CompetitorModel.fromEntity(CompetitorEntity entity) {
    return CompetitorModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      nationalId: entity.nationalId,
      solapin: entity.solapin,
      sex: entity.sex,
      academicYear: entity.academicYear,
      category: entity.category,
      teamId: entity.teamId,
      teamName: entity.teamName,
      status: entity.status,
    );
  }

  /// Construye un modelo desde un mapa dinámico de PocketBase.
  factory CompetitorModel.fromMap(Map<String, dynamic> map) {
    final expand = _readMap(map, 'expand');
    final team =
        expand == null ? null : _readMap(expand, 'teamId');
    String? teamName;

    if (team != null) {
      teamName =
          _readNullableString(team, 'nombre') ??
          _readNullableString(team, 'name');

      if (teamName == null) {
        final first = _readNullableString(team, 'firstName');
        final last = _readNullableString(team, 'lastName');

        if (first != null) {
          final composed = '$first ${last ?? ''}'.trim();
          teamName = composed.isEmpty ? null : composed;
        }
      }
    }

    final combinedName = _readNullableString(
      map,
      'nombreApellidos',
    );
    var firstName =
        _readNullableString(map, 'firstName') ??
        _readNullableString(map, 'nombre') ??
        '';
    var lastName =
        _readNullableString(map, 'lastName') ??
        _readNullableString(map, 'apellido') ??
        '';

    if (combinedName != null) {
      final parts = combinedName
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty)
          .toList();

      if (firstName.isEmpty && parts.isNotEmpty) {
        firstName = parts.first;
      }

      if (lastName.isEmpty && parts.length > 1) {
        lastName = parts.skip(1).join(' ');
      }
    }

    return CompetitorModel(
      id: _readString(map, 'id'),
      firstName: firstName,
      lastName: lastName,
      nationalId: _readString(map, 'nationalId'),
      solapin: _readNullableString(map, 'solapin'),
      sex: _parseSex(_readNullableString(map, 'sex')),
      academicYear: _readInt(
        map,
        'academicYear',
        fallback: 1,
      ),
      category: _parseCategory(_readNullableString(map, 'category')),
      teamId: _readNullableString(map, 'teamId'),
      teamName: teamName,
      status: _parseStatus(_readNullableString(map, 'status')),
      created: _readDate(_readNullableString(map, 'created')),
      updated: _readDate(_readNullableString(map, 'updated')),
    );
  }

  /// Convierte el modelo a un mapa para PocketBase.
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nationalId': nationalId,
      'solapin': solapin,
      'sex': sexValue(sex),
      'academicYear': academicYear,
      'category': categoryValue(category),
      'teamId': teamId,
      'teamName': teamName,
      'status': statusValue(status),
    };
  }

  /// Convierte el modelo a una entidad de dominio.
  CompetitorEntity toEntity() {
    return CompetitorEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      nationalId: nationalId,
      solapin: solapin,
      sex: sex,
      academicYear: academicYear,
      category: category,
      teamId: teamId,
      teamName: teamName,
      status: status,
    );
  }

  /// Devuelve el valor persistente del sexo.
  static String sexValue(CompetitorSex sex) {
    return switch (sex) {
      CompetitorSex.masculine => 'masculino',
      CompetitorSex.feminine => 'femenino',
    };
  }

  /// Devuelve el valor persistente de la categoría.
  static String categoryValue(CompetitorCategory category) {
    return switch (category) {
      CompetitorCategory.soloM => 'solo\u002Dm',
      CompetitorCategory.soloF => 'solo\u002Df',
      CompetitorCategory.duoMixto => 'duo\u002Dmixto',
      CompetitorCategory.trio => 'trio',
      CompetitorCategory.quinteto => 'quinteto',
    };
  }

  /// Devuelve el valor persistente del estado.
  static String statusValue(CompetitorStatus status) {
    return status.name;
  }

  static String _readString(
    Map<String, dynamic> map,
    String key, {
    String fallback = '',
  }) {
    final value = _readNullableString(map, key);
    return value ?? fallback;
  }

  static String? _readNullableString(
    Map<String, dynamic> map,
    String key,
  ) {
    final Object? value = map[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  static Map<String, dynamic>? _readMap(
    Map<String, dynamic> map,
    String key,
  ) {
    final Object? value = map[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  static int _readInt(
    Map<String, dynamic> map,
    String key, {
    required int fallback,
  }) {
    final Object? value = map[key];

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  static DateTime? _readDate(String? value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  static CompetitorSex _parseSex(String? value) {
    final normalized = value?.toLowerCase() ?? 'masculine';

    return switch (normalized) {
      'masculino' || 'masculine' => CompetitorSex.masculine,
      'femenino' || 'feminine' => CompetitorSex.feminine,
      _ => CompetitorSex.masculine,
    };
  }

  static CompetitorCategory _parseCategory(String? value) {
    final normalized = value?.toLowerCase() ?? 'solo\u002Dm';

    return switch (normalized) {
      'solo\u002Dm' || 'solom' => CompetitorCategory.soloM,
      'solo\u002Df' || 'solof' => CompetitorCategory.soloF,
      'duo\u002Dmixto' || 'duomixto' => CompetitorCategory.duoMixto,
      'trio' => CompetitorCategory.trio,
      'quinteto' => CompetitorCategory.quinteto,
      _ => CompetitorCategory.soloM,
    };
  }

  static CompetitorStatus _parseStatus(String? value) {
    final normalized = value?.toLowerCase() ?? 'active';

    return switch (normalized) {
      'activo' || 'active' => CompetitorStatus.active,
      'inactivo' || 'inactive' => CompetitorStatus.inactive,
      'suspendido' || 'suspended' => CompetitorStatus.suspended,
      _ => CompetitorStatus.active,
    };
  }
}
