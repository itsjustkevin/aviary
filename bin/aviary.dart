import 'package:args/args.dart';
import 'package:aviary/commands/create/create_command.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );

  // Add new commands here.
  final createCommand = CreateCommand();
  parser.addCommand(createCommand.name, createCommand.argParser);

  return parser;
}

void printUsage(ArgParser argParser) {
  print('Usage: dart aviary.dart <flags> <command> [arguments]');
  print('');
  print('Global options:');
  print(argParser.usage);
  print('');
  print('Available commands:');
  argParser.commands.forEach((command, parser) {
    print('  $command');
    print(parser.usage);
  });
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    if (results['help'] as bool) {
      printUsage(argParser);
      return;
    }
    if (results['version'] as bool) {
      print('aviary version: $version');
      return;
    }
    if (results['verbose'] as bool) {
      verbose = true;
    }

    if (results.command != null) {
      final commandName = results.command!.name;

      // When adding a new command, add a new block like this
      if (commandName == 'create') {
        final createCommand = CreateCommand();
        createCommand.runCommand(results.command!);
      } else {
        print('Unknown command: $commandName');
        printUsage(argParser);
      }
    } else {
      print('No command provided.');
      printUsage(argParser);
    }

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
