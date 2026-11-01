import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:gmdex/database/bestiary_importer.dart';
import 'package:gmdex/database/database.dart';

class LegendaryGroupFileImport {
  const LegendaryGroupFileImport({
    required this.fileName,
    required this.result,
  });

  final String fileName;
  final LegendaryGroupImportResult result;
}

Future<LegendaryGroupFileImport?> importLegendaryGroupsFromFile(
  AppDatabase database,
) async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: const ['json'],
  );
  if (file == null) return null;

  final knownLength = file.lengthSync();
  if (knownLength != null && knownLength > maxBestiaryImportSizeBytes) {
    throw const FormatException(
      'Legendary groups JSON files must be 16 MiB or smaller.',
    );
  }

  final bytesBuilder = BytesBuilder(copy: false);
  var byteLength = 0;
  await for (final chunk in file.readAsByteStream()) {
    byteLength += chunk.length;
    if (byteLength > maxBestiaryImportSizeBytes) {
      throw const FormatException(
        'Legendary groups JSON files must be 16 MiB or smaller.',
      );
    }
    bytesBuilder.add(chunk);
  }

  final result = await importLegendaryGroupsJson(
    database,
    utf8.decode(bytesBuilder.takeBytes()),
  );
  return LegendaryGroupFileImport(fileName: file.name, result: result);
}
