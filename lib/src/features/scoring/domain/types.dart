/// Tipos de jurado según Código FIG
enum JuryType {
  difficulty('D', 'Dificultad'),
  execution('E', 'Ejecución'),
  artistry('A', 'Arte');

  final String code;
  final String label;

  const JuryType(this.code, this.label);

  factory JuryType.fromCode(String code) {
    return values.firstWhere(
      (e) => e.code == code.toUpperCase(),
      orElse: () => JuryType.difficulty,
    );
  }
}

/// Estado de una calificación
enum ScoreStatus {
  pending('Pendiente'),
  validated('Validada'),
  rejected('Rechazada');

  final String label;

  const ScoreStatus(this.label);
}

/// Tipos de deducciones según Código FIG
enum DeductionType {
  fall('Caída', 1),
  outOfBounds('Fuera de pista', 0.3),
  time('Tiempo', 0.3),
  sync('Sincronización', 0.3),
  attire('Vestimenta', 0.3),
  music('Música', 0.3),
  other('Otro', 0);

  final String label;
  final double defaultValue;

  const DeductionType(this.label, this.defaultValue);
}