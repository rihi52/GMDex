import 'package:drift/drift.dart';

part 'database.g.dart';

class Players extends Table {
  IntColumn get pId => integer().autoIncrement()();
  TextColumn get pName => text()();
  TextColumn get pClass => text()();
  IntColumn get pLevel => integer().nullable()();
  IntColumn get pHitPoints => integer().nullable()();
  IntColumn get pArmorClass => integer().nullable()();
  TextColumn get pOriginalCampaign => text().nullable()();
}

@DriftDatabase(tables: [Players])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
