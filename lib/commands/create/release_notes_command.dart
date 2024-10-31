import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;

class ReleaseNotesCommand {
  final name = 'release-notes';
  final ArgParser argParser = ArgParser()
    ..addOption('owner',
        abbr: 'o', help: 'GitHub repository owner', defaultsTo: 'flutter')
    ..addOption('repo',
        abbr: 'r', help: 'GitHub repository name', defaultsTo: 'flutter')
    ..addOption('tag',
        abbr: 't', help: 'Tag name for the release', mandatory: true)
    ..addOption('previous-tag',
        abbr: 'p', help: 'Previous tag name for the release', mandatory: true)
    ..addOption('config-path',
        abbr: 'c',
        help: 'Path to the configuration file',
        defaultsTo: '.github/release.yml')
    ..addOption('output',
        abbr: 'f', help: 'Output file path', defaultsTo: 'release-notes.md');

  String getGitHubToken() {
    final token = Platform.environment['GITHUB_TOKEN'];
    if (token == null || token.isEmpty) {
      throw Exception('GITHUB_TOKEN environment variable is not set or empty.');
    }
    return token;
  }

  void runCommand(ArgResults commandResults) async {
    final owner = commandResults['owner'] as String;
    final repo = commandResults['repo'] as String;
    final tag = commandResults['tag'] as String;
    final previousTag = commandResults['previous-tag'] as String;
    final configPath = commandResults['config-path'] as String;
    final outputPath = commandResults['output'] as String;

    try {
      final releaseNotes =
          await generateReleaseNotes(owner, repo, tag, previousTag, configPath);
      await writeReleaseNotesToFile(outputPath, releaseNotes);
      print('Release notes saved to $outputPath');
    } catch (error) {
      print('Error: ${error.toString()}');
    }
  }

  Future<String> generateReleaseNotes(
      String owner, String repo, String tag, String previousTag,
      [String? configPath]) async {
    final token = getGitHubToken();
    final url = Uri.https(
        'api.github.com', '/repos/$owner/$repo/releases/generate-notes');

    final requestBody = {
      'tag_name': tag,
      'previous_tag_name': previousTag,
      if (configPath != null) 'configuration_file_path': configPath,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final notes = jsonDecode(response.body)['body'] as String;
      final formattedNotes = notes
          .split('\n')
          .where((line) => !line.contains(
              '<!-- Release notes generated using configuration in .github/release.yml'))
          .map((line) => transformLink(line))
          .join('\n')
          .trim();

      return formattedNotes;
    } else {
      throw Exception(
          'GitHub API error: ${response.statusCode} - ${response.body}');
    }
  }

  String transformLink(String line) {
    return line.replaceAllMapped(
      RegExp(r'(by @(\w+) in )(https://github.com/[^/]+/[^/]+/pull/(\d+))'),
      (match) => '${match.group(1)}[${match.group(4)}](${match.group(3)})',
    );
  }

  Future<void> writeReleaseNotesToFile(
      String outputPath, String releaseNotes) async {
    final file = File(outputPath);
    await file.create(recursive: true);
    await file.writeAsString(releaseNotes);
  }
}
