// lib/src/features/competitors/domain/entities/competitor_entity.dart
enum CompetitorSex { masculine, feminine }
enum CompetitorCategory { soloM, soloF, duoMixto, trio, quinteto }
enum CompetitorStatus { active, inactive, suspended }

class CompetitorEntity {

  const CompetitorEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.sex, required this.academicYear, required this.category, this.solapin,
    this.teamId,
    this.teamName,
    this.status = CompetitorStatus.active,
    this.created,
    this.updated,
  });
  final String id;
  final String firstName;
  final String lastName;
  final String nationalId;
  final String? solapin;
  final CompetitorSex sex;
  final int academicYear;
  final CompetitorCategory category;
  final String? teamId;
  final String? teamName;
  final CompetitorStatus status;
  final DateTime? created;
  final DateTime? updated;

  String get fullName => '$firstName $lastName'.trim();
  bool get isActive => status == CompetitorStatus.active;

  /// Label para UI (separado del dominio)
  String get categoryLabel => switch (category) {
    CompetitorCategory.soloM => 'Solo M',
    CompetitorCategory.soloF => 'Solo F',
    CompetitorCategory.duoMixto => 'Dúo Mixto',
    CompetitorCategory.trio => 'Trío',
    CompetitorCategory.quinteto => 'Quinteto',
  };

  String get sexLabel => switch (sex) {
    CompetitorSex.masculine => 'Masculino',
    CompetitorSex.feminine => 'Femenino',
  };

  /// Validaciones de negocio centralizadas
  String? validate() {
    if (firstName.trim().length < 2) return 'Nombre inválido';
    if (lastName.trim().length < 2) return 'Apellido inválido';
    if (!RegExp(r'^\d{11}$').hasMatch(nationalId)) {
      return 'CI debe tener 11 dígitos';
    }
    if (academicYear < 1 || academicYear > 6) return 'Año académico inválido';
    if (teamId != null && teamId!.isNotEmpty && teamId!.length < 15) {
      return 'ID de equipo inválido';
    }
    return null;
  }
}