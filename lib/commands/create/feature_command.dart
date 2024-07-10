import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';
import 'package:github/github.dart';
import 'package:yaml/yaml.dart';

const documentationUrl =
    'https://docs.github.com/rest/issues/issues#create-an-issue';

GitHub createGitHubClient() {
  final token = Platform.environment['GITHUB_TOKEN'];
  if (token == null || token.isEmpty) {
    throw Exception('GITHUB_TOKEN environment variable is not set or empty.');
  }
  return GitHub(auth: Authentication.withToken(token));
}

List<String> generateIssueList(
    String languageFeatureName, String configFilePath) {
  final configFile = File(configFilePath);
  final configContent = configFile.readAsStringSync();
  final yamlMap = loadYaml(configContent);

  final issues = List<String>.from(yamlMap['issues']);
  return issues.map((issue) => '[$languageFeatureName] $issue').toList();
}

Future<void> createLanguageIssues(String owner, String repo, String featureName,
    String configFilePath, String? label, bool noLabel) async {
  final github = createGitHubClient();

  try {
    final String languageFeatureName = featureName;
    final String umbrellaIssueTitle = 'Implement $featureName feature';
    final List<String> issueList =
        generateIssueList(languageFeatureName, configFilePath);
    final String umbrellaIssueBody =
        'This is an umbrella issue covering $languageFeatureName.';
    final List<String> labels =
        noLabel ? [] : [label ?? 'feature-$languageFeatureName'];

    // Creates the umbrella issue to be used in the future.
    // This issue will be updated with links to the individual issues.
    final umbrellaIssue = await github.issues.create(
      RepositorySlug(owner, repo),
      IssueRequest(
        title: umbrellaIssueTitle,
        body: umbrellaIssueBody,
        labels: labels,
      ),
    );
    print('Created umbrella issue: ${umbrellaIssue.htmlUrl}');

    final List<String> createdIssueLinks = [];

    // Create the individual issues with a 5-second delay between each to avoid
    // hitting the GitHub API rate limit.
    for (final issueTitle in issueList) {
      final issue = await github.issues.create(
        RepositorySlug(owner, repo),
        IssueRequest(
          title: issueTitle,
          body: '',
          labels: labels,
        ),
      );
      createdIssueLinks.add(issue.htmlUrl);
      print('Created issue: ${issue.htmlUrl}');
      await Future.delayed(Duration(seconds: 5));
    }

    final String fullUmbrellaIssueBody =
        '$umbrellaIssueBody\n\nGenerated issue links:\n${createdIssueLinks.map((link) => '- $link').join('\n')}';

    // Update the umbrella issue created earlier with links to the created
    // issues
    await github.issues.edit(
      RepositorySlug(owner, repo),
      umbrellaIssue.number,
      IssueRequest(
        body: fullUmbrellaIssueBody,
      ),
    );
    print('Updated umbrella issue with linked issues.');
  } catch (error) {
    if (error is GitHubError) {
      print('GitHub API Error: ${error.message}');
      print('GitHub API Documentation URL: $documentationUrl');
    } else {
      print('Error: ${error.toString()}');
    }
  }
}

class FeatureCommand {
  final name = 'feature';
  final ArgParser argParser = ArgParser()
    ..addOption('owner',
        abbr: 'o', help: 'GitHub repository owner', defaultsTo: 'dart-lang')
    ..addOption('repo',
        abbr: 'r', help: 'GitHub repository name', defaultsTo: 'sdk')
    ..addOption('feature',
        abbr: 'f',
        help: 'Name of the feature to create issues for',
        mandatory: true)
    ..addOption('label', abbr: 'l', help: 'Label to apply to the issues')
    ..addOption('config',
        abbr: 'c',
        help: 'Path to the configuration YAML file',
        defaultsTo: 'config/issues.yaml')
    ..addFlag('no-label',
        help: 'Do not apply a label to the issues', negatable: false);

  void runCommand(ArgResults commandResults) {
    final owner = commandResults['owner'] as String;
    final repo = commandResults['repo'] as String;
    final featureName = commandResults['feature'] as String;
    final configFilePath = commandResults['config'] as String;
    final label = commandResults['label'] as String?;
    final noLabel = commandResults['no-label'] as bool;

    createLanguageIssues(
        owner, repo, featureName, configFilePath, label, noLabel);
  }
}
