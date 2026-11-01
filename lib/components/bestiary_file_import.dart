import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:gmdex/database/bestiary_importer.dart';
import 'package:gmdex/database/database.dart';

class BestiaryFileImport {
  const BestiaryFileImport({required this.fileName, required this.result});

  final String fileName;
  final ImportResult result;
}

Future<BestiaryFileImport?> importBestiaryFromFile(
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
      'Bestiary JSON files must be 16 MiB or smaller.',
    );
  }

  final bytesBuilder = BytesBuilder(copy: false);
  var byteLength = 0;
  await for (final chunk in file.readAsByteStream()) {
    byteLength += chunk.length;
    if (byteLength > maxBestiaryImportSizeBytes) {
      throw const FormatException(
        'Bestiary JSON files must be 16 MiB or smaller.',
      );
    }
    bytesBuilder.add(chunk);
  }

  final result = await importBestiaryJson(
    database,
    utf8.decode(bytesBuilder.takeBytes()),
  );
  return BestiaryFileImport(fileName: file.name, result: result);
}
