import 'package:drift/drift.dart';

/// Databáze studijního balíčku (study.db, sestavuje tool/build_study_db.py).
///
/// Schéma vytváří Python skript; aplikace jen čte vlastními SQL dotazy,
/// proto databáze nedeklaruje žádné tabulky Driftu.
class StudyDatabase extends GeneratedDatabase {
  StudyDatabase(super.executor);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Soubor už obsahuje tabulky – nic nevytvářet ani nemigrovat.
    onCreate: (_) async {},
    onUpgrade: (_, _, _) async {},
  );
}
