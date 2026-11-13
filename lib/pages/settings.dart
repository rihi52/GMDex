import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/components/bestiary_file_import.dart';
import 'package:gmdex/components/legendary_group_file_import.dart';
import 'package:gmdex/components/spell_file_import.dart';
import 'package:gmdex/database/bestiary_exporter.dart';
import 'package:gmdex/database/database_backup.dart';
import 'package:gmdex/database/database_initialize.dart';
import 'package:gmdex/models/difficulty_calculator_ruleset.dart';
import 'package:gmdex/models/turn_highlight_preference.dart';
import 'package:gmdex/theme/apptheme.dart';

export 'package:gmdex/models/difficulty_calculator_ruleset.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isImporting = false;
  bool _isExporting = false;
  bool _isDeleting = false;

  Future<void> _showAboutDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('GMDex', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(width: 24),
            Image(
              image: AssetImage('assets/images/GMDex.png'),
              width: 48,
              height: 48,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SelectableText(
            'v1.0.0\n'
            'GMDex is a free and open source tool for managing Dungeons & Dragons 5e '
            '2014 encounters. It is not affiliated with Wizards of the Coast or '
            'any other company. All trademarks are property of their respective owners.'
            '\n\nThis work includes material taken from the System Reference Document 5.1 (“SRD 5.1”) by Wizards of the Coast LLC and available at https://dnd.wizards.com/resources/systems-reference-document. The SRD 5.1 is licensed under the Creative Commons Attribution 4.0 International License available at https://creativecommons.org/licenses/by/4.0/legalcode.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Future<void> _importBestiary() async {
    setState(() => _isImporting = true);
    try {
      final importedFile = await importBestiaryFromFile(database);
      if (importedFile == null || !mounted) return;

      final result = importedFile.result;
      if (result.failed.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${importedFile.fileName}: imported ${result.imported}, '
              'skipped ${result.skipped}.',
            ),
          ),
        );
        return;
      }

      final failures = result.failed.take(10).join('\n');
      final remaining = result.failed.length - 10;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Imported ${importedFile.fileName} with errors'),
          content: SingleChildScrollView(
            child: Text(
              'Imported ${result.imported}; skipped ${result.skipped}; '
              'failed ${result.failed.length}.\n\n'
              '$failures'
              '${remaining > 0 ? '\n...and $remaining more.' : ''}',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not import bestiary: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _importLegendaryGroups() async {
    setState(() => _isImporting = true);
    try {
      final importedFile = await importLegendaryGroupsFromFile(database);
      if (importedFile == null || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${importedFile.fileName}: imported '
            '${importedFile.result.imported} legendary groups, '
            'skipped ${importedFile.result.skipped}.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not import legendary groups: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _importSpells() async {
    setState(() => _isImporting = true);
    try {
      final importedFile = await importSpellsFromFile(database);
      if (importedFile == null || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${importedFile.fileName}: imported ${importedFile.imported} spells.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not import spells: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _exportCreatures() async {
    setState(() => _isExporting = true);
    try {
      final json = await exportBestiaryJson(database);
      if (!mounted) return;

      final fileUri = await FilePicker.saveFile(
        fileName: 'bestiary-export.json',
        bytes: Uint8List.fromList(utf8.encode(json)),
        mimeType: 'application/json',
        dialogTitle: 'Export bestiary database',
      );
      if (fileUri == null || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bestiary database exported.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not export bestiary database: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportEntireDatabase() async {
    setState(() => _isExporting = true);
    try {
      final exportedAt = DateTime.now().toUtc();
      final json = await exportDatabaseBackupJson(
        database,
        exportedAt: exportedAt,
      );
      if (!mounted) return;

      final date =
          '${exportedAt.year.toString().padLeft(4, '0')}'
          '${exportedAt.month.toString().padLeft(2, '0')}'
          '${exportedAt.day.toString().padLeft(2, '0')}';
      final fileUri = await FilePicker.saveFile(
        fileName: 'gmdex-database-backup-$date.json',
        bytes: Uint8List.fromList(utf8.encode(json)),
        mimeType: 'application/json',
        dialogTitle: 'Export entire database',
      );
      if (fileUri == null || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entire database exported.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not export entire database: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _importEntireDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Replace entire database?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Importing a backup permanently replaces all current players, '
          'creatures, encounters, notes, and related data. Export a backup '
          'first if you may need to restore the current data.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    setState(() => _isImporting = true);
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['json'],
      );
      if (file == null) return;

      final knownLength = file.lengthSync();
      if (knownLength != null && knownLength > maxDatabaseBackupSizeBytes) {
        throw const FormatException(
          'Database backups must be 256 MiB or smaller.',
        );
      }

      final bytesBuilder = BytesBuilder(copy: false);
      var byteLength = 0;
      await for (final chunk in file.readAsByteStream()) {
        byteLength += chunk.length;
        if (byteLength > maxDatabaseBackupSizeBytes) {
          throw const FormatException(
            'Database backups must be 256 MiB or smaller.',
          );
        }
        bytesBuilder.add(chunk);
      }

      final result = await importDatabaseBackupJson(
        database,
        utf8.decode(bytesBuilder.takeBytes()),
        confirmOlderBackup: (current, pending) async {
          if (!mounted) return false;
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Import an older database backup?'),
              content: Text(
                'The selected backup is older than the current database. '
                'Importing it will replace the current data.\n\n'
                'Current database: ${current.toLocal()}\n'
                'Pending backup: ${pending.toLocal()}',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Import anyway'),
                ),
              ],
            ),
          );
          return confirmed == true;
        },
      );
      if (!mounted || result.cancelled) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${file.name}: imported ${result.playerCount} players and '
            '${result.encounterCount} encounters.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not import entire database: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _clearDatabaseData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Clear database data?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This permanently deletes all stored players, creatures, encounters, '
          'and notes. The database tables and structure will remain. '
          'This cannot be undone.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear data'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    setState(() => _isDeleting = true);
    try {
      await database.clearData();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Database data cleared.')));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not clear database data: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: ResponsiveLayout.isNarrow(
          MediaQuery.sizeOf(context).width,
          breakpoint: ResponsiveBreakpoints.navigation,
        ),
        child: ListView(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Database',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isImporting || _isExporting || _isDeleting
                                  ? null
                                  : _importBestiary,
                              icon: _isImporting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_upload_outlined),
                              label: Text(
                                _isImporting
                                    ? 'Importing...'
                                    : 'Import Bestiary',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Import a json file containing bestiary data. Structure must match the expected format (the structure a website with tools for 5e might have).',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingMedium),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isImporting || _isExporting || _isDeleting
                                  ? null
                                  : _importLegendaryGroups,
                              icon: _isImporting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_upload_outlined),
                              label: Text(
                                _isImporting
                                    ? 'Importing...'
                                    : 'Import Legendary Groups',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Import legendarygroups.json separately. Import order does not matter; links use name and source, with a unique-name fallback for blank references.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isImporting || _isExporting || _isDeleting
                                  ? null
                                  : _importSpells,
                              icon: _isImporting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_upload_outlined),
                              label: Text(
                                _isImporting ? 'Importing...' : 'Import Spells',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Import a spells.json file containing a "spell" array, such as spells-phb.json or spells-tce.json. Imported non-SRD spells replace same-name SRD entries.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isImporting || _isExporting || _isDeleting
                                  ? null
                                  : _exportCreatures,
                              icon: _isExporting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_download_outlined),
                              label: Text(
                                _isExporting
                                    ? 'Exporting...'
                                    : 'Export Bestiary Database',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Exports a json file of the bestiary database.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isImporting || _isExporting || _isDeleting
                                  ? null
                                  : _clearDatabaseData,
                              icon: _isDeleting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.delete_outlined),
                              label: Text(
                                _isDeleting
                                    ? 'Clearing...'
                                    : 'Clear Database Data',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Permanently removes all saved data while keeping the database structure.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isImporting || _isExporting || _isDeleting
                                  ? null
                                  : _exportEntireDatabase,
                              icon: _isExporting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_download_outlined),
                              label: Text(
                                _isExporting
                                    ? 'Exporting...'
                                    : 'Export Entire Database',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Exports all players, creatures, encounters, notes, and related data to a portable GMDex JSON backup.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isImporting || _isExporting || _isDeleting
                                  ? null
                                  : _importEntireDatabase,
                              icon: _isImporting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.file_upload_outlined),
                              label: Text(
                                _isImporting
                                    ? 'Importing...'
                                    : 'Import Entire Database',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Replaces the current database with data from a GMDex JSON backup.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Combat Options',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingLarge),
                        Text(
                          'Turn Highlighter',
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.spacingMedium),
                        ValueListenableBuilder<bool>(
                          valueListenable: turnHighlightEnabled,
                          builder: (context, isHighlight, _) {
                            return Switch(
                              value: isHighlight,
                              onChanged: (value) async {
                                try {
                                  await saveTurnHighlightPreference(value);
                                } catch (error) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Could not save turn highlight setting: $error',
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.spacingLarge),
                        Text(
                          'Difficulty Calculator',
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<DifficultyCalculatorRuleset>(
                          valueListenable: selectedDifficultyCalculator,
                          builder: (context, selected, _) {
                            return SegmentedButton<DifficultyCalculatorRuleset>(
                              showSelectedIcon: false,
                              segments: [
                                ButtonSegment(
                                  value: DifficultyCalculatorRuleset.dnd2014,
                                  label: SizedBox(
                                    width: 300,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 28,
                                          ),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '2014 5e\n',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                                ),
                                                const TextSpan(
                                                  text:
                                                      'The traditional encounter building strategy as '
                                                      'recommended by D&D 5e 2014. ',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (selected ==
                                            DifficultyCalculatorRuleset.dnd2014)
                                          const Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(Icons.check),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                ButtonSegment(
                                  value:
                                      DifficultyCalculatorRuleset.fleeMortals,
                                  label: SizedBox(
                                    width: 300,
                                    // height: 200,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 28,
                                          ),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Flee, Mortals!\n',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                                ),
                                                TextSpan(
                                                  text:
                                                      'MCDM\'s Flee Mortals has a set of rules for creating encounters '
                                                      'developed by them for their custom monsters. It is based on '
                                                      'character levels contributing to a CR budget. See their book '
                                                      'for more information. ',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (selected ==
                                            DifficultyCalculatorRuleset
                                                .fleeMortals)
                                          const Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(Icons.check),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              selected: {selected},
                              onSelectionChanged: (selection) async {
                                try {
                                  await saveDifficultyCalculatorRuleset(
                                    selection.first,
                                  );
                                } catch (error) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Could not save difficulty calculator setting: '
                                        '$error',
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.spacingExtraLarge),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showAboutDialog,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('About GMDex'),
                                SizedBox(width: 16),
                                Image(
                                  image: AssetImage(
                                    'assets/images/GMDexlogoblack.png',
                                  ),
                                  width: 32,
                                  height: 32,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
