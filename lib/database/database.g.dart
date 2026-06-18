// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pIdMeta = const VerificationMeta('pId');
  @override
  late final GeneratedColumn<int> pId = GeneratedColumn<int>(
    'p_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pNameMeta = const VerificationMeta('pName');
  @override
  late final GeneratedColumn<String> pName = GeneratedColumn<String>(
    'p_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pClassMeta = const VerificationMeta('pClass');
  @override
  late final GeneratedColumn<String> pClass = GeneratedColumn<String>(
    'p_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pLevelMeta = const VerificationMeta('pLevel');
  @override
  late final GeneratedColumn<int> pLevel = GeneratedColumn<int>(
    'p_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pHitPointsMeta = const VerificationMeta(
    'pHitPoints',
  );
  @override
  late final GeneratedColumn<int> pHitPoints = GeneratedColumn<int>(
    'p_hit_points',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pArmorClassMeta = const VerificationMeta(
    'pArmorClass',
  );
  @override
  late final GeneratedColumn<int> pArmorClass = GeneratedColumn<int>(
    'p_armor_class',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pOriginalCampaignMeta = const VerificationMeta(
    'pOriginalCampaign',
  );
  @override
  late final GeneratedColumn<String> pOriginalCampaign =
      GeneratedColumn<String>(
        'p_original_campaign',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    pId,
    pName,
    pClass,
    pLevel,
    pHitPoints,
    pArmorClass,
    pOriginalCampaign,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('p_id')) {
      context.handle(
        _pIdMeta,
        pId.isAcceptableOrUnknown(data['p_id']!, _pIdMeta),
      );
    }
    if (data.containsKey('p_name')) {
      context.handle(
        _pNameMeta,
        pName.isAcceptableOrUnknown(data['p_name']!, _pNameMeta),
      );
    } else if (isInserting) {
      context.missing(_pNameMeta);
    }
    if (data.containsKey('p_class')) {
      context.handle(
        _pClassMeta,
        pClass.isAcceptableOrUnknown(data['p_class']!, _pClassMeta),
      );
    } else if (isInserting) {
      context.missing(_pClassMeta);
    }
    if (data.containsKey('p_level')) {
      context.handle(
        _pLevelMeta,
        pLevel.isAcceptableOrUnknown(data['p_level']!, _pLevelMeta),
      );
    }
    if (data.containsKey('p_hit_points')) {
      context.handle(
        _pHitPointsMeta,
        pHitPoints.isAcceptableOrUnknown(
          data['p_hit_points']!,
          _pHitPointsMeta,
        ),
      );
    }
    if (data.containsKey('p_armor_class')) {
      context.handle(
        _pArmorClassMeta,
        pArmorClass.isAcceptableOrUnknown(
          data['p_armor_class']!,
          _pArmorClassMeta,
        ),
      );
    }
    if (data.containsKey('p_original_campaign')) {
      context.handle(
        _pOriginalCampaignMeta,
        pOriginalCampaign.isAcceptableOrUnknown(
          data['p_original_campaign']!,
          _pOriginalCampaignMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pId};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      pId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p_id'],
      )!,
      pName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}p_name'],
      )!,
      pClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}p_class'],
      )!,
      pLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p_level'],
      ),
      pHitPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p_hit_points'],
      ),
      pArmorClass: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p_armor_class'],
      ),
      pOriginalCampaign: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}p_original_campaign'],
      ),
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final int pId;
  final String pName;
  final String pClass;
  final int? pLevel;
  final int? pHitPoints;
  final int? pArmorClass;
  final String? pOriginalCampaign;
  const Player({
    required this.pId,
    required this.pName,
    required this.pClass,
    this.pLevel,
    this.pHitPoints,
    this.pArmorClass,
    this.pOriginalCampaign,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['p_id'] = Variable<int>(pId);
    map['p_name'] = Variable<String>(pName);
    map['p_class'] = Variable<String>(pClass);
    if (!nullToAbsent || pLevel != null) {
      map['p_level'] = Variable<int>(pLevel);
    }
    if (!nullToAbsent || pHitPoints != null) {
      map['p_hit_points'] = Variable<int>(pHitPoints);
    }
    if (!nullToAbsent || pArmorClass != null) {
      map['p_armor_class'] = Variable<int>(pArmorClass);
    }
    if (!nullToAbsent || pOriginalCampaign != null) {
      map['p_original_campaign'] = Variable<String>(pOriginalCampaign);
    }
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      pId: Value(pId),
      pName: Value(pName),
      pClass: Value(pClass),
      pLevel: pLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(pLevel),
      pHitPoints: pHitPoints == null && nullToAbsent
          ? const Value.absent()
          : Value(pHitPoints),
      pArmorClass: pArmorClass == null && nullToAbsent
          ? const Value.absent()
          : Value(pArmorClass),
      pOriginalCampaign: pOriginalCampaign == null && nullToAbsent
          ? const Value.absent()
          : Value(pOriginalCampaign),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      pId: serializer.fromJson<int>(json['pId']),
      pName: serializer.fromJson<String>(json['pName']),
      pClass: serializer.fromJson<String>(json['pClass']),
      pLevel: serializer.fromJson<int?>(json['pLevel']),
      pHitPoints: serializer.fromJson<int?>(json['pHitPoints']),
      pArmorClass: serializer.fromJson<int?>(json['pArmorClass']),
      pOriginalCampaign: serializer.fromJson<String?>(
        json['pOriginalCampaign'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pId': serializer.toJson<int>(pId),
      'pName': serializer.toJson<String>(pName),
      'pClass': serializer.toJson<String>(pClass),
      'pLevel': serializer.toJson<int?>(pLevel),
      'pHitPoints': serializer.toJson<int?>(pHitPoints),
      'pArmorClass': serializer.toJson<int?>(pArmorClass),
      'pOriginalCampaign': serializer.toJson<String?>(pOriginalCampaign),
    };
  }

  Player copyWith({
    int? pId,
    String? pName,
    String? pClass,
    Value<int?> pLevel = const Value.absent(),
    Value<int?> pHitPoints = const Value.absent(),
    Value<int?> pArmorClass = const Value.absent(),
    Value<String?> pOriginalCampaign = const Value.absent(),
  }) => Player(
    pId: pId ?? this.pId,
    pName: pName ?? this.pName,
    pClass: pClass ?? this.pClass,
    pLevel: pLevel.present ? pLevel.value : this.pLevel,
    pHitPoints: pHitPoints.present ? pHitPoints.value : this.pHitPoints,
    pArmorClass: pArmorClass.present ? pArmorClass.value : this.pArmorClass,
    pOriginalCampaign: pOriginalCampaign.present
        ? pOriginalCampaign.value
        : this.pOriginalCampaign,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      pId: data.pId.present ? data.pId.value : this.pId,
      pName: data.pName.present ? data.pName.value : this.pName,
      pClass: data.pClass.present ? data.pClass.value : this.pClass,
      pLevel: data.pLevel.present ? data.pLevel.value : this.pLevel,
      pHitPoints: data.pHitPoints.present
          ? data.pHitPoints.value
          : this.pHitPoints,
      pArmorClass: data.pArmorClass.present
          ? data.pArmorClass.value
          : this.pArmorClass,
      pOriginalCampaign: data.pOriginalCampaign.present
          ? data.pOriginalCampaign.value
          : this.pOriginalCampaign,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('pId: $pId, ')
          ..write('pName: $pName, ')
          ..write('pClass: $pClass, ')
          ..write('pLevel: $pLevel, ')
          ..write('pHitPoints: $pHitPoints, ')
          ..write('pArmorClass: $pArmorClass, ')
          ..write('pOriginalCampaign: $pOriginalCampaign')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    pId,
    pName,
    pClass,
    pLevel,
    pHitPoints,
    pArmorClass,
    pOriginalCampaign,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.pId == this.pId &&
          other.pName == this.pName &&
          other.pClass == this.pClass &&
          other.pLevel == this.pLevel &&
          other.pHitPoints == this.pHitPoints &&
          other.pArmorClass == this.pArmorClass &&
          other.pOriginalCampaign == this.pOriginalCampaign);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> pId;
  final Value<String> pName;
  final Value<String> pClass;
  final Value<int?> pLevel;
  final Value<int?> pHitPoints;
  final Value<int?> pArmorClass;
  final Value<String?> pOriginalCampaign;
  const PlayersCompanion({
    this.pId = const Value.absent(),
    this.pName = const Value.absent(),
    this.pClass = const Value.absent(),
    this.pLevel = const Value.absent(),
    this.pHitPoints = const Value.absent(),
    this.pArmorClass = const Value.absent(),
    this.pOriginalCampaign = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.pId = const Value.absent(),
    required String pName,
    required String pClass,
    this.pLevel = const Value.absent(),
    this.pHitPoints = const Value.absent(),
    this.pArmorClass = const Value.absent(),
    this.pOriginalCampaign = const Value.absent(),
  }) : pName = Value(pName),
       pClass = Value(pClass);
  static Insertable<Player> custom({
    Expression<int>? pId,
    Expression<String>? pName,
    Expression<String>? pClass,
    Expression<int>? pLevel,
    Expression<int>? pHitPoints,
    Expression<int>? pArmorClass,
    Expression<String>? pOriginalCampaign,
  }) {
    return RawValuesInsertable({
      if (pId != null) 'p_id': pId,
      if (pName != null) 'p_name': pName,
      if (pClass != null) 'p_class': pClass,
      if (pLevel != null) 'p_level': pLevel,
      if (pHitPoints != null) 'p_hit_points': pHitPoints,
      if (pArmorClass != null) 'p_armor_class': pArmorClass,
      if (pOriginalCampaign != null) 'p_original_campaign': pOriginalCampaign,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? pId,
    Value<String>? pName,
    Value<String>? pClass,
    Value<int?>? pLevel,
    Value<int?>? pHitPoints,
    Value<int?>? pArmorClass,
    Value<String?>? pOriginalCampaign,
  }) {
    return PlayersCompanion(
      pId: pId ?? this.pId,
      pName: pName ?? this.pName,
      pClass: pClass ?? this.pClass,
      pLevel: pLevel ?? this.pLevel,
      pHitPoints: pHitPoints ?? this.pHitPoints,
      pArmorClass: pArmorClass ?? this.pArmorClass,
      pOriginalCampaign: pOriginalCampaign ?? this.pOriginalCampaign,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pId.present) {
      map['p_id'] = Variable<int>(pId.value);
    }
    if (pName.present) {
      map['p_name'] = Variable<String>(pName.value);
    }
    if (pClass.present) {
      map['p_class'] = Variable<String>(pClass.value);
    }
    if (pLevel.present) {
      map['p_level'] = Variable<int>(pLevel.value);
    }
    if (pHitPoints.present) {
      map['p_hit_points'] = Variable<int>(pHitPoints.value);
    }
    if (pArmorClass.present) {
      map['p_armor_class'] = Variable<int>(pArmorClass.value);
    }
    if (pOriginalCampaign.present) {
      map['p_original_campaign'] = Variable<String>(pOriginalCampaign.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('pId: $pId, ')
          ..write('pName: $pName, ')
          ..write('pClass: $pClass, ')
          ..write('pLevel: $pLevel, ')
          ..write('pHitPoints: $pHitPoints, ')
          ..write('pArmorClass: $pArmorClass, ')
          ..write('pOriginalCampaign: $pOriginalCampaign')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayersTable players = $PlayersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [players];
}

typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> pId,
      required String pName,
      required String pClass,
      Value<int?> pLevel,
      Value<int?> pHitPoints,
      Value<int?> pArmorClass,
      Value<String?> pOriginalCampaign,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> pId,
      Value<String> pName,
      Value<String> pClass,
      Value<int?> pLevel,
      Value<int?> pHitPoints,
      Value<int?> pArmorClass,
      Value<String?> pOriginalCampaign,
    });

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get pId => $composableBuilder(
    column: $table.pId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pName => $composableBuilder(
    column: $table.pName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pClass => $composableBuilder(
    column: $table.pClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pLevel => $composableBuilder(
    column: $table.pLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pHitPoints => $composableBuilder(
    column: $table.pHitPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pArmorClass => $composableBuilder(
    column: $table.pArmorClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pOriginalCampaign => $composableBuilder(
    column: $table.pOriginalCampaign,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get pId => $composableBuilder(
    column: $table.pId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pName => $composableBuilder(
    column: $table.pName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pClass => $composableBuilder(
    column: $table.pClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pLevel => $composableBuilder(
    column: $table.pLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pHitPoints => $composableBuilder(
    column: $table.pHitPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pArmorClass => $composableBuilder(
    column: $table.pArmorClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pOriginalCampaign => $composableBuilder(
    column: $table.pOriginalCampaign,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get pId =>
      $composableBuilder(column: $table.pId, builder: (column) => column);

  GeneratedColumn<String> get pName =>
      $composableBuilder(column: $table.pName, builder: (column) => column);

  GeneratedColumn<String> get pClass =>
      $composableBuilder(column: $table.pClass, builder: (column) => column);

  GeneratedColumn<int> get pLevel =>
      $composableBuilder(column: $table.pLevel, builder: (column) => column);

  GeneratedColumn<int> get pHitPoints => $composableBuilder(
    column: $table.pHitPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pArmorClass => $composableBuilder(
    column: $table.pArmorClass,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pOriginalCampaign => $composableBuilder(
    column: $table.pOriginalCampaign,
    builder: (column) => column,
  );
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, BaseReferences<_$AppDatabase, $PlayersTable, Player>),
          Player,
          PrefetchHooks Function()
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> pId = const Value.absent(),
                Value<String> pName = const Value.absent(),
                Value<String> pClass = const Value.absent(),
                Value<int?> pLevel = const Value.absent(),
                Value<int?> pHitPoints = const Value.absent(),
                Value<int?> pArmorClass = const Value.absent(),
                Value<String?> pOriginalCampaign = const Value.absent(),
              }) => PlayersCompanion(
                pId: pId,
                pName: pName,
                pClass: pClass,
                pLevel: pLevel,
                pHitPoints: pHitPoints,
                pArmorClass: pArmorClass,
                pOriginalCampaign: pOriginalCampaign,
              ),
          createCompanionCallback:
              ({
                Value<int> pId = const Value.absent(),
                required String pName,
                required String pClass,
                Value<int?> pLevel = const Value.absent(),
                Value<int?> pHitPoints = const Value.absent(),
                Value<int?> pArmorClass = const Value.absent(),
                Value<String?> pOriginalCampaign = const Value.absent(),
              }) => PlayersCompanion.insert(
                pId: pId,
                pName: pName,
                pClass: pClass,
                pLevel: pLevel,
                pHitPoints: pHitPoints,
                pArmorClass: pArmorClass,
                pOriginalCampaign: pOriginalCampaign,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, BaseReferences<_$AppDatabase, $PlayersTable, Player>),
      Player,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
}
