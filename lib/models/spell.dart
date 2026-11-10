import 'dart:convert';

import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/read.dart' show parseEntries;

/// Display-ready spell data decoded from a spell catalog row.
class Spell {
  const Spell({
    required this.name,
    required this.source,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    required this.duration,
    required this.description,
    required this.higherLevel,
  });

  final String name;
  final String source;
  final String level;
  final String school;
  final String castingTime;
  final String range;
  final String components;
  final String duration;
  final String description;
  final String? higherLevel;

  factory Spell.fromRow(SpellRow row) {
    final decoded = jsonDecode(row.data);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Spell data must be a JSON object.');
    }

    final entries = _flattenEntries(decoded['entries']);
    final higherLevel = _flattenEntries(
      decoded['entriesHigherLevel'],
    ).replaceFirst(RegExp(r'^At Higher Levels:\s*'), '');
    final levelName = _spellLevelName(row.level);

    return Spell(
      name: row.name,
      source: row.source,
      level: levelName,
      school: spellSchoolName(row.school),
      castingTime: _formatCastingTime(decoded['time']),
      range: _formatRange(decoded['range']),
      components: _formatComponents(decoded['components']),
      duration: _formatDuration(decoded['duration']),
      description: entries,
      higherLevel: higherLevel.isEmpty ? null : higherLevel,
    );
  }
}

String _spellLevelName(int level) {
  if (level == 0) return 'Cantrip';
  final suffix = switch (level % 100) {
    11 || 12 || 13 => 'th',
    _ => switch (level % 10) {
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      _ => 'th',
    },
  };
  return '$level$suffix level';
}

String spellSchoolName(String code) => switch (code) {
  'A' => 'Abjuration',
  'C' => 'Conjuration',
  'D' => 'Divination',
  'E' => 'Enchantment',
  'V' => 'Evocation',
  'I' => 'Illusion',
  'N' => 'Necromancy',
  'T' => 'Transmutation',
  _ => code,
};

String _formatCastingTime(Object? raw) {
  if (raw is! List) return '';
  return raw
      .whereType<Map>()
      .map((time) {
        final number = time['number'];
        final unit = time['unit']?.toString() ?? '';
        final condition = time['condition']?.toString();
        final value = '${number ?? ''} $unit'.trim();
        return condition == null || condition.isEmpty
            ? value
            : '$value ($condition)';
      })
      .where((value) => value.isNotEmpty)
      .join(' or ');
}

String _formatRange(Object? raw) {
  if (raw is! Map) return '';
  final type = raw['type']?.toString() ?? '';
  final distance = raw['distance'];
  if (distance is! Map) return type;
  final distanceType = distance['type']?.toString() ?? '';
  final amount = distance['amount'];
  final amount2 = distance['amount2'];
  final distanceText = switch (distanceType) {
    'feet' || 'miles' => [
      if (amount != null) amount.toString(),
      if (amount2 != null) '-$amount2',
      distanceType,
    ].join(' '),
    _ => distanceType,
  };
  if (type.isEmpty || type == 'point') return distanceText;
  return '$distanceText $type'.trim();
}

String _formatComponents(Object? raw) {
  if (raw is! Map) return '';
  final parts = <String>[if (raw['v'] == true) 'V', if (raw['s'] == true) 'S'];
  final material = raw['m'];
  if (material == true) {
    parts.add('M');
  } else if (material != null && material != false) {
    parts.add('M ($material)');
  }
  if (raw['r'] == true) parts.add('R');
  return parts.join(', ');
}

String _formatDuration(Object? raw) {
  if (raw is! List) return '';
  return raw
      .whereType<Map>()
      .map((duration) {
        final type = duration['type']?.toString() ?? '';
        if (type == 'timed') {
          final details = duration['duration'];
          if (details is! Map) return 'Timed';
          final amount = details['amount'];
          final unit = details['type']?.toString() ?? '';
          final concentration = duration['concentration'] == true
              ? 'Concentration, up to '
              : '';
          return '$concentration${amount ?? ''} $unit'.trim();
        }
        if (type == 'permanent' && duration['ends'] is List) {
          return 'Until ${(duration['ends'] as List).join(' or ')}';
        }
        return switch (type) {
          'instant' => 'Instantaneous',
          'special' => 'Special',
          _ => type,
        };
      })
      .where((value) => value.isNotEmpty)
      .join(' or ');
}

String _flattenEntries(Object? raw) {
  final parts = <String>[];

  void visit(Object? value) {
    if (value is String) {
      final parsed = parseEntries([value]).trim();
      if (parsed.isNotEmpty) parts.add(parsed);
      return;
    }
    if (value is List) {
      for (final item in value) {
        visit(item);
      }
      return;
    }
    if (value is Map) {
      final name = value['name'];
      if (name is String && name.isNotEmpty) parts.add('$name:');
      for (final key in ['entry', 'entries', 'items']) {
        visit(value[key]);
      }
    }
  }

  visit(raw);
  return parts.join('\n\n');
}
