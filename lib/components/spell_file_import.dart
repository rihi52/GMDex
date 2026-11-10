import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/spell_importer.dart';

class SpellFileImport {
  const SpellFileImport({required this.fileName, required this.imported});

  final String fileName;
  final int imported;
}

Future<SpellFileImport?> importSpellsFromFile(AppDatabase database) async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: const ['json'],
  );
  if (file == null) return null;

  final knownLength = file.lengthSync();
  if (knownLength != null && knownLength > maxSpellImportSizeBytes) {
    throw const FormatException('Spell JSON files must be 16 MiB or smaller.');
  }

  final bytesBuilder = BytesBuilder(copy: false);
  var byteLength = 0;
  await for (final chunk in file.readAsByteStream()) {
    byteLength += chunk.length;
    if (byteLength > maxSpellImportSizeBytes) {
      throw const FormatException(
        'Spell JSON files must be 16 MiB or smaller.',
      );
    }
    bytesBuilder.add(chunk);
  }

  final imported = await importSpellsJson(
    database,
    utf8.decode(bytesBuilder.takeBytes()),
  );
  return SpellFileImport(fileName: file.name, imported: imported);
}
