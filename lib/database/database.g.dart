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

class $LegendaryGroupsTable extends LegendaryGroups
    with TableInfo<$LegendaryGroupsTable, LegendaryGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegendaryGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, source, page];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legendary_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegendaryGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegendaryGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegendaryGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      ),
    );
  }

  @override
  $LegendaryGroupsTable createAlias(String alias) {
    return $LegendaryGroupsTable(attachedDatabase, alias);
  }
}

class LegendaryGroupRow extends DataClass
    implements Insertable<LegendaryGroupRow> {
  final int id;
  final String name;
  final String source;
  final int? page;
  const LegendaryGroupRow({
    required this.id,
    required this.name,
    required this.source,
    this.page,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || page != null) {
      map['page'] = Variable<int>(page);
    }
    return map;
  }

  LegendaryGroupsCompanion toCompanion(bool nullToAbsent) {
    return LegendaryGroupsCompanion(
      id: Value(id),
      name: Value(name),
      source: Value(source),
      page: page == null && nullToAbsent ? const Value.absent() : Value(page),
    );
  }

  factory LegendaryGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegendaryGroupRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      source: serializer.fromJson<String>(json['source']),
      page: serializer.fromJson<int?>(json['page']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'source': serializer.toJson<String>(source),
      'page': serializer.toJson<int?>(page),
    };
  }

  LegendaryGroupRow copyWith({
    int? id,
    String? name,
    String? source,
    Value<int?> page = const Value.absent(),
  }) => LegendaryGroupRow(
    id: id ?? this.id,
    name: name ?? this.name,
    source: source ?? this.source,
    page: page.present ? page.value : this.page,
  );
  LegendaryGroupRow copyWithCompanion(LegendaryGroupsCompanion data) {
    return LegendaryGroupRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      source: data.source.present ? data.source.value : this.source,
      page: data.page.present ? data.page.value : this.page,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegendaryGroupRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, source, page);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegendaryGroupRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.source == this.source &&
          other.page == this.page);
}

class LegendaryGroupsCompanion extends UpdateCompanion<LegendaryGroupRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> source;
  final Value<int?> page;
  const LegendaryGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.source = const Value.absent(),
    this.page = const Value.absent(),
  });
  LegendaryGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String source,
    this.page = const Value.absent(),
  }) : name = Value(name),
       source = Value(source);
  static Insertable<LegendaryGroupRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? source,
    Expression<int>? page,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (source != null) 'source': source,
      if (page != null) 'page': page,
    });
  }

  LegendaryGroupsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? source,
    Value<int?>? page,
  }) {
    return LegendaryGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      page: page ?? this.page,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegendaryGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }
}

class $CreaturesTable extends Creatures
    with TableInfo<$CreaturesTable, CreatureRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSrdMeta = const VerificationMeta('isSrd');
  @override
  late final GeneratedColumn<bool> isSrd = GeneratedColumn<bool>(
    'is_srd',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_srd" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
    'size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeTagsMeta = const VerificationMeta(
    'typeTags',
  );
  @override
  late final GeneratedColumn<String> typeTags = GeneratedColumn<String>(
    'type_tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alignmentMeta = const VerificationMeta(
    'alignment',
  );
  @override
  late final GeneratedColumn<String> alignment = GeneratedColumn<String>(
    'alignment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _armorClassMeta = const VerificationMeta(
    'armorClass',
  );
  @override
  late final GeneratedColumn<int> armorClass = GeneratedColumn<int>(
    'armor_class',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _armorClassTypeMeta = const VerificationMeta(
    'armorClassType',
  );
  @override
  late final GeneratedColumn<String> armorClassType = GeneratedColumn<String>(
    'armor_class_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _armorClassOtherMeta = const VerificationMeta(
    'armorClassOther',
  );
  @override
  late final GeneratedColumn<String> armorClassOther = GeneratedColumn<String>(
    'armor_class_other',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hitPointsMeta = const VerificationMeta(
    'hitPoints',
  );
  @override
  late final GeneratedColumn<int> hitPoints = GeneratedColumn<int>(
    'hit_points',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hitPointFormulaMeta = const VerificationMeta(
    'hitPointFormula',
  );
  @override
  late final GeneratedColumn<String> hitPointFormula = GeneratedColumn<String>(
    'hit_point_formula',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedWalkMeta = const VerificationMeta(
    'speedWalk',
  );
  @override
  late final GeneratedColumn<int> speedWalk = GeneratedColumn<int>(
    'speed_walk',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedFlyMeta = const VerificationMeta(
    'speedFly',
  );
  @override
  late final GeneratedColumn<int> speedFly = GeneratedColumn<int>(
    'speed_fly',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedSwimMeta = const VerificationMeta(
    'speedSwim',
  );
  @override
  late final GeneratedColumn<int> speedSwim = GeneratedColumn<int>(
    'speed_swim',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedClimbMeta = const VerificationMeta(
    'speedClimb',
  );
  @override
  late final GeneratedColumn<int> speedClimb = GeneratedColumn<int>(
    'speed_climb',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedBurrowMeta = const VerificationMeta(
    'speedBurrow',
  );
  @override
  late final GeneratedColumn<int> speedBurrow = GeneratedColumn<int>(
    'speed_burrow',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<int> strength = GeneratedColumn<int>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _dexterityMeta = const VerificationMeta(
    'dexterity',
  );
  @override
  late final GeneratedColumn<int> dexterity = GeneratedColumn<int>(
    'dexterity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _constitutionMeta = const VerificationMeta(
    'constitution',
  );
  @override
  late final GeneratedColumn<int> constitution = GeneratedColumn<int>(
    'constitution',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _intelligenceMeta = const VerificationMeta(
    'intelligence',
  );
  @override
  late final GeneratedColumn<int> intelligence = GeneratedColumn<int>(
    'intelligence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _wisdomMeta = const VerificationMeta('wisdom');
  @override
  late final GeneratedColumn<int> wisdom = GeneratedColumn<int>(
    'wisdom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _charismaMeta = const VerificationMeta(
    'charisma',
  );
  @override
  late final GeneratedColumn<int> charisma = GeneratedColumn<int>(
    'charisma',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _passivePerceptionMeta = const VerificationMeta(
    'passivePerception',
  );
  @override
  late final GeneratedColumn<int> passivePerception = GeneratedColumn<int>(
    'passive_perception',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _challengeRatingMeta = const VerificationMeta(
    'challengeRating',
  );
  @override
  late final GeneratedColumn<String> challengeRating = GeneratedColumn<String>(
    'challenge_rating',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _challengeRatingLairMeta =
      const VerificationMeta('challengeRatingLair');
  @override
  late final GeneratedColumn<String> challengeRatingLair =
      GeneratedColumn<String>(
        'challenge_rating_lair',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _challengeRatingCovenMeta =
      const VerificationMeta('challengeRatingCoven');
  @override
  late final GeneratedColumn<String> challengeRatingCoven =
      GeneratedColumn<String>(
        'challenge_rating_coven',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _xpOverrideMeta = const VerificationMeta(
    'xpOverride',
  );
  @override
  late final GeneratedColumn<int> xpOverride = GeneratedColumn<int>(
    'xp_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageVulnerabilitiesMeta =
      const VerificationMeta('damageVulnerabilities');
  @override
  late final GeneratedColumn<String> damageVulnerabilities =
      GeneratedColumn<String>(
        'damage_vulnerabilities',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _damageResistancesMeta = const VerificationMeta(
    'damageResistances',
  );
  @override
  late final GeneratedColumn<String> damageResistances =
      GeneratedColumn<String>(
        'damage_resistances',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _damageImmunitiesMeta = const VerificationMeta(
    'damageImmunities',
  );
  @override
  late final GeneratedColumn<String> damageImmunities = GeneratedColumn<String>(
    'damage_immunities',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionImmunitiesMeta =
      const VerificationMeta('conditionImmunities');
  @override
  late final GeneratedColumn<String> conditionImmunities =
      GeneratedColumn<String>(
        'condition_immunities',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _legendaryGroupIdMeta = const VerificationMeta(
    'legendaryGroupId',
  );
  @override
  late final GeneratedColumn<int> legendaryGroupId = GeneratedColumn<int>(
    'legendary_group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES legendary_groups (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    source,
    page,
    isSrd,
    size,
    type,
    typeTags,
    alignment,
    armorClass,
    armorClassType,
    armorClassOther,
    hitPoints,
    hitPointFormula,
    speedWalk,
    speedFly,
    speedSwim,
    speedClimb,
    speedBurrow,
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma,
    passivePerception,
    challengeRating,
    challengeRatingLair,
    challengeRatingCoven,
    xpOverride,
    damageVulnerabilities,
    damageResistances,
    damageImmunities,
    conditionImmunities,
    legendaryGroupId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    if (data.containsKey('is_srd')) {
      context.handle(
        _isSrdMeta,
        isSrd.isAcceptableOrUnknown(data['is_srd']!, _isSrdMeta),
      );
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('type_tags')) {
      context.handle(
        _typeTagsMeta,
        typeTags.isAcceptableOrUnknown(data['type_tags']!, _typeTagsMeta),
      );
    }
    if (data.containsKey('alignment')) {
      context.handle(
        _alignmentMeta,
        alignment.isAcceptableOrUnknown(data['alignment']!, _alignmentMeta),
      );
    }
    if (data.containsKey('armor_class')) {
      context.handle(
        _armorClassMeta,
        armorClass.isAcceptableOrUnknown(data['armor_class']!, _armorClassMeta),
      );
    }
    if (data.containsKey('armor_class_type')) {
      context.handle(
        _armorClassTypeMeta,
        armorClassType.isAcceptableOrUnknown(
          data['armor_class_type']!,
          _armorClassTypeMeta,
        ),
      );
    }
    if (data.containsKey('armor_class_other')) {
      context.handle(
        _armorClassOtherMeta,
        armorClassOther.isAcceptableOrUnknown(
          data['armor_class_other']!,
          _armorClassOtherMeta,
        ),
      );
    }
    if (data.containsKey('hit_points')) {
      context.handle(
        _hitPointsMeta,
        hitPoints.isAcceptableOrUnknown(data['hit_points']!, _hitPointsMeta),
      );
    }
    if (data.containsKey('hit_point_formula')) {
      context.handle(
        _hitPointFormulaMeta,
        hitPointFormula.isAcceptableOrUnknown(
          data['hit_point_formula']!,
          _hitPointFormulaMeta,
        ),
      );
    }
    if (data.containsKey('speed_walk')) {
      context.handle(
        _speedWalkMeta,
        speedWalk.isAcceptableOrUnknown(data['speed_walk']!, _speedWalkMeta),
      );
    }
    if (data.containsKey('speed_fly')) {
      context.handle(
        _speedFlyMeta,
        speedFly.isAcceptableOrUnknown(data['speed_fly']!, _speedFlyMeta),
      );
    }
    if (data.containsKey('speed_swim')) {
      context.handle(
        _speedSwimMeta,
        speedSwim.isAcceptableOrUnknown(data['speed_swim']!, _speedSwimMeta),
      );
    }
    if (data.containsKey('speed_climb')) {
      context.handle(
        _speedClimbMeta,
        speedClimb.isAcceptableOrUnknown(data['speed_climb']!, _speedClimbMeta),
      );
    }
    if (data.containsKey('speed_burrow')) {
      context.handle(
        _speedBurrowMeta,
        speedBurrow.isAcceptableOrUnknown(
          data['speed_burrow']!,
          _speedBurrowMeta,
        ),
      );
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('dexterity')) {
      context.handle(
        _dexterityMeta,
        dexterity.isAcceptableOrUnknown(data['dexterity']!, _dexterityMeta),
      );
    }
    if (data.containsKey('constitution')) {
      context.handle(
        _constitutionMeta,
        constitution.isAcceptableOrUnknown(
          data['constitution']!,
          _constitutionMeta,
        ),
      );
    }
    if (data.containsKey('intelligence')) {
      context.handle(
        _intelligenceMeta,
        intelligence.isAcceptableOrUnknown(
          data['intelligence']!,
          _intelligenceMeta,
        ),
      );
    }
    if (data.containsKey('wisdom')) {
      context.handle(
        _wisdomMeta,
        wisdom.isAcceptableOrUnknown(data['wisdom']!, _wisdomMeta),
      );
    }
    if (data.containsKey('charisma')) {
      context.handle(
        _charismaMeta,
        charisma.isAcceptableOrUnknown(data['charisma']!, _charismaMeta),
      );
    }
    if (data.containsKey('passive_perception')) {
      context.handle(
        _passivePerceptionMeta,
        passivePerception.isAcceptableOrUnknown(
          data['passive_perception']!,
          _passivePerceptionMeta,
        ),
      );
    }
    if (data.containsKey('challenge_rating')) {
      context.handle(
        _challengeRatingMeta,
        challengeRating.isAcceptableOrUnknown(
          data['challenge_rating']!,
          _challengeRatingMeta,
        ),
      );
    }
    if (data.containsKey('challenge_rating_lair')) {
      context.handle(
        _challengeRatingLairMeta,
        challengeRatingLair.isAcceptableOrUnknown(
          data['challenge_rating_lair']!,
          _challengeRatingLairMeta,
        ),
      );
    }
    if (data.containsKey('challenge_rating_coven')) {
      context.handle(
        _challengeRatingCovenMeta,
        challengeRatingCoven.isAcceptableOrUnknown(
          data['challenge_rating_coven']!,
          _challengeRatingCovenMeta,
        ),
      );
    }
    if (data.containsKey('xp_override')) {
      context.handle(
        _xpOverrideMeta,
        xpOverride.isAcceptableOrUnknown(data['xp_override']!, _xpOverrideMeta),
      );
    }
    if (data.containsKey('damage_vulnerabilities')) {
      context.handle(
        _damageVulnerabilitiesMeta,
        damageVulnerabilities.isAcceptableOrUnknown(
          data['damage_vulnerabilities']!,
          _damageVulnerabilitiesMeta,
        ),
      );
    }
    if (data.containsKey('damage_resistances')) {
      context.handle(
        _damageResistancesMeta,
        damageResistances.isAcceptableOrUnknown(
          data['damage_resistances']!,
          _damageResistancesMeta,
        ),
      );
    }
    if (data.containsKey('damage_immunities')) {
      context.handle(
        _damageImmunitiesMeta,
        damageImmunities.isAcceptableOrUnknown(
          data['damage_immunities']!,
          _damageImmunitiesMeta,
        ),
      );
    }
    if (data.containsKey('condition_immunities')) {
      context.handle(
        _conditionImmunitiesMeta,
        conditionImmunities.isAcceptableOrUnknown(
          data['condition_immunities']!,
          _conditionImmunitiesMeta,
        ),
      );
    }
    if (data.containsKey('legendary_group_id')) {
      context.handle(
        _legendaryGroupIdMeta,
        legendaryGroupId.isAcceptableOrUnknown(
          data['legendary_group_id']!,
          _legendaryGroupIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreatureRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      ),
      isSrd: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_srd'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}size'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      typeTags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_tags'],
      ),
      alignment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alignment'],
      ),
      armorClass: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}armor_class'],
      ),
      armorClassType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}armor_class_type'],
      ),
      armorClassOther: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}armor_class_other'],
      ),
      hitPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hit_points'],
      ),
      hitPointFormula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hit_point_formula'],
      ),
      speedWalk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_walk'],
      ),
      speedFly: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_fly'],
      ),
      speedSwim: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_swim'],
      ),
      speedClimb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_climb'],
      ),
      speedBurrow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_burrow'],
      ),
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strength'],
      )!,
      dexterity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dexterity'],
      )!,
      constitution: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}constitution'],
      )!,
      intelligence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intelligence'],
      )!,
      wisdom: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wisdom'],
      )!,
      charisma: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}charisma'],
      )!,
      passivePerception: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}passive_perception'],
      ),
      challengeRating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_rating'],
      ),
      challengeRatingLair: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_rating_lair'],
      ),
      challengeRatingCoven: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_rating_coven'],
      ),
      xpOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_override'],
      ),
      damageVulnerabilities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_vulnerabilities'],
      ),
      damageResistances: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_resistances'],
      ),
      damageImmunities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_immunities'],
      ),
      conditionImmunities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_immunities'],
      ),
      legendaryGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}legendary_group_id'],
      ),
    );
  }

  @override
  $CreaturesTable createAlias(String alias) {
    return $CreaturesTable(attachedDatabase, alias);
  }
}

class CreatureRow extends DataClass implements Insertable<CreatureRow> {
  final int id;
  final String name;
  final String source;
  final int? page;
  final bool isSrd;
  final String? size;
  final String? type;
  final String? typeTags;
  final String? alignment;
  final int? armorClass;
  final String? armorClassType;
  final String? armorClassOther;
  final int? hitPoints;
  final String? hitPointFormula;
  final int? speedWalk;
  final int? speedFly;
  final int? speedSwim;
  final int? speedClimb;
  final int? speedBurrow;
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;
  final int? passivePerception;
  final String? challengeRating;
  final String? challengeRatingLair;
  final String? challengeRatingCoven;
  final int? xpOverride;
  final String? damageVulnerabilities;
  final String? damageResistances;
  final String? damageImmunities;
  final String? conditionImmunities;
  final int? legendaryGroupId;
  const CreatureRow({
    required this.id,
    required this.name,
    required this.source,
    this.page,
    required this.isSrd,
    this.size,
    this.type,
    this.typeTags,
    this.alignment,
    this.armorClass,
    this.armorClassType,
    this.armorClassOther,
    this.hitPoints,
    this.hitPointFormula,
    this.speedWalk,
    this.speedFly,
    this.speedSwim,
    this.speedClimb,
    this.speedBurrow,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    this.passivePerception,
    this.challengeRating,
    this.challengeRatingLair,
    this.challengeRatingCoven,
    this.xpOverride,
    this.damageVulnerabilities,
    this.damageResistances,
    this.damageImmunities,
    this.conditionImmunities,
    this.legendaryGroupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || page != null) {
      map['page'] = Variable<int>(page);
    }
    map['is_srd'] = Variable<bool>(isSrd);
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<String>(size);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || typeTags != null) {
      map['type_tags'] = Variable<String>(typeTags);
    }
    if (!nullToAbsent || alignment != null) {
      map['alignment'] = Variable<String>(alignment);
    }
    if (!nullToAbsent || armorClass != null) {
      map['armor_class'] = Variable<int>(armorClass);
    }
    if (!nullToAbsent || armorClassType != null) {
      map['armor_class_type'] = Variable<String>(armorClassType);
    }
    if (!nullToAbsent || armorClassOther != null) {
      map['armor_class_other'] = Variable<String>(armorClassOther);
    }
    if (!nullToAbsent || hitPoints != null) {
      map['hit_points'] = Variable<int>(hitPoints);
    }
    if (!nullToAbsent || hitPointFormula != null) {
      map['hit_point_formula'] = Variable<String>(hitPointFormula);
    }
    if (!nullToAbsent || speedWalk != null) {
      map['speed_walk'] = Variable<int>(speedWalk);
    }
    if (!nullToAbsent || speedFly != null) {
      map['speed_fly'] = Variable<int>(speedFly);
    }
    if (!nullToAbsent || speedSwim != null) {
      map['speed_swim'] = Variable<int>(speedSwim);
    }
    if (!nullToAbsent || speedClimb != null) {
      map['speed_climb'] = Variable<int>(speedClimb);
    }
    if (!nullToAbsent || speedBurrow != null) {
      map['speed_burrow'] = Variable<int>(speedBurrow);
    }
    map['strength'] = Variable<int>(strength);
    map['dexterity'] = Variable<int>(dexterity);
    map['constitution'] = Variable<int>(constitution);
    map['intelligence'] = Variable<int>(intelligence);
    map['wisdom'] = Variable<int>(wisdom);
    map['charisma'] = Variable<int>(charisma);
    if (!nullToAbsent || passivePerception != null) {
      map['passive_perception'] = Variable<int>(passivePerception);
    }
    if (!nullToAbsent || challengeRating != null) {
      map['challenge_rating'] = Variable<String>(challengeRating);
    }
    if (!nullToAbsent || challengeRatingLair != null) {
      map['challenge_rating_lair'] = Variable<String>(challengeRatingLair);
    }
    if (!nullToAbsent || challengeRatingCoven != null) {
      map['challenge_rating_coven'] = Variable<String>(challengeRatingCoven);
    }
    if (!nullToAbsent || xpOverride != null) {
      map['xp_override'] = Variable<int>(xpOverride);
    }
    if (!nullToAbsent || damageVulnerabilities != null) {
      map['damage_vulnerabilities'] = Variable<String>(damageVulnerabilities);
    }
    if (!nullToAbsent || damageResistances != null) {
      map['damage_resistances'] = Variable<String>(damageResistances);
    }
    if (!nullToAbsent || damageImmunities != null) {
      map['damage_immunities'] = Variable<String>(damageImmunities);
    }
    if (!nullToAbsent || conditionImmunities != null) {
      map['condition_immunities'] = Variable<String>(conditionImmunities);
    }
    if (!nullToAbsent || legendaryGroupId != null) {
      map['legendary_group_id'] = Variable<int>(legendaryGroupId);
    }
    return map;
  }

  CreaturesCompanion toCompanion(bool nullToAbsent) {
    return CreaturesCompanion(
      id: Value(id),
      name: Value(name),
      source: Value(source),
      page: page == null && nullToAbsent ? const Value.absent() : Value(page),
      isSrd: Value(isSrd),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      typeTags: typeTags == null && nullToAbsent
          ? const Value.absent()
          : Value(typeTags),
      alignment: alignment == null && nullToAbsent
          ? const Value.absent()
          : Value(alignment),
      armorClass: armorClass == null && nullToAbsent
          ? const Value.absent()
          : Value(armorClass),
      armorClassType: armorClassType == null && nullToAbsent
          ? const Value.absent()
          : Value(armorClassType),
      armorClassOther: armorClassOther == null && nullToAbsent
          ? const Value.absent()
          : Value(armorClassOther),
      hitPoints: hitPoints == null && nullToAbsent
          ? const Value.absent()
          : Value(hitPoints),
      hitPointFormula: hitPointFormula == null && nullToAbsent
          ? const Value.absent()
          : Value(hitPointFormula),
      speedWalk: speedWalk == null && nullToAbsent
          ? const Value.absent()
          : Value(speedWalk),
      speedFly: speedFly == null && nullToAbsent
          ? const Value.absent()
          : Value(speedFly),
      speedSwim: speedSwim == null && nullToAbsent
          ? const Value.absent()
          : Value(speedSwim),
      speedClimb: speedClimb == null && nullToAbsent
          ? const Value.absent()
          : Value(speedClimb),
      speedBurrow: speedBurrow == null && nullToAbsent
          ? const Value.absent()
          : Value(speedBurrow),
      strength: Value(strength),
      dexterity: Value(dexterity),
      constitution: Value(constitution),
      intelligence: Value(intelligence),
      wisdom: Value(wisdom),
      charisma: Value(charisma),
      passivePerception: passivePerception == null && nullToAbsent
          ? const Value.absent()
          : Value(passivePerception),
      challengeRating: challengeRating == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeRating),
      challengeRatingLair: challengeRatingLair == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeRatingLair),
      challengeRatingCoven: challengeRatingCoven == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeRatingCoven),
      xpOverride: xpOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(xpOverride),
      damageVulnerabilities: damageVulnerabilities == null && nullToAbsent
          ? const Value.absent()
          : Value(damageVulnerabilities),
      damageResistances: damageResistances == null && nullToAbsent
          ? const Value.absent()
          : Value(damageResistances),
      damageImmunities: damageImmunities == null && nullToAbsent
          ? const Value.absent()
          : Value(damageImmunities),
      conditionImmunities: conditionImmunities == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionImmunities),
      legendaryGroupId: legendaryGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(legendaryGroupId),
    );
  }

  factory CreatureRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      source: serializer.fromJson<String>(json['source']),
      page: serializer.fromJson<int?>(json['page']),
      isSrd: serializer.fromJson<bool>(json['isSrd']),
      size: serializer.fromJson<String?>(json['size']),
      type: serializer.fromJson<String?>(json['type']),
      typeTags: serializer.fromJson<String?>(json['typeTags']),
      alignment: serializer.fromJson<String?>(json['alignment']),
      armorClass: serializer.fromJson<int?>(json['armorClass']),
      armorClassType: serializer.fromJson<String?>(json['armorClassType']),
      armorClassOther: serializer.fromJson<String?>(json['armorClassOther']),
      hitPoints: serializer.fromJson<int?>(json['hitPoints']),
      hitPointFormula: serializer.fromJson<String?>(json['hitPointFormula']),
      speedWalk: serializer.fromJson<int?>(json['speedWalk']),
      speedFly: serializer.fromJson<int?>(json['speedFly']),
      speedSwim: serializer.fromJson<int?>(json['speedSwim']),
      speedClimb: serializer.fromJson<int?>(json['speedClimb']),
      speedBurrow: serializer.fromJson<int?>(json['speedBurrow']),
      strength: serializer.fromJson<int>(json['strength']),
      dexterity: serializer.fromJson<int>(json['dexterity']),
      constitution: serializer.fromJson<int>(json['constitution']),
      intelligence: serializer.fromJson<int>(json['intelligence']),
      wisdom: serializer.fromJson<int>(json['wisdom']),
      charisma: serializer.fromJson<int>(json['charisma']),
      passivePerception: serializer.fromJson<int?>(json['passivePerception']),
      challengeRating: serializer.fromJson<String?>(json['challengeRating']),
      challengeRatingLair: serializer.fromJson<String?>(
        json['challengeRatingLair'],
      ),
      challengeRatingCoven: serializer.fromJson<String?>(
        json['challengeRatingCoven'],
      ),
      xpOverride: serializer.fromJson<int?>(json['xpOverride']),
      damageVulnerabilities: serializer.fromJson<String?>(
        json['damageVulnerabilities'],
      ),
      damageResistances: serializer.fromJson<String?>(
        json['damageResistances'],
      ),
      damageImmunities: serializer.fromJson<String?>(json['damageImmunities']),
      conditionImmunities: serializer.fromJson<String?>(
        json['conditionImmunities'],
      ),
      legendaryGroupId: serializer.fromJson<int?>(json['legendaryGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'source': serializer.toJson<String>(source),
      'page': serializer.toJson<int?>(page),
      'isSrd': serializer.toJson<bool>(isSrd),
      'size': serializer.toJson<String?>(size),
      'type': serializer.toJson<String?>(type),
      'typeTags': serializer.toJson<String?>(typeTags),
      'alignment': serializer.toJson<String?>(alignment),
      'armorClass': serializer.toJson<int?>(armorClass),
      'armorClassType': serializer.toJson<String?>(armorClassType),
      'armorClassOther': serializer.toJson<String?>(armorClassOther),
      'hitPoints': serializer.toJson<int?>(hitPoints),
      'hitPointFormula': serializer.toJson<String?>(hitPointFormula),
      'speedWalk': serializer.toJson<int?>(speedWalk),
      'speedFly': serializer.toJson<int?>(speedFly),
      'speedSwim': serializer.toJson<int?>(speedSwim),
      'speedClimb': serializer.toJson<int?>(speedClimb),
      'speedBurrow': serializer.toJson<int?>(speedBurrow),
      'strength': serializer.toJson<int>(strength),
      'dexterity': serializer.toJson<int>(dexterity),
      'constitution': serializer.toJson<int>(constitution),
      'intelligence': serializer.toJson<int>(intelligence),
      'wisdom': serializer.toJson<int>(wisdom),
      'charisma': serializer.toJson<int>(charisma),
      'passivePerception': serializer.toJson<int?>(passivePerception),
      'challengeRating': serializer.toJson<String?>(challengeRating),
      'challengeRatingLair': serializer.toJson<String?>(challengeRatingLair),
      'challengeRatingCoven': serializer.toJson<String?>(challengeRatingCoven),
      'xpOverride': serializer.toJson<int?>(xpOverride),
      'damageVulnerabilities': serializer.toJson<String?>(
        damageVulnerabilities,
      ),
      'damageResistances': serializer.toJson<String?>(damageResistances),
      'damageImmunities': serializer.toJson<String?>(damageImmunities),
      'conditionImmunities': serializer.toJson<String?>(conditionImmunities),
      'legendaryGroupId': serializer.toJson<int?>(legendaryGroupId),
    };
  }

  CreatureRow copyWith({
    int? id,
    String? name,
    String? source,
    Value<int?> page = const Value.absent(),
    bool? isSrd,
    Value<String?> size = const Value.absent(),
    Value<String?> type = const Value.absent(),
    Value<String?> typeTags = const Value.absent(),
    Value<String?> alignment = const Value.absent(),
    Value<int?> armorClass = const Value.absent(),
    Value<String?> armorClassType = const Value.absent(),
    Value<String?> armorClassOther = const Value.absent(),
    Value<int?> hitPoints = const Value.absent(),
    Value<String?> hitPointFormula = const Value.absent(),
    Value<int?> speedWalk = const Value.absent(),
    Value<int?> speedFly = const Value.absent(),
    Value<int?> speedSwim = const Value.absent(),
    Value<int?> speedClimb = const Value.absent(),
    Value<int?> speedBurrow = const Value.absent(),
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
    Value<int?> passivePerception = const Value.absent(),
    Value<String?> challengeRating = const Value.absent(),
    Value<String?> challengeRatingLair = const Value.absent(),
    Value<String?> challengeRatingCoven = const Value.absent(),
    Value<int?> xpOverride = const Value.absent(),
    Value<String?> damageVulnerabilities = const Value.absent(),
    Value<String?> damageResistances = const Value.absent(),
    Value<String?> damageImmunities = const Value.absent(),
    Value<String?> conditionImmunities = const Value.absent(),
    Value<int?> legendaryGroupId = const Value.absent(),
  }) => CreatureRow(
    id: id ?? this.id,
    name: name ?? this.name,
    source: source ?? this.source,
    page: page.present ? page.value : this.page,
    isSrd: isSrd ?? this.isSrd,
    size: size.present ? size.value : this.size,
    type: type.present ? type.value : this.type,
    typeTags: typeTags.present ? typeTags.value : this.typeTags,
    alignment: alignment.present ? alignment.value : this.alignment,
    armorClass: armorClass.present ? armorClass.value : this.armorClass,
    armorClassType: armorClassType.present
        ? armorClassType.value
        : this.armorClassType,
    armorClassOther: armorClassOther.present
        ? armorClassOther.value
        : this.armorClassOther,
    hitPoints: hitPoints.present ? hitPoints.value : this.hitPoints,
    hitPointFormula: hitPointFormula.present
        ? hitPointFormula.value
        : this.hitPointFormula,
    speedWalk: speedWalk.present ? speedWalk.value : this.speedWalk,
    speedFly: speedFly.present ? speedFly.value : this.speedFly,
    speedSwim: speedSwim.present ? speedSwim.value : this.speedSwim,
    speedClimb: speedClimb.present ? speedClimb.value : this.speedClimb,
    speedBurrow: speedBurrow.present ? speedBurrow.value : this.speedBurrow,
    strength: strength ?? this.strength,
    dexterity: dexterity ?? this.dexterity,
    constitution: constitution ?? this.constitution,
    intelligence: intelligence ?? this.intelligence,
    wisdom: wisdom ?? this.wisdom,
    charisma: charisma ?? this.charisma,
    passivePerception: passivePerception.present
        ? passivePerception.value
        : this.passivePerception,
    challengeRating: challengeRating.present
        ? challengeRating.value
        : this.challengeRating,
    challengeRatingLair: challengeRatingLair.present
        ? challengeRatingLair.value
        : this.challengeRatingLair,
    challengeRatingCoven: challengeRatingCoven.present
        ? challengeRatingCoven.value
        : this.challengeRatingCoven,
    xpOverride: xpOverride.present ? xpOverride.value : this.xpOverride,
    damageVulnerabilities: damageVulnerabilities.present
        ? damageVulnerabilities.value
        : this.damageVulnerabilities,
    damageResistances: damageResistances.present
        ? damageResistances.value
        : this.damageResistances,
    damageImmunities: damageImmunities.present
        ? damageImmunities.value
        : this.damageImmunities,
    conditionImmunities: conditionImmunities.present
        ? conditionImmunities.value
        : this.conditionImmunities,
    legendaryGroupId: legendaryGroupId.present
        ? legendaryGroupId.value
        : this.legendaryGroupId,
  );
  CreatureRow copyWithCompanion(CreaturesCompanion data) {
    return CreatureRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      source: data.source.present ? data.source.value : this.source,
      page: data.page.present ? data.page.value : this.page,
      isSrd: data.isSrd.present ? data.isSrd.value : this.isSrd,
      size: data.size.present ? data.size.value : this.size,
      type: data.type.present ? data.type.value : this.type,
      typeTags: data.typeTags.present ? data.typeTags.value : this.typeTags,
      alignment: data.alignment.present ? data.alignment.value : this.alignment,
      armorClass: data.armorClass.present
          ? data.armorClass.value
          : this.armorClass,
      armorClassType: data.armorClassType.present
          ? data.armorClassType.value
          : this.armorClassType,
      armorClassOther: data.armorClassOther.present
          ? data.armorClassOther.value
          : this.armorClassOther,
      hitPoints: data.hitPoints.present ? data.hitPoints.value : this.hitPoints,
      hitPointFormula: data.hitPointFormula.present
          ? data.hitPointFormula.value
          : this.hitPointFormula,
      speedWalk: data.speedWalk.present ? data.speedWalk.value : this.speedWalk,
      speedFly: data.speedFly.present ? data.speedFly.value : this.speedFly,
      speedSwim: data.speedSwim.present ? data.speedSwim.value : this.speedSwim,
      speedClimb: data.speedClimb.present
          ? data.speedClimb.value
          : this.speedClimb,
      speedBurrow: data.speedBurrow.present
          ? data.speedBurrow.value
          : this.speedBurrow,
      strength: data.strength.present ? data.strength.value : this.strength,
      dexterity: data.dexterity.present ? data.dexterity.value : this.dexterity,
      constitution: data.constitution.present
          ? data.constitution.value
          : this.constitution,
      intelligence: data.intelligence.present
          ? data.intelligence.value
          : this.intelligence,
      wisdom: data.wisdom.present ? data.wisdom.value : this.wisdom,
      charisma: data.charisma.present ? data.charisma.value : this.charisma,
      passivePerception: data.passivePerception.present
          ? data.passivePerception.value
          : this.passivePerception,
      challengeRating: data.challengeRating.present
          ? data.challengeRating.value
          : this.challengeRating,
      challengeRatingLair: data.challengeRatingLair.present
          ? data.challengeRatingLair.value
          : this.challengeRatingLair,
      challengeRatingCoven: data.challengeRatingCoven.present
          ? data.challengeRatingCoven.value
          : this.challengeRatingCoven,
      xpOverride: data.xpOverride.present
          ? data.xpOverride.value
          : this.xpOverride,
      damageVulnerabilities: data.damageVulnerabilities.present
          ? data.damageVulnerabilities.value
          : this.damageVulnerabilities,
      damageResistances: data.damageResistances.present
          ? data.damageResistances.value
          : this.damageResistances,
      damageImmunities: data.damageImmunities.present
          ? data.damageImmunities.value
          : this.damageImmunities,
      conditionImmunities: data.conditionImmunities.present
          ? data.conditionImmunities.value
          : this.conditionImmunities,
      legendaryGroupId: data.legendaryGroupId.present
          ? data.legendaryGroupId.value
          : this.legendaryGroupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('page: $page, ')
          ..write('isSrd: $isSrd, ')
          ..write('size: $size, ')
          ..write('type: $type, ')
          ..write('typeTags: $typeTags, ')
          ..write('alignment: $alignment, ')
          ..write('armorClass: $armorClass, ')
          ..write('armorClassType: $armorClassType, ')
          ..write('armorClassOther: $armorClassOther, ')
          ..write('hitPoints: $hitPoints, ')
          ..write('hitPointFormula: $hitPointFormula, ')
          ..write('speedWalk: $speedWalk, ')
          ..write('speedFly: $speedFly, ')
          ..write('speedSwim: $speedSwim, ')
          ..write('speedClimb: $speedClimb, ')
          ..write('speedBurrow: $speedBurrow, ')
          ..write('strength: $strength, ')
          ..write('dexterity: $dexterity, ')
          ..write('constitution: $constitution, ')
          ..write('intelligence: $intelligence, ')
          ..write('wisdom: $wisdom, ')
          ..write('charisma: $charisma, ')
          ..write('passivePerception: $passivePerception, ')
          ..write('challengeRating: $challengeRating, ')
          ..write('challengeRatingLair: $challengeRatingLair, ')
          ..write('challengeRatingCoven: $challengeRatingCoven, ')
          ..write('xpOverride: $xpOverride, ')
          ..write('damageVulnerabilities: $damageVulnerabilities, ')
          ..write('damageResistances: $damageResistances, ')
          ..write('damageImmunities: $damageImmunities, ')
          ..write('conditionImmunities: $conditionImmunities, ')
          ..write('legendaryGroupId: $legendaryGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    source,
    page,
    isSrd,
    size,
    type,
    typeTags,
    alignment,
    armorClass,
    armorClassType,
    armorClassOther,
    hitPoints,
    hitPointFormula,
    speedWalk,
    speedFly,
    speedSwim,
    speedClimb,
    speedBurrow,
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma,
    passivePerception,
    challengeRating,
    challengeRatingLair,
    challengeRatingCoven,
    xpOverride,
    damageVulnerabilities,
    damageResistances,
    damageImmunities,
    conditionImmunities,
    legendaryGroupId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.source == this.source &&
          other.page == this.page &&
          other.isSrd == this.isSrd &&
          other.size == this.size &&
          other.type == this.type &&
          other.typeTags == this.typeTags &&
          other.alignment == this.alignment &&
          other.armorClass == this.armorClass &&
          other.armorClassType == this.armorClassType &&
          other.armorClassOther == this.armorClassOther &&
          other.hitPoints == this.hitPoints &&
          other.hitPointFormula == this.hitPointFormula &&
          other.speedWalk == this.speedWalk &&
          other.speedFly == this.speedFly &&
          other.speedSwim == this.speedSwim &&
          other.speedClimb == this.speedClimb &&
          other.speedBurrow == this.speedBurrow &&
          other.strength == this.strength &&
          other.dexterity == this.dexterity &&
          other.constitution == this.constitution &&
          other.intelligence == this.intelligence &&
          other.wisdom == this.wisdom &&
          other.charisma == this.charisma &&
          other.passivePerception == this.passivePerception &&
          other.challengeRating == this.challengeRating &&
          other.challengeRatingLair == this.challengeRatingLair &&
          other.challengeRatingCoven == this.challengeRatingCoven &&
          other.xpOverride == this.xpOverride &&
          other.damageVulnerabilities == this.damageVulnerabilities &&
          other.damageResistances == this.damageResistances &&
          other.damageImmunities == this.damageImmunities &&
          other.conditionImmunities == this.conditionImmunities &&
          other.legendaryGroupId == this.legendaryGroupId);
}

class CreaturesCompanion extends UpdateCompanion<CreatureRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> source;
  final Value<int?> page;
  final Value<bool> isSrd;
  final Value<String?> size;
  final Value<String?> type;
  final Value<String?> typeTags;
  final Value<String?> alignment;
  final Value<int?> armorClass;
  final Value<String?> armorClassType;
  final Value<String?> armorClassOther;
  final Value<int?> hitPoints;
  final Value<String?> hitPointFormula;
  final Value<int?> speedWalk;
  final Value<int?> speedFly;
  final Value<int?> speedSwim;
  final Value<int?> speedClimb;
  final Value<int?> speedBurrow;
  final Value<int> strength;
  final Value<int> dexterity;
  final Value<int> constitution;
  final Value<int> intelligence;
  final Value<int> wisdom;
  final Value<int> charisma;
  final Value<int?> passivePerception;
  final Value<String?> challengeRating;
  final Value<String?> challengeRatingLair;
  final Value<String?> challengeRatingCoven;
  final Value<int?> xpOverride;
  final Value<String?> damageVulnerabilities;
  final Value<String?> damageResistances;
  final Value<String?> damageImmunities;
  final Value<String?> conditionImmunities;
  final Value<int?> legendaryGroupId;
  const CreaturesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.source = const Value.absent(),
    this.page = const Value.absent(),
    this.isSrd = const Value.absent(),
    this.size = const Value.absent(),
    this.type = const Value.absent(),
    this.typeTags = const Value.absent(),
    this.alignment = const Value.absent(),
    this.armorClass = const Value.absent(),
    this.armorClassType = const Value.absent(),
    this.armorClassOther = const Value.absent(),
    this.hitPoints = const Value.absent(),
    this.hitPointFormula = const Value.absent(),
    this.speedWalk = const Value.absent(),
    this.speedFly = const Value.absent(),
    this.speedSwim = const Value.absent(),
    this.speedClimb = const Value.absent(),
    this.speedBurrow = const Value.absent(),
    this.strength = const Value.absent(),
    this.dexterity = const Value.absent(),
    this.constitution = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.wisdom = const Value.absent(),
    this.charisma = const Value.absent(),
    this.passivePerception = const Value.absent(),
    this.challengeRating = const Value.absent(),
    this.challengeRatingLair = const Value.absent(),
    this.challengeRatingCoven = const Value.absent(),
    this.xpOverride = const Value.absent(),
    this.damageVulnerabilities = const Value.absent(),
    this.damageResistances = const Value.absent(),
    this.damageImmunities = const Value.absent(),
    this.conditionImmunities = const Value.absent(),
    this.legendaryGroupId = const Value.absent(),
  });
  CreaturesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.source = const Value.absent(),
    this.page = const Value.absent(),
    this.isSrd = const Value.absent(),
    this.size = const Value.absent(),
    this.type = const Value.absent(),
    this.typeTags = const Value.absent(),
    this.alignment = const Value.absent(),
    this.armorClass = const Value.absent(),
    this.armorClassType = const Value.absent(),
    this.armorClassOther = const Value.absent(),
    this.hitPoints = const Value.absent(),
    this.hitPointFormula = const Value.absent(),
    this.speedWalk = const Value.absent(),
    this.speedFly = const Value.absent(),
    this.speedSwim = const Value.absent(),
    this.speedClimb = const Value.absent(),
    this.speedBurrow = const Value.absent(),
    this.strength = const Value.absent(),
    this.dexterity = const Value.absent(),
    this.constitution = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.wisdom = const Value.absent(),
    this.charisma = const Value.absent(),
    this.passivePerception = const Value.absent(),
    this.challengeRating = const Value.absent(),
    this.challengeRatingLair = const Value.absent(),
    this.challengeRatingCoven = const Value.absent(),
    this.xpOverride = const Value.absent(),
    this.damageVulnerabilities = const Value.absent(),
    this.damageResistances = const Value.absent(),
    this.damageImmunities = const Value.absent(),
    this.conditionImmunities = const Value.absent(),
    this.legendaryGroupId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CreatureRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? source,
    Expression<int>? page,
    Expression<bool>? isSrd,
    Expression<String>? size,
    Expression<String>? type,
    Expression<String>? typeTags,
    Expression<String>? alignment,
    Expression<int>? armorClass,
    Expression<String>? armorClassType,
    Expression<String>? armorClassOther,
    Expression<int>? hitPoints,
    Expression<String>? hitPointFormula,
    Expression<int>? speedWalk,
    Expression<int>? speedFly,
    Expression<int>? speedSwim,
    Expression<int>? speedClimb,
    Expression<int>? speedBurrow,
    Expression<int>? strength,
    Expression<int>? dexterity,
    Expression<int>? constitution,
    Expression<int>? intelligence,
    Expression<int>? wisdom,
    Expression<int>? charisma,
    Expression<int>? passivePerception,
    Expression<String>? challengeRating,
    Expression<String>? challengeRatingLair,
    Expression<String>? challengeRatingCoven,
    Expression<int>? xpOverride,
    Expression<String>? damageVulnerabilities,
    Expression<String>? damageResistances,
    Expression<String>? damageImmunities,
    Expression<String>? conditionImmunities,
    Expression<int>? legendaryGroupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (source != null) 'source': source,
      if (page != null) 'page': page,
      if (isSrd != null) 'is_srd': isSrd,
      if (size != null) 'size': size,
      if (type != null) 'type': type,
      if (typeTags != null) 'type_tags': typeTags,
      if (alignment != null) 'alignment': alignment,
      if (armorClass != null) 'armor_class': armorClass,
      if (armorClassType != null) 'armor_class_type': armorClassType,
      if (armorClassOther != null) 'armor_class_other': armorClassOther,
      if (hitPoints != null) 'hit_points': hitPoints,
      if (hitPointFormula != null) 'hit_point_formula': hitPointFormula,
      if (speedWalk != null) 'speed_walk': speedWalk,
      if (speedFly != null) 'speed_fly': speedFly,
      if (speedSwim != null) 'speed_swim': speedSwim,
      if (speedClimb != null) 'speed_climb': speedClimb,
      if (speedBurrow != null) 'speed_burrow': speedBurrow,
      if (strength != null) 'strength': strength,
      if (dexterity != null) 'dexterity': dexterity,
      if (constitution != null) 'constitution': constitution,
      if (intelligence != null) 'intelligence': intelligence,
      if (wisdom != null) 'wisdom': wisdom,
      if (charisma != null) 'charisma': charisma,
      if (passivePerception != null) 'passive_perception': passivePerception,
      if (challengeRating != null) 'challenge_rating': challengeRating,
      if (challengeRatingLair != null)
        'challenge_rating_lair': challengeRatingLair,
      if (challengeRatingCoven != null)
        'challenge_rating_coven': challengeRatingCoven,
      if (xpOverride != null) 'xp_override': xpOverride,
      if (damageVulnerabilities != null)
        'damage_vulnerabilities': damageVulnerabilities,
      if (damageResistances != null) 'damage_resistances': damageResistances,
      if (damageImmunities != null) 'damage_immunities': damageImmunities,
      if (conditionImmunities != null)
        'condition_immunities': conditionImmunities,
      if (legendaryGroupId != null) 'legendary_group_id': legendaryGroupId,
    });
  }

  CreaturesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? source,
    Value<int?>? page,
    Value<bool>? isSrd,
    Value<String?>? size,
    Value<String?>? type,
    Value<String?>? typeTags,
    Value<String?>? alignment,
    Value<int?>? armorClass,
    Value<String?>? armorClassType,
    Value<String?>? armorClassOther,
    Value<int?>? hitPoints,
    Value<String?>? hitPointFormula,
    Value<int?>? speedWalk,
    Value<int?>? speedFly,
    Value<int?>? speedSwim,
    Value<int?>? speedClimb,
    Value<int?>? speedBurrow,
    Value<int>? strength,
    Value<int>? dexterity,
    Value<int>? constitution,
    Value<int>? intelligence,
    Value<int>? wisdom,
    Value<int>? charisma,
    Value<int?>? passivePerception,
    Value<String?>? challengeRating,
    Value<String?>? challengeRatingLair,
    Value<String?>? challengeRatingCoven,
    Value<int?>? xpOverride,
    Value<String?>? damageVulnerabilities,
    Value<String?>? damageResistances,
    Value<String?>? damageImmunities,
    Value<String?>? conditionImmunities,
    Value<int?>? legendaryGroupId,
  }) {
    return CreaturesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      page: page ?? this.page,
      isSrd: isSrd ?? this.isSrd,
      size: size ?? this.size,
      type: type ?? this.type,
      typeTags: typeTags ?? this.typeTags,
      alignment: alignment ?? this.alignment,
      armorClass: armorClass ?? this.armorClass,
      armorClassType: armorClassType ?? this.armorClassType,
      armorClassOther: armorClassOther ?? this.armorClassOther,
      hitPoints: hitPoints ?? this.hitPoints,
      hitPointFormula: hitPointFormula ?? this.hitPointFormula,
      speedWalk: speedWalk ?? this.speedWalk,
      speedFly: speedFly ?? this.speedFly,
      speedSwim: speedSwim ?? this.speedSwim,
      speedClimb: speedClimb ?? this.speedClimb,
      speedBurrow: speedBurrow ?? this.speedBurrow,
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
      passivePerception: passivePerception ?? this.passivePerception,
      challengeRating: challengeRating ?? this.challengeRating,
      challengeRatingLair: challengeRatingLair ?? this.challengeRatingLair,
      challengeRatingCoven: challengeRatingCoven ?? this.challengeRatingCoven,
      xpOverride: xpOverride ?? this.xpOverride,
      damageVulnerabilities:
          damageVulnerabilities ?? this.damageVulnerabilities,
      damageResistances: damageResistances ?? this.damageResistances,
      damageImmunities: damageImmunities ?? this.damageImmunities,
      conditionImmunities: conditionImmunities ?? this.conditionImmunities,
      legendaryGroupId: legendaryGroupId ?? this.legendaryGroupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (isSrd.present) {
      map['is_srd'] = Variable<bool>(isSrd.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (typeTags.present) {
      map['type_tags'] = Variable<String>(typeTags.value);
    }
    if (alignment.present) {
      map['alignment'] = Variable<String>(alignment.value);
    }
    if (armorClass.present) {
      map['armor_class'] = Variable<int>(armorClass.value);
    }
    if (armorClassType.present) {
      map['armor_class_type'] = Variable<String>(armorClassType.value);
    }
    if (armorClassOther.present) {
      map['armor_class_other'] = Variable<String>(armorClassOther.value);
    }
    if (hitPoints.present) {
      map['hit_points'] = Variable<int>(hitPoints.value);
    }
    if (hitPointFormula.present) {
      map['hit_point_formula'] = Variable<String>(hitPointFormula.value);
    }
    if (speedWalk.present) {
      map['speed_walk'] = Variable<int>(speedWalk.value);
    }
    if (speedFly.present) {
      map['speed_fly'] = Variable<int>(speedFly.value);
    }
    if (speedSwim.present) {
      map['speed_swim'] = Variable<int>(speedSwim.value);
    }
    if (speedClimb.present) {
      map['speed_climb'] = Variable<int>(speedClimb.value);
    }
    if (speedBurrow.present) {
      map['speed_burrow'] = Variable<int>(speedBurrow.value);
    }
    if (strength.present) {
      map['strength'] = Variable<int>(strength.value);
    }
    if (dexterity.present) {
      map['dexterity'] = Variable<int>(dexterity.value);
    }
    if (constitution.present) {
      map['constitution'] = Variable<int>(constitution.value);
    }
    if (intelligence.present) {
      map['intelligence'] = Variable<int>(intelligence.value);
    }
    if (wisdom.present) {
      map['wisdom'] = Variable<int>(wisdom.value);
    }
    if (charisma.present) {
      map['charisma'] = Variable<int>(charisma.value);
    }
    if (passivePerception.present) {
      map['passive_perception'] = Variable<int>(passivePerception.value);
    }
    if (challengeRating.present) {
      map['challenge_rating'] = Variable<String>(challengeRating.value);
    }
    if (challengeRatingLair.present) {
      map['challenge_rating_lair'] = Variable<String>(
        challengeRatingLair.value,
      );
    }
    if (challengeRatingCoven.present) {
      map['challenge_rating_coven'] = Variable<String>(
        challengeRatingCoven.value,
      );
    }
    if (xpOverride.present) {
      map['xp_override'] = Variable<int>(xpOverride.value);
    }
    if (damageVulnerabilities.present) {
      map['damage_vulnerabilities'] = Variable<String>(
        damageVulnerabilities.value,
      );
    }
    if (damageResistances.present) {
      map['damage_resistances'] = Variable<String>(damageResistances.value);
    }
    if (damageImmunities.present) {
      map['damage_immunities'] = Variable<String>(damageImmunities.value);
    }
    if (conditionImmunities.present) {
      map['condition_immunities'] = Variable<String>(conditionImmunities.value);
    }
    if (legendaryGroupId.present) {
      map['legendary_group_id'] = Variable<int>(legendaryGroupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreaturesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('page: $page, ')
          ..write('isSrd: $isSrd, ')
          ..write('size: $size, ')
          ..write('type: $type, ')
          ..write('typeTags: $typeTags, ')
          ..write('alignment: $alignment, ')
          ..write('armorClass: $armorClass, ')
          ..write('armorClassType: $armorClassType, ')
          ..write('armorClassOther: $armorClassOther, ')
          ..write('hitPoints: $hitPoints, ')
          ..write('hitPointFormula: $hitPointFormula, ')
          ..write('speedWalk: $speedWalk, ')
          ..write('speedFly: $speedFly, ')
          ..write('speedSwim: $speedSwim, ')
          ..write('speedClimb: $speedClimb, ')
          ..write('speedBurrow: $speedBurrow, ')
          ..write('strength: $strength, ')
          ..write('dexterity: $dexterity, ')
          ..write('constitution: $constitution, ')
          ..write('intelligence: $intelligence, ')
          ..write('wisdom: $wisdom, ')
          ..write('charisma: $charisma, ')
          ..write('passivePerception: $passivePerception, ')
          ..write('challengeRating: $challengeRating, ')
          ..write('challengeRatingLair: $challengeRatingLair, ')
          ..write('challengeRatingCoven: $challengeRatingCoven, ')
          ..write('xpOverride: $xpOverride, ')
          ..write('damageVulnerabilities: $damageVulnerabilities, ')
          ..write('damageResistances: $damageResistances, ')
          ..write('damageImmunities: $damageImmunities, ')
          ..write('conditionImmunities: $conditionImmunities, ')
          ..write('legendaryGroupId: $legendaryGroupId')
          ..write(')'))
        .toString();
  }
}

class $CreatureActionsTable extends CreatureActions
    with TableInfo<$CreatureActionsTable, CreatureActionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creatureId,
    name,
    description,
    sortOrder,
    kind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureActionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreatureActionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureActionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
    );
  }

  @override
  $CreatureActionsTable createAlias(String alias) {
    return $CreatureActionsTable(attachedDatabase, alias);
  }
}

class CreatureActionRow extends DataClass
    implements Insertable<CreatureActionRow> {
  final int id;
  final int creatureId;
  final String name;
  final String description;
  final int sortOrder;
  final String kind;
  const CreatureActionRow({
    required this.id,
    required this.creatureId,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['creature_id'] = Variable<int>(creatureId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['sort_order'] = Variable<int>(sortOrder);
    map['kind'] = Variable<String>(kind);
    return map;
  }

  CreatureActionsCompanion toCompanion(bool nullToAbsent) {
    return CreatureActionsCompanion(
      id: Value(id),
      creatureId: Value(creatureId),
      name: Value(name),
      description: Value(description),
      sortOrder: Value(sortOrder),
      kind: Value(kind),
    );
  }

  factory CreatureActionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureActionRow(
      id: serializer.fromJson<int>(json['id']),
      creatureId: serializer.fromJson<int>(json['creatureId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      kind: serializer.fromJson<String>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creatureId': serializer.toJson<int>(creatureId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'kind': serializer.toJson<String>(kind),
    };
  }

  CreatureActionRow copyWith({
    int? id,
    int? creatureId,
    String? name,
    String? description,
    int? sortOrder,
    String? kind,
  }) => CreatureActionRow(
    id: id ?? this.id,
    creatureId: creatureId ?? this.creatureId,
    name: name ?? this.name,
    description: description ?? this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    kind: kind ?? this.kind,
  );
  CreatureActionRow copyWithCompanion(CreatureActionsCompanion data) {
    return CreatureActionRow(
      id: data.id.present ? data.id.value : this.id,
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureActionRow(')
          ..write('id: $id, ')
          ..write('creatureId: $creatureId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, creatureId, name, description, sortOrder, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureActionRow &&
          other.id == this.id &&
          other.creatureId == this.creatureId &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.kind == this.kind);
}

class CreatureActionsCompanion extends UpdateCompanion<CreatureActionRow> {
  final Value<int> id;
  final Value<int> creatureId;
  final Value<String> name;
  final Value<String> description;
  final Value<int> sortOrder;
  final Value<String> kind;
  const CreatureActionsCompanion({
    this.id = const Value.absent(),
    this.creatureId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.kind = const Value.absent(),
  });
  CreatureActionsCompanion.insert({
    this.id = const Value.absent(),
    required int creatureId,
    required String name,
    required String description,
    required int sortOrder,
    required String kind,
  }) : creatureId = Value(creatureId),
       name = Value(name),
       description = Value(description),
       sortOrder = Value(sortOrder),
       kind = Value(kind);
  static Insertable<CreatureActionRow> custom({
    Expression<int>? id,
    Expression<int>? creatureId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<String>? kind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creatureId != null) 'creature_id': creatureId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (kind != null) 'kind': kind,
    });
  }

  CreatureActionsCompanion copyWith({
    Value<int>? id,
    Value<int>? creatureId,
    Value<String>? name,
    Value<String>? description,
    Value<int>? sortOrder,
    Value<String>? kind,
  }) {
    return CreatureActionsCompanion(
      id: id ?? this.id,
      creatureId: creatureId ?? this.creatureId,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      kind: kind ?? this.kind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureActionsCompanion(')
          ..write('id: $id, ')
          ..write('creatureId: $creatureId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }
}

class $CreatureTraitsTable extends CreatureTraits
    with TableInfo<$CreatureTraitsTable, CreatureTraitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureTraitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creatureId,
    name,
    description,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_traits';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureTraitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreatureTraitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureTraitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CreatureTraitsTable createAlias(String alias) {
    return $CreatureTraitsTable(attachedDatabase, alias);
  }
}

class CreatureTraitRow extends DataClass
    implements Insertable<CreatureTraitRow> {
  final int id;
  final int creatureId;
  final String name;
  final String description;
  final int sortOrder;
  const CreatureTraitRow({
    required this.id,
    required this.creatureId,
    required this.name,
    required this.description,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['creature_id'] = Variable<int>(creatureId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CreatureTraitsCompanion toCompanion(bool nullToAbsent) {
    return CreatureTraitsCompanion(
      id: Value(id),
      creatureId: Value(creatureId),
      name: Value(name),
      description: Value(description),
      sortOrder: Value(sortOrder),
    );
  }

  factory CreatureTraitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureTraitRow(
      id: serializer.fromJson<int>(json['id']),
      creatureId: serializer.fromJson<int>(json['creatureId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creatureId': serializer.toJson<int>(creatureId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CreatureTraitRow copyWith({
    int? id,
    int? creatureId,
    String? name,
    String? description,
    int? sortOrder,
  }) => CreatureTraitRow(
    id: id ?? this.id,
    creatureId: creatureId ?? this.creatureId,
    name: name ?? this.name,
    description: description ?? this.description,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CreatureTraitRow copyWithCompanion(CreatureTraitsCompanion data) {
    return CreatureTraitRow(
      id: data.id.present ? data.id.value : this.id,
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureTraitRow(')
          ..write('id: $id, ')
          ..write('creatureId: $creatureId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, creatureId, name, description, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureTraitRow &&
          other.id == this.id &&
          other.creatureId == this.creatureId &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder);
}

class CreatureTraitsCompanion extends UpdateCompanion<CreatureTraitRow> {
  final Value<int> id;
  final Value<int> creatureId;
  final Value<String> name;
  final Value<String> description;
  final Value<int> sortOrder;
  const CreatureTraitsCompanion({
    this.id = const Value.absent(),
    this.creatureId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CreatureTraitsCompanion.insert({
    this.id = const Value.absent(),
    required int creatureId,
    required String name,
    required String description,
    required int sortOrder,
  }) : creatureId = Value(creatureId),
       name = Value(name),
       description = Value(description),
       sortOrder = Value(sortOrder);
  static Insertable<CreatureTraitRow> custom({
    Expression<int>? id,
    Expression<int>? creatureId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creatureId != null) 'creature_id': creatureId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CreatureTraitsCompanion copyWith({
    Value<int>? id,
    Value<int>? creatureId,
    Value<String>? name,
    Value<String>? description,
    Value<int>? sortOrder,
  }) {
    return CreatureTraitsCompanion(
      id: id ?? this.id,
      creatureId: creatureId ?? this.creatureId,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureTraitsCompanion(')
          ..write('id: $id, ')
          ..write('creatureId: $creatureId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $CreatureSpellcastingsTable extends CreatureSpellcastings
    with TableInfo<$CreatureSpellcastingsTable, CreatureSpellcastingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureSpellcastingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headerTextMeta = const VerificationMeta(
    'headerText',
  );
  @override
  late final GeneratedColumn<String> headerText = GeneratedColumn<String>(
    'header_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _footerTextMeta = const VerificationMeta(
    'footerText',
  );
  @override
  late final GeneratedColumn<String> footerText = GeneratedColumn<String>(
    'footer_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _abilityMeta = const VerificationMeta(
    'ability',
  );
  @override
  late final GeneratedColumn<String> ability = GeneratedColumn<String>(
    'ability',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hiddenUsesMeta = const VerificationMeta(
    'hiddenUses',
  );
  @override
  late final GeneratedColumn<String> hiddenUses = GeneratedColumn<String>(
    'hidden_uses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creatureId,
    name,
    headerText,
    footerText,
    ability,
    hiddenUses,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_spellcastings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureSpellcastingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('header_text')) {
      context.handle(
        _headerTextMeta,
        headerText.isAcceptableOrUnknown(data['header_text']!, _headerTextMeta),
      );
    }
    if (data.containsKey('footer_text')) {
      context.handle(
        _footerTextMeta,
        footerText.isAcceptableOrUnknown(data['footer_text']!, _footerTextMeta),
      );
    }
    if (data.containsKey('ability')) {
      context.handle(
        _abilityMeta,
        ability.isAcceptableOrUnknown(data['ability']!, _abilityMeta),
      );
    }
    if (data.containsKey('hidden_uses')) {
      context.handle(
        _hiddenUsesMeta,
        hiddenUses.isAcceptableOrUnknown(data['hidden_uses']!, _hiddenUsesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreatureSpellcastingRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureSpellcastingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      headerText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}header_text'],
      ),
      footerText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}footer_text'],
      ),
      ability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability'],
      ),
      hiddenUses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hidden_uses'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CreatureSpellcastingsTable createAlias(String alias) {
    return $CreatureSpellcastingsTable(attachedDatabase, alias);
  }
}

class CreatureSpellcastingRow extends DataClass
    implements Insertable<CreatureSpellcastingRow> {
  final int id;
  final int creatureId;
  final String name;
  final String? headerText;
  final String? footerText;
  final String? ability;
  final String? hiddenUses;
  final int sortOrder;
  const CreatureSpellcastingRow({
    required this.id,
    required this.creatureId,
    required this.name,
    this.headerText,
    this.footerText,
    this.ability,
    this.hiddenUses,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['creature_id'] = Variable<int>(creatureId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || headerText != null) {
      map['header_text'] = Variable<String>(headerText);
    }
    if (!nullToAbsent || footerText != null) {
      map['footer_text'] = Variable<String>(footerText);
    }
    if (!nullToAbsent || ability != null) {
      map['ability'] = Variable<String>(ability);
    }
    if (!nullToAbsent || hiddenUses != null) {
      map['hidden_uses'] = Variable<String>(hiddenUses);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CreatureSpellcastingsCompanion toCompanion(bool nullToAbsent) {
    return CreatureSpellcastingsCompanion(
      id: Value(id),
      creatureId: Value(creatureId),
      name: Value(name),
      headerText: headerText == null && nullToAbsent
          ? const Value.absent()
          : Value(headerText),
      footerText: footerText == null && nullToAbsent
          ? const Value.absent()
          : Value(footerText),
      ability: ability == null && nullToAbsent
          ? const Value.absent()
          : Value(ability),
      hiddenUses: hiddenUses == null && nullToAbsent
          ? const Value.absent()
          : Value(hiddenUses),
      sortOrder: Value(sortOrder),
    );
  }

  factory CreatureSpellcastingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureSpellcastingRow(
      id: serializer.fromJson<int>(json['id']),
      creatureId: serializer.fromJson<int>(json['creatureId']),
      name: serializer.fromJson<String>(json['name']),
      headerText: serializer.fromJson<String?>(json['headerText']),
      footerText: serializer.fromJson<String?>(json['footerText']),
      ability: serializer.fromJson<String?>(json['ability']),
      hiddenUses: serializer.fromJson<String?>(json['hiddenUses']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creatureId': serializer.toJson<int>(creatureId),
      'name': serializer.toJson<String>(name),
      'headerText': serializer.toJson<String?>(headerText),
      'footerText': serializer.toJson<String?>(footerText),
      'ability': serializer.toJson<String?>(ability),
      'hiddenUses': serializer.toJson<String?>(hiddenUses),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CreatureSpellcastingRow copyWith({
    int? id,
    int? creatureId,
    String? name,
    Value<String?> headerText = const Value.absent(),
    Value<String?> footerText = const Value.absent(),
    Value<String?> ability = const Value.absent(),
    Value<String?> hiddenUses = const Value.absent(),
    int? sortOrder,
  }) => CreatureSpellcastingRow(
    id: id ?? this.id,
    creatureId: creatureId ?? this.creatureId,
    name: name ?? this.name,
    headerText: headerText.present ? headerText.value : this.headerText,
    footerText: footerText.present ? footerText.value : this.footerText,
    ability: ability.present ? ability.value : this.ability,
    hiddenUses: hiddenUses.present ? hiddenUses.value : this.hiddenUses,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CreatureSpellcastingRow copyWithCompanion(
    CreatureSpellcastingsCompanion data,
  ) {
    return CreatureSpellcastingRow(
      id: data.id.present ? data.id.value : this.id,
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      name: data.name.present ? data.name.value : this.name,
      headerText: data.headerText.present
          ? data.headerText.value
          : this.headerText,
      footerText: data.footerText.present
          ? data.footerText.value
          : this.footerText,
      ability: data.ability.present ? data.ability.value : this.ability,
      hiddenUses: data.hiddenUses.present
          ? data.hiddenUses.value
          : this.hiddenUses,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSpellcastingRow(')
          ..write('id: $id, ')
          ..write('creatureId: $creatureId, ')
          ..write('name: $name, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('ability: $ability, ')
          ..write('hiddenUses: $hiddenUses, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    creatureId,
    name,
    headerText,
    footerText,
    ability,
    hiddenUses,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureSpellcastingRow &&
          other.id == this.id &&
          other.creatureId == this.creatureId &&
          other.name == this.name &&
          other.headerText == this.headerText &&
          other.footerText == this.footerText &&
          other.ability == this.ability &&
          other.hiddenUses == this.hiddenUses &&
          other.sortOrder == this.sortOrder);
}

class CreatureSpellcastingsCompanion
    extends UpdateCompanion<CreatureSpellcastingRow> {
  final Value<int> id;
  final Value<int> creatureId;
  final Value<String> name;
  final Value<String?> headerText;
  final Value<String?> footerText;
  final Value<String?> ability;
  final Value<String?> hiddenUses;
  final Value<int> sortOrder;
  const CreatureSpellcastingsCompanion({
    this.id = const Value.absent(),
    this.creatureId = const Value.absent(),
    this.name = const Value.absent(),
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.ability = const Value.absent(),
    this.hiddenUses = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CreatureSpellcastingsCompanion.insert({
    this.id = const Value.absent(),
    required int creatureId,
    required String name,
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.ability = const Value.absent(),
    this.hiddenUses = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : creatureId = Value(creatureId),
       name = Value(name);
  static Insertable<CreatureSpellcastingRow> custom({
    Expression<int>? id,
    Expression<int>? creatureId,
    Expression<String>? name,
    Expression<String>? headerText,
    Expression<String>? footerText,
    Expression<String>? ability,
    Expression<String>? hiddenUses,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creatureId != null) 'creature_id': creatureId,
      if (name != null) 'name': name,
      if (headerText != null) 'header_text': headerText,
      if (footerText != null) 'footer_text': footerText,
      if (ability != null) 'ability': ability,
      if (hiddenUses != null) 'hidden_uses': hiddenUses,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CreatureSpellcastingsCompanion copyWith({
    Value<int>? id,
    Value<int>? creatureId,
    Value<String>? name,
    Value<String?>? headerText,
    Value<String?>? footerText,
    Value<String?>? ability,
    Value<String?>? hiddenUses,
    Value<int>? sortOrder,
  }) {
    return CreatureSpellcastingsCompanion(
      id: id ?? this.id,
      creatureId: creatureId ?? this.creatureId,
      name: name ?? this.name,
      headerText: headerText ?? this.headerText,
      footerText: footerText ?? this.footerText,
      ability: ability ?? this.ability,
      hiddenUses: hiddenUses ?? this.hiddenUses,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (headerText.present) {
      map['header_text'] = Variable<String>(headerText.value);
    }
    if (footerText.present) {
      map['footer_text'] = Variable<String>(footerText.value);
    }
    if (ability.present) {
      map['ability'] = Variable<String>(ability.value);
    }
    if (hiddenUses.present) {
      map['hidden_uses'] = Variable<String>(hiddenUses.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSpellcastingsCompanion(')
          ..write('id: $id, ')
          ..write('creatureId: $creatureId, ')
          ..write('name: $name, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('ability: $ability, ')
          ..write('hiddenUses: $hiddenUses, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $CreatureSpellsTable extends CreatureSpells
    with TableInfo<$CreatureSpellsTable, CreatureSpellRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureSpellsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _spellcastingIdMeta = const VerificationMeta(
    'spellcastingId',
  );
  @override
  late final GeneratedColumn<int> spellcastingId = GeneratedColumn<int>(
    'spellcasting_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creature_spellcastings (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _spellNameMeta = const VerificationMeta(
    'spellName',
  );
  @override
  late final GeneratedColumn<String> spellName = GeneratedColumn<String>(
    'spell_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spellLevelMeta = const VerificationMeta(
    'spellLevel',
  );
  @override
  late final GeneratedColumn<int> spellLevel = GeneratedColumn<int>(
    'spell_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usesMeta = const VerificationMeta('uses');
  @override
  late final GeneratedColumn<String> uses = GeneratedColumn<String>(
    'uses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slotsMeta = const VerificationMeta('slots');
  @override
  late final GeneratedColumn<int> slots = GeneratedColumn<int>(
    'slots',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spellcastingId,
    spellName,
    spellLevel,
    uses,
    slots,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_spells';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureSpellRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('spellcasting_id')) {
      context.handle(
        _spellcastingIdMeta,
        spellcastingId.isAcceptableOrUnknown(
          data['spellcasting_id']!,
          _spellcastingIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_spellcastingIdMeta);
    }
    if (data.containsKey('spell_name')) {
      context.handle(
        _spellNameMeta,
        spellName.isAcceptableOrUnknown(data['spell_name']!, _spellNameMeta),
      );
    } else if (isInserting) {
      context.missing(_spellNameMeta);
    }
    if (data.containsKey('spell_level')) {
      context.handle(
        _spellLevelMeta,
        spellLevel.isAcceptableOrUnknown(data['spell_level']!, _spellLevelMeta),
      );
    }
    if (data.containsKey('uses')) {
      context.handle(
        _usesMeta,
        uses.isAcceptableOrUnknown(data['uses']!, _usesMeta),
      );
    }
    if (data.containsKey('slots')) {
      context.handle(
        _slotsMeta,
        slots.isAcceptableOrUnknown(data['slots']!, _slotsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreatureSpellRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureSpellRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      spellcastingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spellcasting_id'],
      )!,
      spellName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spell_name'],
      )!,
      spellLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spell_level'],
      ),
      uses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uses'],
      ),
      slots: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slots'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CreatureSpellsTable createAlias(String alias) {
    return $CreatureSpellsTable(attachedDatabase, alias);
  }
}

class CreatureSpellRow extends DataClass
    implements Insertable<CreatureSpellRow> {
  final int id;
  final int spellcastingId;
  final String spellName;
  final int? spellLevel;
  final String? uses;
  final int? slots;
  final int sortOrder;
  const CreatureSpellRow({
    required this.id,
    required this.spellcastingId,
    required this.spellName,
    this.spellLevel,
    this.uses,
    this.slots,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['spellcasting_id'] = Variable<int>(spellcastingId);
    map['spell_name'] = Variable<String>(spellName);
    if (!nullToAbsent || spellLevel != null) {
      map['spell_level'] = Variable<int>(spellLevel);
    }
    if (!nullToAbsent || uses != null) {
      map['uses'] = Variable<String>(uses);
    }
    if (!nullToAbsent || slots != null) {
      map['slots'] = Variable<int>(slots);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CreatureSpellsCompanion toCompanion(bool nullToAbsent) {
    return CreatureSpellsCompanion(
      id: Value(id),
      spellcastingId: Value(spellcastingId),
      spellName: Value(spellName),
      spellLevel: spellLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(spellLevel),
      uses: uses == null && nullToAbsent ? const Value.absent() : Value(uses),
      slots: slots == null && nullToAbsent
          ? const Value.absent()
          : Value(slots),
      sortOrder: Value(sortOrder),
    );
  }

  factory CreatureSpellRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureSpellRow(
      id: serializer.fromJson<int>(json['id']),
      spellcastingId: serializer.fromJson<int>(json['spellcastingId']),
      spellName: serializer.fromJson<String>(json['spellName']),
      spellLevel: serializer.fromJson<int?>(json['spellLevel']),
      uses: serializer.fromJson<String?>(json['uses']),
      slots: serializer.fromJson<int?>(json['slots']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'spellcastingId': serializer.toJson<int>(spellcastingId),
      'spellName': serializer.toJson<String>(spellName),
      'spellLevel': serializer.toJson<int?>(spellLevel),
      'uses': serializer.toJson<String?>(uses),
      'slots': serializer.toJson<int?>(slots),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CreatureSpellRow copyWith({
    int? id,
    int? spellcastingId,
    String? spellName,
    Value<int?> spellLevel = const Value.absent(),
    Value<String?> uses = const Value.absent(),
    Value<int?> slots = const Value.absent(),
    int? sortOrder,
  }) => CreatureSpellRow(
    id: id ?? this.id,
    spellcastingId: spellcastingId ?? this.spellcastingId,
    spellName: spellName ?? this.spellName,
    spellLevel: spellLevel.present ? spellLevel.value : this.spellLevel,
    uses: uses.present ? uses.value : this.uses,
    slots: slots.present ? slots.value : this.slots,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CreatureSpellRow copyWithCompanion(CreatureSpellsCompanion data) {
    return CreatureSpellRow(
      id: data.id.present ? data.id.value : this.id,
      spellcastingId: data.spellcastingId.present
          ? data.spellcastingId.value
          : this.spellcastingId,
      spellName: data.spellName.present ? data.spellName.value : this.spellName,
      spellLevel: data.spellLevel.present
          ? data.spellLevel.value
          : this.spellLevel,
      uses: data.uses.present ? data.uses.value : this.uses,
      slots: data.slots.present ? data.slots.value : this.slots,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSpellRow(')
          ..write('id: $id, ')
          ..write('spellcastingId: $spellcastingId, ')
          ..write('spellName: $spellName, ')
          ..write('spellLevel: $spellLevel, ')
          ..write('uses: $uses, ')
          ..write('slots: $slots, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spellcastingId,
    spellName,
    spellLevel,
    uses,
    slots,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureSpellRow &&
          other.id == this.id &&
          other.spellcastingId == this.spellcastingId &&
          other.spellName == this.spellName &&
          other.spellLevel == this.spellLevel &&
          other.uses == this.uses &&
          other.slots == this.slots &&
          other.sortOrder == this.sortOrder);
}

class CreatureSpellsCompanion extends UpdateCompanion<CreatureSpellRow> {
  final Value<int> id;
  final Value<int> spellcastingId;
  final Value<String> spellName;
  final Value<int?> spellLevel;
  final Value<String?> uses;
  final Value<int?> slots;
  final Value<int> sortOrder;
  const CreatureSpellsCompanion({
    this.id = const Value.absent(),
    this.spellcastingId = const Value.absent(),
    this.spellName = const Value.absent(),
    this.spellLevel = const Value.absent(),
    this.uses = const Value.absent(),
    this.slots = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CreatureSpellsCompanion.insert({
    this.id = const Value.absent(),
    required int spellcastingId,
    required String spellName,
    this.spellLevel = const Value.absent(),
    this.uses = const Value.absent(),
    this.slots = const Value.absent(),
    required int sortOrder,
  }) : spellcastingId = Value(spellcastingId),
       spellName = Value(spellName),
       sortOrder = Value(sortOrder);
  static Insertable<CreatureSpellRow> custom({
    Expression<int>? id,
    Expression<int>? spellcastingId,
    Expression<String>? spellName,
    Expression<int>? spellLevel,
    Expression<String>? uses,
    Expression<int>? slots,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spellcastingId != null) 'spellcasting_id': spellcastingId,
      if (spellName != null) 'spell_name': spellName,
      if (spellLevel != null) 'spell_level': spellLevel,
      if (uses != null) 'uses': uses,
      if (slots != null) 'slots': slots,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CreatureSpellsCompanion copyWith({
    Value<int>? id,
    Value<int>? spellcastingId,
    Value<String>? spellName,
    Value<int?>? spellLevel,
    Value<String?>? uses,
    Value<int?>? slots,
    Value<int>? sortOrder,
  }) {
    return CreatureSpellsCompanion(
      id: id ?? this.id,
      spellcastingId: spellcastingId ?? this.spellcastingId,
      spellName: spellName ?? this.spellName,
      spellLevel: spellLevel ?? this.spellLevel,
      uses: uses ?? this.uses,
      slots: slots ?? this.slots,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (spellcastingId.present) {
      map['spellcasting_id'] = Variable<int>(spellcastingId.value);
    }
    if (spellName.present) {
      map['spell_name'] = Variable<String>(spellName.value);
    }
    if (spellLevel.present) {
      map['spell_level'] = Variable<int>(spellLevel.value);
    }
    if (uses.present) {
      map['uses'] = Variable<String>(uses.value);
    }
    if (slots.present) {
      map['slots'] = Variable<int>(slots.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSpellsCompanion(')
          ..write('id: $id, ')
          ..write('spellcastingId: $spellcastingId, ')
          ..write('spellName: $spellName, ')
          ..write('spellLevel: $spellLevel, ')
          ..write('uses: $uses, ')
          ..write('slots: $slots, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $CreatureSavesTable extends CreatureSaves
    with TableInfo<$CreatureSavesTable, CreatureSaveRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureSavesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _abilityMeta = const VerificationMeta(
    'ability',
  );
  @override
  late final GeneratedColumn<String> ability = GeneratedColumn<String>(
    'ability',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<int> bonus = GeneratedColumn<int>(
    'bonus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [creatureId, ability, bonus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_saves';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureSaveRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('ability')) {
      context.handle(
        _abilityMeta,
        ability.isAcceptableOrUnknown(data['ability']!, _abilityMeta),
      );
    } else if (isInserting) {
      context.missing(_abilityMeta);
    }
    if (data.containsKey('bonus')) {
      context.handle(
        _bonusMeta,
        bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta),
      );
    } else if (isInserting) {
      context.missing(_bonusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {creatureId, ability};
  @override
  CreatureSaveRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureSaveRow(
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      ability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability'],
      )!,
      bonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus'],
      )!,
    );
  }

  @override
  $CreatureSavesTable createAlias(String alias) {
    return $CreatureSavesTable(attachedDatabase, alias);
  }
}

class CreatureSaveRow extends DataClass implements Insertable<CreatureSaveRow> {
  final int creatureId;
  final String ability;
  final int bonus;
  const CreatureSaveRow({
    required this.creatureId,
    required this.ability,
    required this.bonus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['creature_id'] = Variable<int>(creatureId);
    map['ability'] = Variable<String>(ability);
    map['bonus'] = Variable<int>(bonus);
    return map;
  }

  CreatureSavesCompanion toCompanion(bool nullToAbsent) {
    return CreatureSavesCompanion(
      creatureId: Value(creatureId),
      ability: Value(ability),
      bonus: Value(bonus),
    );
  }

  factory CreatureSaveRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureSaveRow(
      creatureId: serializer.fromJson<int>(json['creatureId']),
      ability: serializer.fromJson<String>(json['ability']),
      bonus: serializer.fromJson<int>(json['bonus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'creatureId': serializer.toJson<int>(creatureId),
      'ability': serializer.toJson<String>(ability),
      'bonus': serializer.toJson<int>(bonus),
    };
  }

  CreatureSaveRow copyWith({int? creatureId, String? ability, int? bonus}) =>
      CreatureSaveRow(
        creatureId: creatureId ?? this.creatureId,
        ability: ability ?? this.ability,
        bonus: bonus ?? this.bonus,
      );
  CreatureSaveRow copyWithCompanion(CreatureSavesCompanion data) {
    return CreatureSaveRow(
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      ability: data.ability.present ? data.ability.value : this.ability,
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSaveRow(')
          ..write('creatureId: $creatureId, ')
          ..write('ability: $ability, ')
          ..write('bonus: $bonus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(creatureId, ability, bonus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureSaveRow &&
          other.creatureId == this.creatureId &&
          other.ability == this.ability &&
          other.bonus == this.bonus);
}

class CreatureSavesCompanion extends UpdateCompanion<CreatureSaveRow> {
  final Value<int> creatureId;
  final Value<String> ability;
  final Value<int> bonus;
  final Value<int> rowid;
  const CreatureSavesCompanion({
    this.creatureId = const Value.absent(),
    this.ability = const Value.absent(),
    this.bonus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreatureSavesCompanion.insert({
    required int creatureId,
    required String ability,
    required int bonus,
    this.rowid = const Value.absent(),
  }) : creatureId = Value(creatureId),
       ability = Value(ability),
       bonus = Value(bonus);
  static Insertable<CreatureSaveRow> custom({
    Expression<int>? creatureId,
    Expression<String>? ability,
    Expression<int>? bonus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (creatureId != null) 'creature_id': creatureId,
      if (ability != null) 'ability': ability,
      if (bonus != null) 'bonus': bonus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreatureSavesCompanion copyWith({
    Value<int>? creatureId,
    Value<String>? ability,
    Value<int>? bonus,
    Value<int>? rowid,
  }) {
    return CreatureSavesCompanion(
      creatureId: creatureId ?? this.creatureId,
      ability: ability ?? this.ability,
      bonus: bonus ?? this.bonus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (ability.present) {
      map['ability'] = Variable<String>(ability.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<int>(bonus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSavesCompanion(')
          ..write('creatureId: $creatureId, ')
          ..write('ability: $ability, ')
          ..write('bonus: $bonus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreatureSkillsTable extends CreatureSkills
    with TableInfo<$CreatureSkillsTable, CreatureSkillRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureSkillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _skillMeta = const VerificationMeta('skill');
  @override
  late final GeneratedColumn<String> skill = GeneratedColumn<String>(
    'skill',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<int> bonus = GeneratedColumn<int>(
    'bonus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [creatureId, skill, bonus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_skills';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureSkillRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('skill')) {
      context.handle(
        _skillMeta,
        skill.isAcceptableOrUnknown(data['skill']!, _skillMeta),
      );
    } else if (isInserting) {
      context.missing(_skillMeta);
    }
    if (data.containsKey('bonus')) {
      context.handle(
        _bonusMeta,
        bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta),
      );
    } else if (isInserting) {
      context.missing(_bonusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {creatureId, skill};
  @override
  CreatureSkillRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureSkillRow(
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      skill: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill'],
      )!,
      bonus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus'],
      )!,
    );
  }

  @override
  $CreatureSkillsTable createAlias(String alias) {
    return $CreatureSkillsTable(attachedDatabase, alias);
  }
}

class CreatureSkillRow extends DataClass
    implements Insertable<CreatureSkillRow> {
  final int creatureId;
  final String skill;
  final int bonus;
  const CreatureSkillRow({
    required this.creatureId,
    required this.skill,
    required this.bonus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['creature_id'] = Variable<int>(creatureId);
    map['skill'] = Variable<String>(skill);
    map['bonus'] = Variable<int>(bonus);
    return map;
  }

  CreatureSkillsCompanion toCompanion(bool nullToAbsent) {
    return CreatureSkillsCompanion(
      creatureId: Value(creatureId),
      skill: Value(skill),
      bonus: Value(bonus),
    );
  }

  factory CreatureSkillRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureSkillRow(
      creatureId: serializer.fromJson<int>(json['creatureId']),
      skill: serializer.fromJson<String>(json['skill']),
      bonus: serializer.fromJson<int>(json['bonus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'creatureId': serializer.toJson<int>(creatureId),
      'skill': serializer.toJson<String>(skill),
      'bonus': serializer.toJson<int>(bonus),
    };
  }

  CreatureSkillRow copyWith({int? creatureId, String? skill, int? bonus}) =>
      CreatureSkillRow(
        creatureId: creatureId ?? this.creatureId,
        skill: skill ?? this.skill,
        bonus: bonus ?? this.bonus,
      );
  CreatureSkillRow copyWithCompanion(CreatureSkillsCompanion data) {
    return CreatureSkillRow(
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      skill: data.skill.present ? data.skill.value : this.skill,
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSkillRow(')
          ..write('creatureId: $creatureId, ')
          ..write('skill: $skill, ')
          ..write('bonus: $bonus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(creatureId, skill, bonus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureSkillRow &&
          other.creatureId == this.creatureId &&
          other.skill == this.skill &&
          other.bonus == this.bonus);
}

class CreatureSkillsCompanion extends UpdateCompanion<CreatureSkillRow> {
  final Value<int> creatureId;
  final Value<String> skill;
  final Value<int> bonus;
  final Value<int> rowid;
  const CreatureSkillsCompanion({
    this.creatureId = const Value.absent(),
    this.skill = const Value.absent(),
    this.bonus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreatureSkillsCompanion.insert({
    required int creatureId,
    required String skill,
    required int bonus,
    this.rowid = const Value.absent(),
  }) : creatureId = Value(creatureId),
       skill = Value(skill),
       bonus = Value(bonus);
  static Insertable<CreatureSkillRow> custom({
    Expression<int>? creatureId,
    Expression<String>? skill,
    Expression<int>? bonus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (creatureId != null) 'creature_id': creatureId,
      if (skill != null) 'skill': skill,
      if (bonus != null) 'bonus': bonus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreatureSkillsCompanion copyWith({
    Value<int>? creatureId,
    Value<String>? skill,
    Value<int>? bonus,
    Value<int>? rowid,
  }) {
    return CreatureSkillsCompanion(
      creatureId: creatureId ?? this.creatureId,
      skill: skill ?? this.skill,
      bonus: bonus ?? this.bonus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (skill.present) {
      map['skill'] = Variable<String>(skill.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<int>(bonus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSkillsCompanion(')
          ..write('creatureId: $creatureId, ')
          ..write('skill: $skill, ')
          ..write('bonus: $bonus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreatureSensesTable extends CreatureSenses
    with TableInfo<$CreatureSensesTable, CreatureSenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureSensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _senseMeta = const VerificationMeta('sense');
  @override
  late final GeneratedColumn<String> sense = GeneratedColumn<String>(
    'sense',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [creatureId, sense];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_senses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureSenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('sense')) {
      context.handle(
        _senseMeta,
        sense.isAcceptableOrUnknown(data['sense']!, _senseMeta),
      );
    } else if (isInserting) {
      context.missing(_senseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {creatureId, sense};
  @override
  CreatureSenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureSenseRow(
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      sense: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sense'],
      )!,
    );
  }

  @override
  $CreatureSensesTable createAlias(String alias) {
    return $CreatureSensesTable(attachedDatabase, alias);
  }
}

class CreatureSenseRow extends DataClass
    implements Insertable<CreatureSenseRow> {
  final int creatureId;
  final String sense;
  const CreatureSenseRow({required this.creatureId, required this.sense});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['creature_id'] = Variable<int>(creatureId);
    map['sense'] = Variable<String>(sense);
    return map;
  }

  CreatureSensesCompanion toCompanion(bool nullToAbsent) {
    return CreatureSensesCompanion(
      creatureId: Value(creatureId),
      sense: Value(sense),
    );
  }

  factory CreatureSenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureSenseRow(
      creatureId: serializer.fromJson<int>(json['creatureId']),
      sense: serializer.fromJson<String>(json['sense']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'creatureId': serializer.toJson<int>(creatureId),
      'sense': serializer.toJson<String>(sense),
    };
  }

  CreatureSenseRow copyWith({int? creatureId, String? sense}) =>
      CreatureSenseRow(
        creatureId: creatureId ?? this.creatureId,
        sense: sense ?? this.sense,
      );
  CreatureSenseRow copyWithCompanion(CreatureSensesCompanion data) {
    return CreatureSenseRow(
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      sense: data.sense.present ? data.sense.value : this.sense,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSenseRow(')
          ..write('creatureId: $creatureId, ')
          ..write('sense: $sense')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(creatureId, sense);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureSenseRow &&
          other.creatureId == this.creatureId &&
          other.sense == this.sense);
}

class CreatureSensesCompanion extends UpdateCompanion<CreatureSenseRow> {
  final Value<int> creatureId;
  final Value<String> sense;
  final Value<int> rowid;
  const CreatureSensesCompanion({
    this.creatureId = const Value.absent(),
    this.sense = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreatureSensesCompanion.insert({
    required int creatureId,
    required String sense,
    this.rowid = const Value.absent(),
  }) : creatureId = Value(creatureId),
       sense = Value(sense);
  static Insertable<CreatureSenseRow> custom({
    Expression<int>? creatureId,
    Expression<String>? sense,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (creatureId != null) 'creature_id': creatureId,
      if (sense != null) 'sense': sense,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreatureSensesCompanion copyWith({
    Value<int>? creatureId,
    Value<String>? sense,
    Value<int>? rowid,
  }) {
    return CreatureSensesCompanion(
      creatureId: creatureId ?? this.creatureId,
      sense: sense ?? this.sense,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (sense.present) {
      map['sense'] = Variable<String>(sense.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureSensesCompanion(')
          ..write('creatureId: $creatureId, ')
          ..write('sense: $sense, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreatureLanguagesTable extends CreatureLanguages
    with TableInfo<$CreatureLanguagesTable, CreatureLanguageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureLanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [creatureId, language];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_languages';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureLanguageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {creatureId, language};
  @override
  CreatureLanguageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureLanguageRow(
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
    );
  }

  @override
  $CreatureLanguagesTable createAlias(String alias) {
    return $CreatureLanguagesTable(attachedDatabase, alias);
  }
}

class CreatureLanguageRow extends DataClass
    implements Insertable<CreatureLanguageRow> {
  final int creatureId;
  final String language;
  const CreatureLanguageRow({required this.creatureId, required this.language});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['creature_id'] = Variable<int>(creatureId);
    map['language'] = Variable<String>(language);
    return map;
  }

  CreatureLanguagesCompanion toCompanion(bool nullToAbsent) {
    return CreatureLanguagesCompanion(
      creatureId: Value(creatureId),
      language: Value(language),
    );
  }

  factory CreatureLanguageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureLanguageRow(
      creatureId: serializer.fromJson<int>(json['creatureId']),
      language: serializer.fromJson<String>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'creatureId': serializer.toJson<int>(creatureId),
      'language': serializer.toJson<String>(language),
    };
  }

  CreatureLanguageRow copyWith({int? creatureId, String? language}) =>
      CreatureLanguageRow(
        creatureId: creatureId ?? this.creatureId,
        language: language ?? this.language,
      );
  CreatureLanguageRow copyWithCompanion(CreatureLanguagesCompanion data) {
    return CreatureLanguageRow(
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureLanguageRow(')
          ..write('creatureId: $creatureId, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(creatureId, language);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureLanguageRow &&
          other.creatureId == this.creatureId &&
          other.language == this.language);
}

class CreatureLanguagesCompanion extends UpdateCompanion<CreatureLanguageRow> {
  final Value<int> creatureId;
  final Value<String> language;
  final Value<int> rowid;
  const CreatureLanguagesCompanion({
    this.creatureId = const Value.absent(),
    this.language = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreatureLanguagesCompanion.insert({
    required int creatureId,
    required String language,
    this.rowid = const Value.absent(),
  }) : creatureId = Value(creatureId),
       language = Value(language);
  static Insertable<CreatureLanguageRow> custom({
    Expression<int>? creatureId,
    Expression<String>? language,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (creatureId != null) 'creature_id': creatureId,
      if (language != null) 'language': language,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreatureLanguagesCompanion copyWith({
    Value<int>? creatureId,
    Value<String>? language,
    Value<int>? rowid,
  }) {
    return CreatureLanguagesCompanion(
      creatureId: creatureId ?? this.creatureId,
      language: language ?? this.language,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureLanguagesCompanion(')
          ..write('creatureId: $creatureId, ')
          ..write('language: $language, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreatureEnvironmentsTable extends CreatureEnvironments
    with TableInfo<$CreatureEnvironmentsTable, CreatureEnvironmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureEnvironmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _creatureIdMeta = const VerificationMeta(
    'creatureId',
  );
  @override
  late final GeneratedColumn<int> creatureId = GeneratedColumn<int>(
    'creature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creatures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _environmentMeta = const VerificationMeta(
    'environment',
  );
  @override
  late final GeneratedColumn<String> environment = GeneratedColumn<String>(
    'environment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [creatureId, environment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_environments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureEnvironmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('creature_id')) {
      context.handle(
        _creatureIdMeta,
        creatureId.isAcceptableOrUnknown(data['creature_id']!, _creatureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatureIdMeta);
    }
    if (data.containsKey('environment')) {
      context.handle(
        _environmentMeta,
        environment.isAcceptableOrUnknown(
          data['environment']!,
          _environmentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_environmentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {creatureId, environment};
  @override
  CreatureEnvironmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureEnvironmentRow(
      creatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creature_id'],
      )!,
      environment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}environment'],
      )!,
    );
  }

  @override
  $CreatureEnvironmentsTable createAlias(String alias) {
    return $CreatureEnvironmentsTable(attachedDatabase, alias);
  }
}

class CreatureEnvironmentRow extends DataClass
    implements Insertable<CreatureEnvironmentRow> {
  final int creatureId;
  final String environment;
  const CreatureEnvironmentRow({
    required this.creatureId,
    required this.environment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['creature_id'] = Variable<int>(creatureId);
    map['environment'] = Variable<String>(environment);
    return map;
  }

  CreatureEnvironmentsCompanion toCompanion(bool nullToAbsent) {
    return CreatureEnvironmentsCompanion(
      creatureId: Value(creatureId),
      environment: Value(environment),
    );
  }

  factory CreatureEnvironmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureEnvironmentRow(
      creatureId: serializer.fromJson<int>(json['creatureId']),
      environment: serializer.fromJson<String>(json['environment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'creatureId': serializer.toJson<int>(creatureId),
      'environment': serializer.toJson<String>(environment),
    };
  }

  CreatureEnvironmentRow copyWith({int? creatureId, String? environment}) =>
      CreatureEnvironmentRow(
        creatureId: creatureId ?? this.creatureId,
        environment: environment ?? this.environment,
      );
  CreatureEnvironmentRow copyWithCompanion(CreatureEnvironmentsCompanion data) {
    return CreatureEnvironmentRow(
      creatureId: data.creatureId.present
          ? data.creatureId.value
          : this.creatureId,
      environment: data.environment.present
          ? data.environment.value
          : this.environment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureEnvironmentRow(')
          ..write('creatureId: $creatureId, ')
          ..write('environment: $environment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(creatureId, environment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureEnvironmentRow &&
          other.creatureId == this.creatureId &&
          other.environment == this.environment);
}

class CreatureEnvironmentsCompanion
    extends UpdateCompanion<CreatureEnvironmentRow> {
  final Value<int> creatureId;
  final Value<String> environment;
  final Value<int> rowid;
  const CreatureEnvironmentsCompanion({
    this.creatureId = const Value.absent(),
    this.environment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreatureEnvironmentsCompanion.insert({
    required int creatureId,
    required String environment,
    this.rowid = const Value.absent(),
  }) : creatureId = Value(creatureId),
       environment = Value(environment);
  static Insertable<CreatureEnvironmentRow> custom({
    Expression<int>? creatureId,
    Expression<String>? environment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (creatureId != null) 'creature_id': creatureId,
      if (environment != null) 'environment': environment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreatureEnvironmentsCompanion copyWith({
    Value<int>? creatureId,
    Value<String>? environment,
    Value<int>? rowid,
  }) {
    return CreatureEnvironmentsCompanion(
      creatureId: creatureId ?? this.creatureId,
      environment: environment ?? this.environment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (creatureId.present) {
      map['creature_id'] = Variable<int>(creatureId.value);
    }
    if (environment.present) {
      map['environment'] = Variable<String>(environment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureEnvironmentsCompanion(')
          ..write('creatureId: $creatureId, ')
          ..write('environment: $environment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $LegendaryGroupsTable legendaryGroups = $LegendaryGroupsTable(
    this,
  );
  late final $CreaturesTable creatures = $CreaturesTable(this);
  late final $CreatureActionsTable creatureActions = $CreatureActionsTable(
    this,
  );
  late final $CreatureTraitsTable creatureTraits = $CreatureTraitsTable(this);
  late final $CreatureSpellcastingsTable creatureSpellcastings =
      $CreatureSpellcastingsTable(this);
  late final $CreatureSpellsTable creatureSpells = $CreatureSpellsTable(this);
  late final $CreatureSavesTable creatureSaves = $CreatureSavesTable(this);
  late final $CreatureSkillsTable creatureSkills = $CreatureSkillsTable(this);
  late final $CreatureSensesTable creatureSenses = $CreatureSensesTable(this);
  late final $CreatureLanguagesTable creatureLanguages =
      $CreatureLanguagesTable(this);
  late final $CreatureEnvironmentsTable creatureEnvironments =
      $CreatureEnvironmentsTable(this);
  late final Index idxCreatureNameSource = Index(
    'idx_creature_name_source',
    'CREATE UNIQUE INDEX idx_creature_name_source ON creatures (name, source)',
  );
  late final Index idxCreatureCr = Index(
    'idx_creature_cr',
    'CREATE INDEX idx_creature_cr ON creatures (challenge_rating)',
  );
  late final Index idxCreatureType = Index(
    'idx_creature_type',
    'CREATE INDEX idx_creature_type ON creatures (type)',
  );
  late final Index idxActionCreature = Index(
    'idx_action_creature',
    'CREATE INDEX idx_action_creature ON creature_actions (creature_id)',
  );
  late final Index idxTraitCreature = Index(
    'idx_trait_creature',
    'CREATE INDEX idx_trait_creature ON creature_traits (creature_id)',
  );
  late final Index idxSpellcastingCreature = Index(
    'idx_spellcasting_creature',
    'CREATE INDEX idx_spellcasting_creature ON creature_spellcastings (creature_id)',
  );
  late final Index idxSpellSpellcasting = Index(
    'idx_spell_spellcasting',
    'CREATE INDEX idx_spell_spellcasting ON creature_spells (spellcasting_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    players,
    legendaryGroups,
    creatures,
    creatureActions,
    creatureTraits,
    creatureSpellcastings,
    creatureSpells,
    creatureSaves,
    creatureSkills,
    creatureSenses,
    creatureLanguages,
    creatureEnvironments,
    idxCreatureNameSource,
    idxCreatureCr,
    idxCreatureType,
    idxActionCreature,
    idxTraitCreature,
    idxSpellcastingCreature,
    idxSpellSpellcasting,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'legendary_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creatures', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_actions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_traits', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_spellcastings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creature_spellcastings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_spells', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_saves', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_skills', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_senses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_languages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creatures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('creature_environments', kind: UpdateKind.delete)],
    ),
  ]);
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
typedef $$LegendaryGroupsTableCreateCompanionBuilder =
    LegendaryGroupsCompanion Function({
      Value<int> id,
      required String name,
      required String source,
      Value<int?> page,
    });
typedef $$LegendaryGroupsTableUpdateCompanionBuilder =
    LegendaryGroupsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> source,
      Value<int?> page,
    });

final class $$LegendaryGroupsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LegendaryGroupsTable,
          LegendaryGroupRow
        > {
  $$LegendaryGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CreaturesTable, List<CreatureRow>>
  _creaturesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creatures,
    aliasName: 'legendary_groups__id__creatures__legendary_group_id',
  );

  $$CreaturesTableProcessedTableManager get creaturesRefs {
    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.legendaryGroupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creaturesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegendaryGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $LegendaryGroupsTable> {
  $$LegendaryGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> creaturesRefs(
    Expression<bool> Function($$CreaturesTableFilterComposer f) f,
  ) {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.legendaryGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegendaryGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $LegendaryGroupsTable> {
  $$LegendaryGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegendaryGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegendaryGroupsTable> {
  $$LegendaryGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  Expression<T> creaturesRefs<T extends Object>(
    Expression<T> Function($$CreaturesTableAnnotationComposer a) f,
  ) {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.legendaryGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegendaryGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegendaryGroupsTable,
          LegendaryGroupRow,
          $$LegendaryGroupsTableFilterComposer,
          $$LegendaryGroupsTableOrderingComposer,
          $$LegendaryGroupsTableAnnotationComposer,
          $$LegendaryGroupsTableCreateCompanionBuilder,
          $$LegendaryGroupsTableUpdateCompanionBuilder,
          (LegendaryGroupRow, $$LegendaryGroupsTableReferences),
          LegendaryGroupRow,
          PrefetchHooks Function({bool creaturesRefs})
        > {
  $$LegendaryGroupsTableTableManager(
    _$AppDatabase db,
    $LegendaryGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegendaryGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegendaryGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegendaryGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int?> page = const Value.absent(),
              }) => LegendaryGroupsCompanion(
                id: id,
                name: name,
                source: source,
                page: page,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String source,
                Value<int?> page = const Value.absent(),
              }) => LegendaryGroupsCompanion.insert(
                id: id,
                name: name,
                source: source,
                page: page,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegendaryGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creaturesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (creaturesRefs) db.creatures],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (creaturesRefs)
                    await $_getPrefetchedData<
                      LegendaryGroupRow,
                      $LegendaryGroupsTable,
                      CreatureRow
                    >(
                      currentTable: table,
                      referencedTable: $$LegendaryGroupsTableReferences
                          ._creaturesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LegendaryGroupsTableReferences(
                            db,
                            table,
                            p0,
                          ).creaturesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.legendaryGroupId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LegendaryGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegendaryGroupsTable,
      LegendaryGroupRow,
      $$LegendaryGroupsTableFilterComposer,
      $$LegendaryGroupsTableOrderingComposer,
      $$LegendaryGroupsTableAnnotationComposer,
      $$LegendaryGroupsTableCreateCompanionBuilder,
      $$LegendaryGroupsTableUpdateCompanionBuilder,
      (LegendaryGroupRow, $$LegendaryGroupsTableReferences),
      LegendaryGroupRow,
      PrefetchHooks Function({bool creaturesRefs})
    >;
typedef $$CreaturesTableCreateCompanionBuilder =
    CreaturesCompanion Function({
      Value<int> id,
      required String name,
      Value<String> source,
      Value<int?> page,
      Value<bool> isSrd,
      Value<String?> size,
      Value<String?> type,
      Value<String?> typeTags,
      Value<String?> alignment,
      Value<int?> armorClass,
      Value<String?> armorClassType,
      Value<String?> armorClassOther,
      Value<int?> hitPoints,
      Value<String?> hitPointFormula,
      Value<int?> speedWalk,
      Value<int?> speedFly,
      Value<int?> speedSwim,
      Value<int?> speedClimb,
      Value<int?> speedBurrow,
      Value<int> strength,
      Value<int> dexterity,
      Value<int> constitution,
      Value<int> intelligence,
      Value<int> wisdom,
      Value<int> charisma,
      Value<int?> passivePerception,
      Value<String?> challengeRating,
      Value<String?> challengeRatingLair,
      Value<String?> challengeRatingCoven,
      Value<int?> xpOverride,
      Value<String?> damageVulnerabilities,
      Value<String?> damageResistances,
      Value<String?> damageImmunities,
      Value<String?> conditionImmunities,
      Value<int?> legendaryGroupId,
    });
typedef $$CreaturesTableUpdateCompanionBuilder =
    CreaturesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> source,
      Value<int?> page,
      Value<bool> isSrd,
      Value<String?> size,
      Value<String?> type,
      Value<String?> typeTags,
      Value<String?> alignment,
      Value<int?> armorClass,
      Value<String?> armorClassType,
      Value<String?> armorClassOther,
      Value<int?> hitPoints,
      Value<String?> hitPointFormula,
      Value<int?> speedWalk,
      Value<int?> speedFly,
      Value<int?> speedSwim,
      Value<int?> speedClimb,
      Value<int?> speedBurrow,
      Value<int> strength,
      Value<int> dexterity,
      Value<int> constitution,
      Value<int> intelligence,
      Value<int> wisdom,
      Value<int> charisma,
      Value<int?> passivePerception,
      Value<String?> challengeRating,
      Value<String?> challengeRatingLair,
      Value<String?> challengeRatingCoven,
      Value<int?> xpOverride,
      Value<String?> damageVulnerabilities,
      Value<String?> damageResistances,
      Value<String?> damageImmunities,
      Value<String?> conditionImmunities,
      Value<int?> legendaryGroupId,
    });

final class $$CreaturesTableReferences
    extends BaseReferences<_$AppDatabase, $CreaturesTable, CreatureRow> {
  $$CreaturesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LegendaryGroupsTable _legendaryGroupIdTable(_$AppDatabase db) => db
      .legendaryGroups
      .createAlias('creatures__legendary_group_id__legendary_groups__id');

  $$LegendaryGroupsTableProcessedTableManager? get legendaryGroupId {
    final $_column = $_itemColumn<int>('legendary_group_id');
    if ($_column == null) return null;
    final manager = $$LegendaryGroupsTableTableManager(
      $_db,
      $_db.legendaryGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_legendaryGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CreatureActionsTable, List<CreatureActionRow>>
  _creatureActionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creatureActions,
    aliasName: 'creatures__id__creature_actions__creature_id',
  );

  $$CreatureActionsTableProcessedTableManager get creatureActionsRefs {
    final manager = $$CreatureActionsTableTableManager(
      $_db,
      $_db.creatureActions,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creatureActionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreatureTraitsTable, List<CreatureTraitRow>>
  _creatureTraitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creatureTraits,
    aliasName: 'creatures__id__creature_traits__creature_id',
  );

  $$CreatureTraitsTableProcessedTableManager get creatureTraitsRefs {
    final manager = $$CreatureTraitsTableTableManager(
      $_db,
      $_db.creatureTraits,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creatureTraitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CreatureSpellcastingsTable,
    List<CreatureSpellcastingRow>
  >
  _creatureSpellcastingsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.creatureSpellcastings,
        aliasName: 'creatures__id__creature_spellcastings__creature_id',
      );

  $$CreatureSpellcastingsTableProcessedTableManager
  get creatureSpellcastingsRefs {
    final manager = $$CreatureSpellcastingsTableTableManager(
      $_db,
      $_db.creatureSpellcastings,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creatureSpellcastingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreatureSavesTable, List<CreatureSaveRow>>
  _creatureSavesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creatureSaves,
    aliasName: 'creatures__id__creature_saves__creature_id',
  );

  $$CreatureSavesTableProcessedTableManager get creatureSavesRefs {
    final manager = $$CreatureSavesTableTableManager(
      $_db,
      $_db.creatureSaves,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creatureSavesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreatureSkillsTable, List<CreatureSkillRow>>
  _creatureSkillsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creatureSkills,
    aliasName: 'creatures__id__creature_skills__creature_id',
  );

  $$CreatureSkillsTableProcessedTableManager get creatureSkillsRefs {
    final manager = $$CreatureSkillsTableTableManager(
      $_db,
      $_db.creatureSkills,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creatureSkillsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreatureSensesTable, List<CreatureSenseRow>>
  _creatureSensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creatureSenses,
    aliasName: 'creatures__id__creature_senses__creature_id',
  );

  $$CreatureSensesTableProcessedTableManager get creatureSensesRefs {
    final manager = $$CreatureSensesTableTableManager(
      $_db,
      $_db.creatureSenses,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creatureSensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreatureLanguagesTable, List<CreatureLanguageRow>>
  _creatureLanguagesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.creatureLanguages,
        aliasName: 'creatures__id__creature_languages__creature_id',
      );

  $$CreatureLanguagesTableProcessedTableManager get creatureLanguagesRefs {
    final manager = $$CreatureLanguagesTableTableManager(
      $_db,
      $_db.creatureLanguages,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creatureLanguagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CreatureEnvironmentsTable,
    List<CreatureEnvironmentRow>
  >
  _creatureEnvironmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.creatureEnvironments,
        aliasName: 'creatures__id__creature_environments__creature_id',
      );

  $$CreatureEnvironmentsTableProcessedTableManager
  get creatureEnvironmentsRefs {
    final manager = $$CreatureEnvironmentsTableTableManager(
      $_db,
      $_db.creatureEnvironments,
    ).filter((f) => f.creatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _creatureEnvironmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CreaturesTableFilterComposer
    extends Composer<_$AppDatabase, $CreaturesTable> {
  $$CreaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSrd => $composableBuilder(
    column: $table.isSrd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeTags => $composableBuilder(
    column: $table.typeTags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alignment => $composableBuilder(
    column: $table.alignment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get armorClassType => $composableBuilder(
    column: $table.armorClassType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get armorClassOther => $composableBuilder(
    column: $table.armorClassOther,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hitPoints => $composableBuilder(
    column: $table.hitPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hitPointFormula => $composableBuilder(
    column: $table.hitPointFormula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedWalk => $composableBuilder(
    column: $table.speedWalk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedFly => $composableBuilder(
    column: $table.speedFly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedSwim => $composableBuilder(
    column: $table.speedSwim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedClimb => $composableBuilder(
    column: $table.speedClimb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedBurrow => $composableBuilder(
    column: $table.speedBurrow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dexterity => $composableBuilder(
    column: $table.dexterity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wisdom => $composableBuilder(
    column: $table.wisdom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get charisma => $composableBuilder(
    column: $table.charisma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passivePerception => $composableBuilder(
    column: $table.passivePerception,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeRating => $composableBuilder(
    column: $table.challengeRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeRatingLair => $composableBuilder(
    column: $table.challengeRatingLair,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeRatingCoven => $composableBuilder(
    column: $table.challengeRatingCoven,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpOverride => $composableBuilder(
    column: $table.xpOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageVulnerabilities => $composableBuilder(
    column: $table.damageVulnerabilities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageResistances => $composableBuilder(
    column: $table.damageResistances,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageImmunities => $composableBuilder(
    column: $table.damageImmunities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionImmunities => $composableBuilder(
    column: $table.conditionImmunities,
    builder: (column) => ColumnFilters(column),
  );

  $$LegendaryGroupsTableFilterComposer get legendaryGroupId {
    final $$LegendaryGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legendaryGroupId,
      referencedTable: $db.legendaryGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegendaryGroupsTableFilterComposer(
            $db: $db,
            $table: $db.legendaryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> creatureActionsRefs(
    Expression<bool> Function($$CreatureActionsTableFilterComposer f) f,
  ) {
    final $$CreatureActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureActions,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureActionsTableFilterComposer(
            $db: $db,
            $table: $db.creatureActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creatureTraitsRefs(
    Expression<bool> Function($$CreatureTraitsTableFilterComposer f) f,
  ) {
    final $$CreatureTraitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureTraits,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureTraitsTableFilterComposer(
            $db: $db,
            $table: $db.creatureTraits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creatureSpellcastingsRefs(
    Expression<bool> Function($$CreatureSpellcastingsTableFilterComposer f) f,
  ) {
    final $$CreatureSpellcastingsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creatureSpellcastings,
          getReferencedColumn: (t) => t.creatureId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreatureSpellcastingsTableFilterComposer(
                $db: $db,
                $table: $db.creatureSpellcastings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> creatureSavesRefs(
    Expression<bool> Function($$CreatureSavesTableFilterComposer f) f,
  ) {
    final $$CreatureSavesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSaves,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSavesTableFilterComposer(
            $db: $db,
            $table: $db.creatureSaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creatureSkillsRefs(
    Expression<bool> Function($$CreatureSkillsTableFilterComposer f) f,
  ) {
    final $$CreatureSkillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSkills,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSkillsTableFilterComposer(
            $db: $db,
            $table: $db.creatureSkills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creatureSensesRefs(
    Expression<bool> Function($$CreatureSensesTableFilterComposer f) f,
  ) {
    final $$CreatureSensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSenses,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSensesTableFilterComposer(
            $db: $db,
            $table: $db.creatureSenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creatureLanguagesRefs(
    Expression<bool> Function($$CreatureLanguagesTableFilterComposer f) f,
  ) {
    final $$CreatureLanguagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureLanguages,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureLanguagesTableFilterComposer(
            $db: $db,
            $table: $db.creatureLanguages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creatureEnvironmentsRefs(
    Expression<bool> Function($$CreatureEnvironmentsTableFilterComposer f) f,
  ) {
    final $$CreatureEnvironmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureEnvironments,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureEnvironmentsTableFilterComposer(
            $db: $db,
            $table: $db.creatureEnvironments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreaturesTable> {
  $$CreaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSrd => $composableBuilder(
    column: $table.isSrd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeTags => $composableBuilder(
    column: $table.typeTags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alignment => $composableBuilder(
    column: $table.alignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get armorClassType => $composableBuilder(
    column: $table.armorClassType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get armorClassOther => $composableBuilder(
    column: $table.armorClassOther,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hitPoints => $composableBuilder(
    column: $table.hitPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hitPointFormula => $composableBuilder(
    column: $table.hitPointFormula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedWalk => $composableBuilder(
    column: $table.speedWalk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedFly => $composableBuilder(
    column: $table.speedFly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedSwim => $composableBuilder(
    column: $table.speedSwim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedClimb => $composableBuilder(
    column: $table.speedClimb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedBurrow => $composableBuilder(
    column: $table.speedBurrow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dexterity => $composableBuilder(
    column: $table.dexterity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wisdom => $composableBuilder(
    column: $table.wisdom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get charisma => $composableBuilder(
    column: $table.charisma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passivePerception => $composableBuilder(
    column: $table.passivePerception,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeRating => $composableBuilder(
    column: $table.challengeRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeRatingLair => $composableBuilder(
    column: $table.challengeRatingLair,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeRatingCoven => $composableBuilder(
    column: $table.challengeRatingCoven,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpOverride => $composableBuilder(
    column: $table.xpOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageVulnerabilities => $composableBuilder(
    column: $table.damageVulnerabilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageResistances => $composableBuilder(
    column: $table.damageResistances,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageImmunities => $composableBuilder(
    column: $table.damageImmunities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionImmunities => $composableBuilder(
    column: $table.conditionImmunities,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegendaryGroupsTableOrderingComposer get legendaryGroupId {
    final $$LegendaryGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legendaryGroupId,
      referencedTable: $db.legendaryGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegendaryGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.legendaryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreaturesTable> {
  $$CreaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<bool> get isSrd =>
      $composableBuilder(column: $table.isSrd, builder: (column) => column);

  GeneratedColumn<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get typeTags =>
      $composableBuilder(column: $table.typeTags, builder: (column) => column);

  GeneratedColumn<String> get alignment =>
      $composableBuilder(column: $table.alignment, builder: (column) => column);

  GeneratedColumn<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => column,
  );

  GeneratedColumn<String> get armorClassType => $composableBuilder(
    column: $table.armorClassType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get armorClassOther => $composableBuilder(
    column: $table.armorClassOther,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hitPoints =>
      $composableBuilder(column: $table.hitPoints, builder: (column) => column);

  GeneratedColumn<String> get hitPointFormula => $composableBuilder(
    column: $table.hitPointFormula,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speedWalk =>
      $composableBuilder(column: $table.speedWalk, builder: (column) => column);

  GeneratedColumn<int> get speedFly =>
      $composableBuilder(column: $table.speedFly, builder: (column) => column);

  GeneratedColumn<int> get speedSwim =>
      $composableBuilder(column: $table.speedSwim, builder: (column) => column);

  GeneratedColumn<int> get speedClimb => $composableBuilder(
    column: $table.speedClimb,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speedBurrow => $composableBuilder(
    column: $table.speedBurrow,
    builder: (column) => column,
  );

  GeneratedColumn<int> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<int> get dexterity =>
      $composableBuilder(column: $table.dexterity, builder: (column) => column);

  GeneratedColumn<int> get constitution => $composableBuilder(
    column: $table.constitution,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wisdom =>
      $composableBuilder(column: $table.wisdom, builder: (column) => column);

  GeneratedColumn<int> get charisma =>
      $composableBuilder(column: $table.charisma, builder: (column) => column);

  GeneratedColumn<int> get passivePerception => $composableBuilder(
    column: $table.passivePerception,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeRating => $composableBuilder(
    column: $table.challengeRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeRatingLair => $composableBuilder(
    column: $table.challengeRatingLair,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeRatingCoven => $composableBuilder(
    column: $table.challengeRatingCoven,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xpOverride => $composableBuilder(
    column: $table.xpOverride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damageVulnerabilities => $composableBuilder(
    column: $table.damageVulnerabilities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damageResistances => $composableBuilder(
    column: $table.damageResistances,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damageImmunities => $composableBuilder(
    column: $table.damageImmunities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditionImmunities => $composableBuilder(
    column: $table.conditionImmunities,
    builder: (column) => column,
  );

  $$LegendaryGroupsTableAnnotationComposer get legendaryGroupId {
    final $$LegendaryGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legendaryGroupId,
      referencedTable: $db.legendaryGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegendaryGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.legendaryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> creatureActionsRefs<T extends Object>(
    Expression<T> Function($$CreatureActionsTableAnnotationComposer a) f,
  ) {
    final $$CreatureActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureActions,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.creatureActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creatureTraitsRefs<T extends Object>(
    Expression<T> Function($$CreatureTraitsTableAnnotationComposer a) f,
  ) {
    final $$CreatureTraitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureTraits,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureTraitsTableAnnotationComposer(
            $db: $db,
            $table: $db.creatureTraits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creatureSpellcastingsRefs<T extends Object>(
    Expression<T> Function($$CreatureSpellcastingsTableAnnotationComposer a) f,
  ) {
    final $$CreatureSpellcastingsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creatureSpellcastings,
          getReferencedColumn: (t) => t.creatureId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreatureSpellcastingsTableAnnotationComposer(
                $db: $db,
                $table: $db.creatureSpellcastings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> creatureSavesRefs<T extends Object>(
    Expression<T> Function($$CreatureSavesTableAnnotationComposer a) f,
  ) {
    final $$CreatureSavesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSaves,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSavesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatureSaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creatureSkillsRefs<T extends Object>(
    Expression<T> Function($$CreatureSkillsTableAnnotationComposer a) f,
  ) {
    final $$CreatureSkillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSkills,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSkillsTableAnnotationComposer(
            $db: $db,
            $table: $db.creatureSkills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creatureSensesRefs<T extends Object>(
    Expression<T> Function($$CreatureSensesTableAnnotationComposer a) f,
  ) {
    final $$CreatureSensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSenses,
      getReferencedColumn: (t) => t.creatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSensesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatureSenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creatureLanguagesRefs<T extends Object>(
    Expression<T> Function($$CreatureLanguagesTableAnnotationComposer a) f,
  ) {
    final $$CreatureLanguagesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creatureLanguages,
          getReferencedColumn: (t) => t.creatureId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreatureLanguagesTableAnnotationComposer(
                $db: $db,
                $table: $db.creatureLanguages,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> creatureEnvironmentsRefs<T extends Object>(
    Expression<T> Function($$CreatureEnvironmentsTableAnnotationComposer a) f,
  ) {
    final $$CreatureEnvironmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.creatureEnvironments,
          getReferencedColumn: (t) => t.creatureId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreatureEnvironmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.creatureEnvironments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CreaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreaturesTable,
          CreatureRow,
          $$CreaturesTableFilterComposer,
          $$CreaturesTableOrderingComposer,
          $$CreaturesTableAnnotationComposer,
          $$CreaturesTableCreateCompanionBuilder,
          $$CreaturesTableUpdateCompanionBuilder,
          (CreatureRow, $$CreaturesTableReferences),
          CreatureRow,
          PrefetchHooks Function({
            bool legendaryGroupId,
            bool creatureActionsRefs,
            bool creatureTraitsRefs,
            bool creatureSpellcastingsRefs,
            bool creatureSavesRefs,
            bool creatureSkillsRefs,
            bool creatureSensesRefs,
            bool creatureLanguagesRefs,
            bool creatureEnvironmentsRefs,
          })
        > {
  $$CreaturesTableTableManager(_$AppDatabase db, $CreaturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int?> page = const Value.absent(),
                Value<bool> isSrd = const Value.absent(),
                Value<String?> size = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> typeTags = const Value.absent(),
                Value<String?> alignment = const Value.absent(),
                Value<int?> armorClass = const Value.absent(),
                Value<String?> armorClassType = const Value.absent(),
                Value<String?> armorClassOther = const Value.absent(),
                Value<int?> hitPoints = const Value.absent(),
                Value<String?> hitPointFormula = const Value.absent(),
                Value<int?> speedWalk = const Value.absent(),
                Value<int?> speedFly = const Value.absent(),
                Value<int?> speedSwim = const Value.absent(),
                Value<int?> speedClimb = const Value.absent(),
                Value<int?> speedBurrow = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> dexterity = const Value.absent(),
                Value<int> constitution = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> wisdom = const Value.absent(),
                Value<int> charisma = const Value.absent(),
                Value<int?> passivePerception = const Value.absent(),
                Value<String?> challengeRating = const Value.absent(),
                Value<String?> challengeRatingLair = const Value.absent(),
                Value<String?> challengeRatingCoven = const Value.absent(),
                Value<int?> xpOverride = const Value.absent(),
                Value<String?> damageVulnerabilities = const Value.absent(),
                Value<String?> damageResistances = const Value.absent(),
                Value<String?> damageImmunities = const Value.absent(),
                Value<String?> conditionImmunities = const Value.absent(),
                Value<int?> legendaryGroupId = const Value.absent(),
              }) => CreaturesCompanion(
                id: id,
                name: name,
                source: source,
                page: page,
                isSrd: isSrd,
                size: size,
                type: type,
                typeTags: typeTags,
                alignment: alignment,
                armorClass: armorClass,
                armorClassType: armorClassType,
                armorClassOther: armorClassOther,
                hitPoints: hitPoints,
                hitPointFormula: hitPointFormula,
                speedWalk: speedWalk,
                speedFly: speedFly,
                speedSwim: speedSwim,
                speedClimb: speedClimb,
                speedBurrow: speedBurrow,
                strength: strength,
                dexterity: dexterity,
                constitution: constitution,
                intelligence: intelligence,
                wisdom: wisdom,
                charisma: charisma,
                passivePerception: passivePerception,
                challengeRating: challengeRating,
                challengeRatingLair: challengeRatingLair,
                challengeRatingCoven: challengeRatingCoven,
                xpOverride: xpOverride,
                damageVulnerabilities: damageVulnerabilities,
                damageResistances: damageResistances,
                damageImmunities: damageImmunities,
                conditionImmunities: conditionImmunities,
                legendaryGroupId: legendaryGroupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> source = const Value.absent(),
                Value<int?> page = const Value.absent(),
                Value<bool> isSrd = const Value.absent(),
                Value<String?> size = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> typeTags = const Value.absent(),
                Value<String?> alignment = const Value.absent(),
                Value<int?> armorClass = const Value.absent(),
                Value<String?> armorClassType = const Value.absent(),
                Value<String?> armorClassOther = const Value.absent(),
                Value<int?> hitPoints = const Value.absent(),
                Value<String?> hitPointFormula = const Value.absent(),
                Value<int?> speedWalk = const Value.absent(),
                Value<int?> speedFly = const Value.absent(),
                Value<int?> speedSwim = const Value.absent(),
                Value<int?> speedClimb = const Value.absent(),
                Value<int?> speedBurrow = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> dexterity = const Value.absent(),
                Value<int> constitution = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> wisdom = const Value.absent(),
                Value<int> charisma = const Value.absent(),
                Value<int?> passivePerception = const Value.absent(),
                Value<String?> challengeRating = const Value.absent(),
                Value<String?> challengeRatingLair = const Value.absent(),
                Value<String?> challengeRatingCoven = const Value.absent(),
                Value<int?> xpOverride = const Value.absent(),
                Value<String?> damageVulnerabilities = const Value.absent(),
                Value<String?> damageResistances = const Value.absent(),
                Value<String?> damageImmunities = const Value.absent(),
                Value<String?> conditionImmunities = const Value.absent(),
                Value<int?> legendaryGroupId = const Value.absent(),
              }) => CreaturesCompanion.insert(
                id: id,
                name: name,
                source: source,
                page: page,
                isSrd: isSrd,
                size: size,
                type: type,
                typeTags: typeTags,
                alignment: alignment,
                armorClass: armorClass,
                armorClassType: armorClassType,
                armorClassOther: armorClassOther,
                hitPoints: hitPoints,
                hitPointFormula: hitPointFormula,
                speedWalk: speedWalk,
                speedFly: speedFly,
                speedSwim: speedSwim,
                speedClimb: speedClimb,
                speedBurrow: speedBurrow,
                strength: strength,
                dexterity: dexterity,
                constitution: constitution,
                intelligence: intelligence,
                wisdom: wisdom,
                charisma: charisma,
                passivePerception: passivePerception,
                challengeRating: challengeRating,
                challengeRatingLair: challengeRatingLair,
                challengeRatingCoven: challengeRatingCoven,
                xpOverride: xpOverride,
                damageVulnerabilities: damageVulnerabilities,
                damageResistances: damageResistances,
                damageImmunities: damageImmunities,
                conditionImmunities: conditionImmunities,
                legendaryGroupId: legendaryGroupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreaturesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                legendaryGroupId = false,
                creatureActionsRefs = false,
                creatureTraitsRefs = false,
                creatureSpellcastingsRefs = false,
                creatureSavesRefs = false,
                creatureSkillsRefs = false,
                creatureSensesRefs = false,
                creatureLanguagesRefs = false,
                creatureEnvironmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (creatureActionsRefs) db.creatureActions,
                    if (creatureTraitsRefs) db.creatureTraits,
                    if (creatureSpellcastingsRefs) db.creatureSpellcastings,
                    if (creatureSavesRefs) db.creatureSaves,
                    if (creatureSkillsRefs) db.creatureSkills,
                    if (creatureSensesRefs) db.creatureSenses,
                    if (creatureLanguagesRefs) db.creatureLanguages,
                    if (creatureEnvironmentsRefs) db.creatureEnvironments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (legendaryGroupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.legendaryGroupId,
                                    referencedTable: $$CreaturesTableReferences
                                        ._legendaryGroupIdTable(db),
                                    referencedColumn: $$CreaturesTableReferences
                                        ._legendaryGroupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (creatureActionsRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureActionRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureActionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creatureTraitsRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureTraitRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureTraitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureTraitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creatureSpellcastingsRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureSpellcastingRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureSpellcastingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureSpellcastingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creatureSavesRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureSaveRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureSavesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureSavesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creatureSkillsRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureSkillRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureSkillsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureSkillsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creatureSensesRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureSenseRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureSensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureSensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creatureLanguagesRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureLanguageRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureLanguagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureLanguagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (creatureEnvironmentsRefs)
                        await $_getPrefetchedData<
                          CreatureRow,
                          $CreaturesTable,
                          CreatureEnvironmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreaturesTableReferences
                              ._creatureEnvironmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureEnvironmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CreaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreaturesTable,
      CreatureRow,
      $$CreaturesTableFilterComposer,
      $$CreaturesTableOrderingComposer,
      $$CreaturesTableAnnotationComposer,
      $$CreaturesTableCreateCompanionBuilder,
      $$CreaturesTableUpdateCompanionBuilder,
      (CreatureRow, $$CreaturesTableReferences),
      CreatureRow,
      PrefetchHooks Function({
        bool legendaryGroupId,
        bool creatureActionsRefs,
        bool creatureTraitsRefs,
        bool creatureSpellcastingsRefs,
        bool creatureSavesRefs,
        bool creatureSkillsRefs,
        bool creatureSensesRefs,
        bool creatureLanguagesRefs,
        bool creatureEnvironmentsRefs,
      })
    >;
typedef $$CreatureActionsTableCreateCompanionBuilder =
    CreatureActionsCompanion Function({
      Value<int> id,
      required int creatureId,
      required String name,
      required String description,
      required int sortOrder,
      required String kind,
    });
typedef $$CreatureActionsTableUpdateCompanionBuilder =
    CreatureActionsCompanion Function({
      Value<int> id,
      Value<int> creatureId,
      Value<String> name,
      Value<String> description,
      Value<int> sortOrder,
      Value<String> kind,
    });

final class $$CreatureActionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CreatureActionsTable,
          CreatureActionRow
        > {
  $$CreatureActionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) =>
      db.creatures.createAlias('creature_actions__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureActionsTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureActionsTable> {
  $$CreatureActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureActionsTable> {
  $$CreatureActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureActionsTable> {
  $$CreatureActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureActionsTable,
          CreatureActionRow,
          $$CreatureActionsTableFilterComposer,
          $$CreatureActionsTableOrderingComposer,
          $$CreatureActionsTableAnnotationComposer,
          $$CreatureActionsTableCreateCompanionBuilder,
          $$CreatureActionsTableUpdateCompanionBuilder,
          (CreatureActionRow, $$CreatureActionsTableReferences),
          CreatureActionRow,
          PrefetchHooks Function({bool creatureId})
        > {
  $$CreatureActionsTableTableManager(
    _$AppDatabase db,
    $CreatureActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> creatureId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> kind = const Value.absent(),
              }) => CreatureActionsCompanion(
                id: id,
                creatureId: creatureId,
                name: name,
                description: description,
                sortOrder: sortOrder,
                kind: kind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int creatureId,
                required String name,
                required String description,
                required int sortOrder,
                required String kind,
              }) => CreatureActionsCompanion.insert(
                id: id,
                creatureId: creatureId,
                name: name,
                description: description,
                sortOrder: sortOrder,
                kind: kind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureActionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.creatureId,
                                referencedTable:
                                    $$CreatureActionsTableReferences
                                        ._creatureIdTable(db),
                                referencedColumn:
                                    $$CreatureActionsTableReferences
                                        ._creatureIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureActionsTable,
      CreatureActionRow,
      $$CreatureActionsTableFilterComposer,
      $$CreatureActionsTableOrderingComposer,
      $$CreatureActionsTableAnnotationComposer,
      $$CreatureActionsTableCreateCompanionBuilder,
      $$CreatureActionsTableUpdateCompanionBuilder,
      (CreatureActionRow, $$CreatureActionsTableReferences),
      CreatureActionRow,
      PrefetchHooks Function({bool creatureId})
    >;
typedef $$CreatureTraitsTableCreateCompanionBuilder =
    CreatureTraitsCompanion Function({
      Value<int> id,
      required int creatureId,
      required String name,
      required String description,
      required int sortOrder,
    });
typedef $$CreatureTraitsTableUpdateCompanionBuilder =
    CreatureTraitsCompanion Function({
      Value<int> id,
      Value<int> creatureId,
      Value<String> name,
      Value<String> description,
      Value<int> sortOrder,
    });

final class $$CreatureTraitsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CreatureTraitsTable, CreatureTraitRow> {
  $$CreatureTraitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) =>
      db.creatures.createAlias('creature_traits__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureTraitsTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureTraitsTable> {
  $$CreatureTraitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureTraitsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureTraitsTable> {
  $$CreatureTraitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureTraitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureTraitsTable> {
  $$CreatureTraitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureTraitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureTraitsTable,
          CreatureTraitRow,
          $$CreatureTraitsTableFilterComposer,
          $$CreatureTraitsTableOrderingComposer,
          $$CreatureTraitsTableAnnotationComposer,
          $$CreatureTraitsTableCreateCompanionBuilder,
          $$CreatureTraitsTableUpdateCompanionBuilder,
          (CreatureTraitRow, $$CreatureTraitsTableReferences),
          CreatureTraitRow,
          PrefetchHooks Function({bool creatureId})
        > {
  $$CreatureTraitsTableTableManager(
    _$AppDatabase db,
    $CreatureTraitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureTraitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureTraitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureTraitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> creatureId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CreatureTraitsCompanion(
                id: id,
                creatureId: creatureId,
                name: name,
                description: description,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int creatureId,
                required String name,
                required String description,
                required int sortOrder,
              }) => CreatureTraitsCompanion.insert(
                id: id,
                creatureId: creatureId,
                name: name,
                description: description,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureTraitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.creatureId,
                                referencedTable: $$CreatureTraitsTableReferences
                                    ._creatureIdTable(db),
                                referencedColumn:
                                    $$CreatureTraitsTableReferences
                                        ._creatureIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureTraitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureTraitsTable,
      CreatureTraitRow,
      $$CreatureTraitsTableFilterComposer,
      $$CreatureTraitsTableOrderingComposer,
      $$CreatureTraitsTableAnnotationComposer,
      $$CreatureTraitsTableCreateCompanionBuilder,
      $$CreatureTraitsTableUpdateCompanionBuilder,
      (CreatureTraitRow, $$CreatureTraitsTableReferences),
      CreatureTraitRow,
      PrefetchHooks Function({bool creatureId})
    >;
typedef $$CreatureSpellcastingsTableCreateCompanionBuilder =
    CreatureSpellcastingsCompanion Function({
      Value<int> id,
      required int creatureId,
      required String name,
      Value<String?> headerText,
      Value<String?> footerText,
      Value<String?> ability,
      Value<String?> hiddenUses,
      Value<int> sortOrder,
    });
typedef $$CreatureSpellcastingsTableUpdateCompanionBuilder =
    CreatureSpellcastingsCompanion Function({
      Value<int> id,
      Value<int> creatureId,
      Value<String> name,
      Value<String?> headerText,
      Value<String?> footerText,
      Value<String?> ability,
      Value<String?> hiddenUses,
      Value<int> sortOrder,
    });

final class $$CreatureSpellcastingsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CreatureSpellcastingsTable,
          CreatureSpellcastingRow
        > {
  $$CreatureSpellcastingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) => db.creatures
      .createAlias('creature_spellcastings__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CreatureSpellsTable, List<CreatureSpellRow>>
  _creatureSpellsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creatureSpells,
    aliasName: 'creature_spellcastings__id__creature_spells__spellcasting_id',
  );

  $$CreatureSpellsTableProcessedTableManager get creatureSpellsRefs {
    final manager = $$CreatureSpellsTableTableManager(
      $_db,
      $_db.creatureSpells,
    ).filter((f) => f.spellcastingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_creatureSpellsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CreatureSpellcastingsTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureSpellcastingsTable> {
  $$CreatureSpellcastingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headerText => $composableBuilder(
    column: $table.headerText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get footerText => $composableBuilder(
    column: $table.footerText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ability => $composableBuilder(
    column: $table.ability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hiddenUses => $composableBuilder(
    column: $table.hiddenUses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> creatureSpellsRefs(
    Expression<bool> Function($$CreatureSpellsTableFilterComposer f) f,
  ) {
    final $$CreatureSpellsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSpells,
      getReferencedColumn: (t) => t.spellcastingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSpellsTableFilterComposer(
            $db: $db,
            $table: $db.creatureSpells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreatureSpellcastingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureSpellcastingsTable> {
  $$CreatureSpellcastingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headerText => $composableBuilder(
    column: $table.headerText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get footerText => $composableBuilder(
    column: $table.footerText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ability => $composableBuilder(
    column: $table.ability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiddenUses => $composableBuilder(
    column: $table.hiddenUses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSpellcastingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureSpellcastingsTable> {
  $$CreatureSpellcastingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get headerText => $composableBuilder(
    column: $table.headerText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get footerText => $composableBuilder(
    column: $table.footerText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ability =>
      $composableBuilder(column: $table.ability, builder: (column) => column);

  GeneratedColumn<String> get hiddenUses => $composableBuilder(
    column: $table.hiddenUses,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> creatureSpellsRefs<T extends Object>(
    Expression<T> Function($$CreatureSpellsTableAnnotationComposer a) f,
  ) {
    final $$CreatureSpellsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creatureSpells,
      getReferencedColumn: (t) => t.spellcastingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreatureSpellsTableAnnotationComposer(
            $db: $db,
            $table: $db.creatureSpells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreatureSpellcastingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureSpellcastingsTable,
          CreatureSpellcastingRow,
          $$CreatureSpellcastingsTableFilterComposer,
          $$CreatureSpellcastingsTableOrderingComposer,
          $$CreatureSpellcastingsTableAnnotationComposer,
          $$CreatureSpellcastingsTableCreateCompanionBuilder,
          $$CreatureSpellcastingsTableUpdateCompanionBuilder,
          (CreatureSpellcastingRow, $$CreatureSpellcastingsTableReferences),
          CreatureSpellcastingRow,
          PrefetchHooks Function({bool creatureId, bool creatureSpellsRefs})
        > {
  $$CreatureSpellcastingsTableTableManager(
    _$AppDatabase db,
    $CreatureSpellcastingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureSpellcastingsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CreatureSpellcastingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CreatureSpellcastingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> creatureId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> headerText = const Value.absent(),
                Value<String?> footerText = const Value.absent(),
                Value<String?> ability = const Value.absent(),
                Value<String?> hiddenUses = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CreatureSpellcastingsCompanion(
                id: id,
                creatureId: creatureId,
                name: name,
                headerText: headerText,
                footerText: footerText,
                ability: ability,
                hiddenUses: hiddenUses,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int creatureId,
                required String name,
                Value<String?> headerText = const Value.absent(),
                Value<String?> footerText = const Value.absent(),
                Value<String?> ability = const Value.absent(),
                Value<String?> hiddenUses = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CreatureSpellcastingsCompanion.insert(
                id: id,
                creatureId: creatureId,
                name: name,
                headerText: headerText,
                footerText: footerText,
                ability: ability,
                hiddenUses: hiddenUses,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureSpellcastingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({creatureId = false, creatureSpellsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (creatureSpellsRefs) db.creatureSpells,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (creatureId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.creatureId,
                                    referencedTable:
                                        $$CreatureSpellcastingsTableReferences
                                            ._creatureIdTable(db),
                                    referencedColumn:
                                        $$CreatureSpellcastingsTableReferences
                                            ._creatureIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (creatureSpellsRefs)
                        await $_getPrefetchedData<
                          CreatureSpellcastingRow,
                          $CreatureSpellcastingsTable,
                          CreatureSpellRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$CreatureSpellcastingsTableReferences
                                  ._creatureSpellsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreatureSpellcastingsTableReferences(
                                db,
                                table,
                                p0,
                              ).creatureSpellsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.spellcastingId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CreatureSpellcastingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureSpellcastingsTable,
      CreatureSpellcastingRow,
      $$CreatureSpellcastingsTableFilterComposer,
      $$CreatureSpellcastingsTableOrderingComposer,
      $$CreatureSpellcastingsTableAnnotationComposer,
      $$CreatureSpellcastingsTableCreateCompanionBuilder,
      $$CreatureSpellcastingsTableUpdateCompanionBuilder,
      (CreatureSpellcastingRow, $$CreatureSpellcastingsTableReferences),
      CreatureSpellcastingRow,
      PrefetchHooks Function({bool creatureId, bool creatureSpellsRefs})
    >;
typedef $$CreatureSpellsTableCreateCompanionBuilder =
    CreatureSpellsCompanion Function({
      Value<int> id,
      required int spellcastingId,
      required String spellName,
      Value<int?> spellLevel,
      Value<String?> uses,
      Value<int?> slots,
      required int sortOrder,
    });
typedef $$CreatureSpellsTableUpdateCompanionBuilder =
    CreatureSpellsCompanion Function({
      Value<int> id,
      Value<int> spellcastingId,
      Value<String> spellName,
      Value<int?> spellLevel,
      Value<String?> uses,
      Value<int?> slots,
      Value<int> sortOrder,
    });

final class $$CreatureSpellsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CreatureSpellsTable, CreatureSpellRow> {
  $$CreatureSpellsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreatureSpellcastingsTable _spellcastingIdTable(_$AppDatabase db) =>
      db.creatureSpellcastings.createAlias(
        'creature_spells__spellcasting_id__creature_spellcastings__id',
      );

  $$CreatureSpellcastingsTableProcessedTableManager get spellcastingId {
    final $_column = $_itemColumn<int>('spellcasting_id')!;

    final manager = $$CreatureSpellcastingsTableTableManager(
      $_db,
      $_db.creatureSpellcastings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_spellcastingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureSpellsTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureSpellsTable> {
  $$CreatureSpellsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spellName => $composableBuilder(
    column: $table.spellName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spellLevel => $composableBuilder(
    column: $table.spellLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uses => $composableBuilder(
    column: $table.uses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slots => $composableBuilder(
    column: $table.slots,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CreatureSpellcastingsTableFilterComposer get spellcastingId {
    final $$CreatureSpellcastingsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.spellcastingId,
          referencedTable: $db.creatureSpellcastings,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreatureSpellcastingsTableFilterComposer(
                $db: $db,
                $table: $db.creatureSpellcastings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CreatureSpellsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureSpellsTable> {
  $$CreatureSpellsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spellName => $composableBuilder(
    column: $table.spellName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spellLevel => $composableBuilder(
    column: $table.spellLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uses => $composableBuilder(
    column: $table.uses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slots => $composableBuilder(
    column: $table.slots,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreatureSpellcastingsTableOrderingComposer get spellcastingId {
    final $$CreatureSpellcastingsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.spellcastingId,
          referencedTable: $db.creatureSpellcastings,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreatureSpellcastingsTableOrderingComposer(
                $db: $db,
                $table: $db.creatureSpellcastings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CreatureSpellsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureSpellsTable> {
  $$CreatureSpellsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spellName =>
      $composableBuilder(column: $table.spellName, builder: (column) => column);

  GeneratedColumn<int> get spellLevel => $composableBuilder(
    column: $table.spellLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uses =>
      $composableBuilder(column: $table.uses, builder: (column) => column);

  GeneratedColumn<int> get slots =>
      $composableBuilder(column: $table.slots, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CreatureSpellcastingsTableAnnotationComposer get spellcastingId {
    final $$CreatureSpellcastingsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.spellcastingId,
          referencedTable: $db.creatureSpellcastings,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CreatureSpellcastingsTableAnnotationComposer(
                $db: $db,
                $table: $db.creatureSpellcastings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CreatureSpellsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureSpellsTable,
          CreatureSpellRow,
          $$CreatureSpellsTableFilterComposer,
          $$CreatureSpellsTableOrderingComposer,
          $$CreatureSpellsTableAnnotationComposer,
          $$CreatureSpellsTableCreateCompanionBuilder,
          $$CreatureSpellsTableUpdateCompanionBuilder,
          (CreatureSpellRow, $$CreatureSpellsTableReferences),
          CreatureSpellRow,
          PrefetchHooks Function({bool spellcastingId})
        > {
  $$CreatureSpellsTableTableManager(
    _$AppDatabase db,
    $CreatureSpellsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureSpellsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureSpellsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureSpellsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> spellcastingId = const Value.absent(),
                Value<String> spellName = const Value.absent(),
                Value<int?> spellLevel = const Value.absent(),
                Value<String?> uses = const Value.absent(),
                Value<int?> slots = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CreatureSpellsCompanion(
                id: id,
                spellcastingId: spellcastingId,
                spellName: spellName,
                spellLevel: spellLevel,
                uses: uses,
                slots: slots,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int spellcastingId,
                required String spellName,
                Value<int?> spellLevel = const Value.absent(),
                Value<String?> uses = const Value.absent(),
                Value<int?> slots = const Value.absent(),
                required int sortOrder,
              }) => CreatureSpellsCompanion.insert(
                id: id,
                spellcastingId: spellcastingId,
                spellName: spellName,
                spellLevel: spellLevel,
                uses: uses,
                slots: slots,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureSpellsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({spellcastingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (spellcastingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.spellcastingId,
                                referencedTable: $$CreatureSpellsTableReferences
                                    ._spellcastingIdTable(db),
                                referencedColumn:
                                    $$CreatureSpellsTableReferences
                                        ._spellcastingIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureSpellsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureSpellsTable,
      CreatureSpellRow,
      $$CreatureSpellsTableFilterComposer,
      $$CreatureSpellsTableOrderingComposer,
      $$CreatureSpellsTableAnnotationComposer,
      $$CreatureSpellsTableCreateCompanionBuilder,
      $$CreatureSpellsTableUpdateCompanionBuilder,
      (CreatureSpellRow, $$CreatureSpellsTableReferences),
      CreatureSpellRow,
      PrefetchHooks Function({bool spellcastingId})
    >;
typedef $$CreatureSavesTableCreateCompanionBuilder =
    CreatureSavesCompanion Function({
      required int creatureId,
      required String ability,
      required int bonus,
      Value<int> rowid,
    });
typedef $$CreatureSavesTableUpdateCompanionBuilder =
    CreatureSavesCompanion Function({
      Value<int> creatureId,
      Value<String> ability,
      Value<int> bonus,
      Value<int> rowid,
    });

final class $$CreatureSavesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CreatureSavesTable, CreatureSaveRow> {
  $$CreatureSavesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) =>
      db.creatures.createAlias('creature_saves__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureSavesTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureSavesTable> {
  $$CreatureSavesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ability => $composableBuilder(
    column: $table.ability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSavesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureSavesTable> {
  $$CreatureSavesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ability => $composableBuilder(
    column: $table.ability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSavesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureSavesTable> {
  $$CreatureSavesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ability =>
      $composableBuilder(column: $table.ability, builder: (column) => column);

  GeneratedColumn<int> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSavesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureSavesTable,
          CreatureSaveRow,
          $$CreatureSavesTableFilterComposer,
          $$CreatureSavesTableOrderingComposer,
          $$CreatureSavesTableAnnotationComposer,
          $$CreatureSavesTableCreateCompanionBuilder,
          $$CreatureSavesTableUpdateCompanionBuilder,
          (CreatureSaveRow, $$CreatureSavesTableReferences),
          CreatureSaveRow,
          PrefetchHooks Function({bool creatureId})
        > {
  $$CreatureSavesTableTableManager(_$AppDatabase db, $CreatureSavesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureSavesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureSavesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureSavesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> creatureId = const Value.absent(),
                Value<String> ability = const Value.absent(),
                Value<int> bonus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreatureSavesCompanion(
                creatureId: creatureId,
                ability: ability,
                bonus: bonus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int creatureId,
                required String ability,
                required int bonus,
                Value<int> rowid = const Value.absent(),
              }) => CreatureSavesCompanion.insert(
                creatureId: creatureId,
                ability: ability,
                bonus: bonus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureSavesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.creatureId,
                                referencedTable: $$CreatureSavesTableReferences
                                    ._creatureIdTable(db),
                                referencedColumn: $$CreatureSavesTableReferences
                                    ._creatureIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureSavesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureSavesTable,
      CreatureSaveRow,
      $$CreatureSavesTableFilterComposer,
      $$CreatureSavesTableOrderingComposer,
      $$CreatureSavesTableAnnotationComposer,
      $$CreatureSavesTableCreateCompanionBuilder,
      $$CreatureSavesTableUpdateCompanionBuilder,
      (CreatureSaveRow, $$CreatureSavesTableReferences),
      CreatureSaveRow,
      PrefetchHooks Function({bool creatureId})
    >;
typedef $$CreatureSkillsTableCreateCompanionBuilder =
    CreatureSkillsCompanion Function({
      required int creatureId,
      required String skill,
      required int bonus,
      Value<int> rowid,
    });
typedef $$CreatureSkillsTableUpdateCompanionBuilder =
    CreatureSkillsCompanion Function({
      Value<int> creatureId,
      Value<String> skill,
      Value<int> bonus,
      Value<int> rowid,
    });

final class $$CreatureSkillsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CreatureSkillsTable, CreatureSkillRow> {
  $$CreatureSkillsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) =>
      db.creatures.createAlias('creature_skills__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureSkillsTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureSkillsTable> {
  $$CreatureSkillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get skill => $composableBuilder(
    column: $table.skill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSkillsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureSkillsTable> {
  $$CreatureSkillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get skill => $composableBuilder(
    column: $table.skill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSkillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureSkillsTable> {
  $$CreatureSkillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get skill =>
      $composableBuilder(column: $table.skill, builder: (column) => column);

  GeneratedColumn<int> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSkillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureSkillsTable,
          CreatureSkillRow,
          $$CreatureSkillsTableFilterComposer,
          $$CreatureSkillsTableOrderingComposer,
          $$CreatureSkillsTableAnnotationComposer,
          $$CreatureSkillsTableCreateCompanionBuilder,
          $$CreatureSkillsTableUpdateCompanionBuilder,
          (CreatureSkillRow, $$CreatureSkillsTableReferences),
          CreatureSkillRow,
          PrefetchHooks Function({bool creatureId})
        > {
  $$CreatureSkillsTableTableManager(
    _$AppDatabase db,
    $CreatureSkillsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureSkillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureSkillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureSkillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> creatureId = const Value.absent(),
                Value<String> skill = const Value.absent(),
                Value<int> bonus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreatureSkillsCompanion(
                creatureId: creatureId,
                skill: skill,
                bonus: bonus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int creatureId,
                required String skill,
                required int bonus,
                Value<int> rowid = const Value.absent(),
              }) => CreatureSkillsCompanion.insert(
                creatureId: creatureId,
                skill: skill,
                bonus: bonus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureSkillsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.creatureId,
                                referencedTable: $$CreatureSkillsTableReferences
                                    ._creatureIdTable(db),
                                referencedColumn:
                                    $$CreatureSkillsTableReferences
                                        ._creatureIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureSkillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureSkillsTable,
      CreatureSkillRow,
      $$CreatureSkillsTableFilterComposer,
      $$CreatureSkillsTableOrderingComposer,
      $$CreatureSkillsTableAnnotationComposer,
      $$CreatureSkillsTableCreateCompanionBuilder,
      $$CreatureSkillsTableUpdateCompanionBuilder,
      (CreatureSkillRow, $$CreatureSkillsTableReferences),
      CreatureSkillRow,
      PrefetchHooks Function({bool creatureId})
    >;
typedef $$CreatureSensesTableCreateCompanionBuilder =
    CreatureSensesCompanion Function({
      required int creatureId,
      required String sense,
      Value<int> rowid,
    });
typedef $$CreatureSensesTableUpdateCompanionBuilder =
    CreatureSensesCompanion Function({
      Value<int> creatureId,
      Value<String> sense,
      Value<int> rowid,
    });

final class $$CreatureSensesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CreatureSensesTable, CreatureSenseRow> {
  $$CreatureSensesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) =>
      db.creatures.createAlias('creature_senses__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureSensesTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureSensesTable> {
  $$CreatureSensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sense => $composableBuilder(
    column: $table.sense,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSensesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureSensesTable> {
  $$CreatureSensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sense => $composableBuilder(
    column: $table.sense,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureSensesTable> {
  $$CreatureSensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sense =>
      $composableBuilder(column: $table.sense, builder: (column) => column);

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureSensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureSensesTable,
          CreatureSenseRow,
          $$CreatureSensesTableFilterComposer,
          $$CreatureSensesTableOrderingComposer,
          $$CreatureSensesTableAnnotationComposer,
          $$CreatureSensesTableCreateCompanionBuilder,
          $$CreatureSensesTableUpdateCompanionBuilder,
          (CreatureSenseRow, $$CreatureSensesTableReferences),
          CreatureSenseRow,
          PrefetchHooks Function({bool creatureId})
        > {
  $$CreatureSensesTableTableManager(
    _$AppDatabase db,
    $CreatureSensesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureSensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureSensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureSensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> creatureId = const Value.absent(),
                Value<String> sense = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreatureSensesCompanion(
                creatureId: creatureId,
                sense: sense,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int creatureId,
                required String sense,
                Value<int> rowid = const Value.absent(),
              }) => CreatureSensesCompanion.insert(
                creatureId: creatureId,
                sense: sense,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureSensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.creatureId,
                                referencedTable: $$CreatureSensesTableReferences
                                    ._creatureIdTable(db),
                                referencedColumn:
                                    $$CreatureSensesTableReferences
                                        ._creatureIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureSensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureSensesTable,
      CreatureSenseRow,
      $$CreatureSensesTableFilterComposer,
      $$CreatureSensesTableOrderingComposer,
      $$CreatureSensesTableAnnotationComposer,
      $$CreatureSensesTableCreateCompanionBuilder,
      $$CreatureSensesTableUpdateCompanionBuilder,
      (CreatureSenseRow, $$CreatureSensesTableReferences),
      CreatureSenseRow,
      PrefetchHooks Function({bool creatureId})
    >;
typedef $$CreatureLanguagesTableCreateCompanionBuilder =
    CreatureLanguagesCompanion Function({
      required int creatureId,
      required String language,
      Value<int> rowid,
    });
typedef $$CreatureLanguagesTableUpdateCompanionBuilder =
    CreatureLanguagesCompanion Function({
      Value<int> creatureId,
      Value<String> language,
      Value<int> rowid,
    });

final class $$CreatureLanguagesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CreatureLanguagesTable,
          CreatureLanguageRow
        > {
  $$CreatureLanguagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) => db.creatures
      .createAlias('creature_languages__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureLanguagesTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureLanguagesTable> {
  $$CreatureLanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureLanguagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureLanguagesTable> {
  $$CreatureLanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureLanguagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureLanguagesTable> {
  $$CreatureLanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureLanguagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureLanguagesTable,
          CreatureLanguageRow,
          $$CreatureLanguagesTableFilterComposer,
          $$CreatureLanguagesTableOrderingComposer,
          $$CreatureLanguagesTableAnnotationComposer,
          $$CreatureLanguagesTableCreateCompanionBuilder,
          $$CreatureLanguagesTableUpdateCompanionBuilder,
          (CreatureLanguageRow, $$CreatureLanguagesTableReferences),
          CreatureLanguageRow,
          PrefetchHooks Function({bool creatureId})
        > {
  $$CreatureLanguagesTableTableManager(
    _$AppDatabase db,
    $CreatureLanguagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureLanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureLanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureLanguagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> creatureId = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreatureLanguagesCompanion(
                creatureId: creatureId,
                language: language,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int creatureId,
                required String language,
                Value<int> rowid = const Value.absent(),
              }) => CreatureLanguagesCompanion.insert(
                creatureId: creatureId,
                language: language,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureLanguagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.creatureId,
                                referencedTable:
                                    $$CreatureLanguagesTableReferences
                                        ._creatureIdTable(db),
                                referencedColumn:
                                    $$CreatureLanguagesTableReferences
                                        ._creatureIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureLanguagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureLanguagesTable,
      CreatureLanguageRow,
      $$CreatureLanguagesTableFilterComposer,
      $$CreatureLanguagesTableOrderingComposer,
      $$CreatureLanguagesTableAnnotationComposer,
      $$CreatureLanguagesTableCreateCompanionBuilder,
      $$CreatureLanguagesTableUpdateCompanionBuilder,
      (CreatureLanguageRow, $$CreatureLanguagesTableReferences),
      CreatureLanguageRow,
      PrefetchHooks Function({bool creatureId})
    >;
typedef $$CreatureEnvironmentsTableCreateCompanionBuilder =
    CreatureEnvironmentsCompanion Function({
      required int creatureId,
      required String environment,
      Value<int> rowid,
    });
typedef $$CreatureEnvironmentsTableUpdateCompanionBuilder =
    CreatureEnvironmentsCompanion Function({
      Value<int> creatureId,
      Value<String> environment,
      Value<int> rowid,
    });

final class $$CreatureEnvironmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CreatureEnvironmentsTable,
          CreatureEnvironmentRow
        > {
  $$CreatureEnvironmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreaturesTable _creatureIdTable(_$AppDatabase db) => db.creatures
      .createAlias('creature_environments__creature_id__creatures__id');

  $$CreaturesTableProcessedTableManager get creatureId {
    final $_column = $_itemColumn<int>('creature_id')!;

    final manager = $$CreaturesTableTableManager(
      $_db,
      $_db.creatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CreatureEnvironmentsTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureEnvironmentsTable> {
  $$CreatureEnvironmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => ColumnFilters(column),
  );

  $$CreaturesTableFilterComposer get creatureId {
    final $$CreaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableFilterComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureEnvironmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureEnvironmentsTable> {
  $$CreatureEnvironmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreaturesTableOrderingComposer get creatureId {
    final $$CreaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableOrderingComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureEnvironmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureEnvironmentsTable> {
  $$CreatureEnvironmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => column,
  );

  $$CreaturesTableAnnotationComposer get creatureId {
    final $$CreaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatureId,
      referencedTable: $db.creatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.creatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreatureEnvironmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureEnvironmentsTable,
          CreatureEnvironmentRow,
          $$CreatureEnvironmentsTableFilterComposer,
          $$CreatureEnvironmentsTableOrderingComposer,
          $$CreatureEnvironmentsTableAnnotationComposer,
          $$CreatureEnvironmentsTableCreateCompanionBuilder,
          $$CreatureEnvironmentsTableUpdateCompanionBuilder,
          (CreatureEnvironmentRow, $$CreatureEnvironmentsTableReferences),
          CreatureEnvironmentRow,
          PrefetchHooks Function({bool creatureId})
        > {
  $$CreatureEnvironmentsTableTableManager(
    _$AppDatabase db,
    $CreatureEnvironmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureEnvironmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureEnvironmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CreatureEnvironmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> creatureId = const Value.absent(),
                Value<String> environment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreatureEnvironmentsCompanion(
                creatureId: creatureId,
                environment: environment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int creatureId,
                required String environment,
                Value<int> rowid = const Value.absent(),
              }) => CreatureEnvironmentsCompanion.insert(
                creatureId: creatureId,
                environment: environment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreatureEnvironmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.creatureId,
                                referencedTable:
                                    $$CreatureEnvironmentsTableReferences
                                        ._creatureIdTable(db),
                                referencedColumn:
                                    $$CreatureEnvironmentsTableReferences
                                        ._creatureIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CreatureEnvironmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureEnvironmentsTable,
      CreatureEnvironmentRow,
      $$CreatureEnvironmentsTableFilterComposer,
      $$CreatureEnvironmentsTableOrderingComposer,
      $$CreatureEnvironmentsTableAnnotationComposer,
      $$CreatureEnvironmentsTableCreateCompanionBuilder,
      $$CreatureEnvironmentsTableUpdateCompanionBuilder,
      (CreatureEnvironmentRow, $$CreatureEnvironmentsTableReferences),
      CreatureEnvironmentRow,
      PrefetchHooks Function({bool creatureId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$LegendaryGroupsTableTableManager get legendaryGroups =>
      $$LegendaryGroupsTableTableManager(_db, _db.legendaryGroups);
  $$CreaturesTableTableManager get creatures =>
      $$CreaturesTableTableManager(_db, _db.creatures);
  $$CreatureActionsTableTableManager get creatureActions =>
      $$CreatureActionsTableTableManager(_db, _db.creatureActions);
  $$CreatureTraitsTableTableManager get creatureTraits =>
      $$CreatureTraitsTableTableManager(_db, _db.creatureTraits);
  $$CreatureSpellcastingsTableTableManager get creatureSpellcastings =>
      $$CreatureSpellcastingsTableTableManager(_db, _db.creatureSpellcastings);
  $$CreatureSpellsTableTableManager get creatureSpells =>
      $$CreatureSpellsTableTableManager(_db, _db.creatureSpells);
  $$CreatureSavesTableTableManager get creatureSaves =>
      $$CreatureSavesTableTableManager(_db, _db.creatureSaves);
  $$CreatureSkillsTableTableManager get creatureSkills =>
      $$CreatureSkillsTableTableManager(_db, _db.creatureSkills);
  $$CreatureSensesTableTableManager get creatureSenses =>
      $$CreatureSensesTableTableManager(_db, _db.creatureSenses);
  $$CreatureLanguagesTableTableManager get creatureLanguages =>
      $$CreatureLanguagesTableTableManager(_db, _db.creatureLanguages);
  $$CreatureEnvironmentsTableTableManager get creatureEnvironments =>
      $$CreatureEnvironmentsTableTableManager(_db, _db.creatureEnvironments);
}
