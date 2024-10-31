import 'package:args/args.dart';
import 'feature_command.dart';
import 'release_notes_command.dart';

/// This class represents the [create] command. It is the parent command for all
/// subcommands that create new resources.
/// example usage: `dart run bin/aviary.dart create feature --feature=test`
class CreateCommand {
  final name = 'create';
  final ArgParser argParser = ArgParser();

  CreateCommand() {
    final featureCommand = FeatureCommand();
    final releaseNotesCommand = ReleaseNotesCommand();
    argParser.addCommand(featureCommand.name, featureCommand.argParser);
    argParser.addCommand(
        releaseNotesCommand.name, releaseNotesCommand.argParser);

  }

  void runCommand(ArgResults commandResults) {
    if (commandResults.command != null) {
      final subCommandName = commandResults.command!.name;
      if (subCommandName == 'feature') {
        final featureCommand = FeatureCommand();
        featureCommand.runCommand(commandResults.command!);
      } else if (subCommandName == 'release-notes') {
        final releaseNotesCommand = ReleaseNotesCommand();
        releaseNotesCommand.runCommand(commandResults.command!);
      } else {
        print('Unknown subcommand: $subCommandName');
      }
    }
  }
}
