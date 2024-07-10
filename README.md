## Prerequisites

- Dart SDK: Ensure you have Dart installed on your system. You can download it from the [official Dart website](https://dart.dev/get-dart).
- GitHub Account: You need a GitHub account to generate a personal access token.

## Generating a GitHub Token

To interact with GitHub API, you need to generate a personal access token with the necessary permissions:

1. Go to [GitHub Settings](https://github.com/settings/tokens).
2. Click on "Generate new token".
3. Give your token a descriptive name.
4. Select the scopes you need. For this application, you need the `repo` scope.
5. Click on "Generate token".
6. Copy the generated token. **This will be the only time you can see it, so make sure to copy it to a safe place.**

## Adding the Token to Your Environment

Set the `GITHUB_TOKEN` environment variable with your GitHub token. This variable will be used by Aviary CLI to authenticate with GitHub.

### On Unix-like Systems (Linux, macOS)

```sh
export GITHUB_TOKEN=your_github_token_here
```

### On Windows

```sh
set GITHUB_TOKEN=your_github_token_here
```

## Running the Feature Subcommand
The feature subcommand is used to create an umbrella issue and related sub-issues for a specified language feature. By default, it targets the dart-lang/sdk repository.

### Basic Usage
To create issues for a new feature named "augmentations":

```sh
dart run bin/aviary.dart create feature --feature=augmentations
```

### Specifying a Different Repository
If you want to create issues in a different repository, you can specify the --owner and --repo flags:

```sh
dart run bin/aviary.dart create feature --feature=augmentations --owner=itsjustkevin --repo=public-project
```

### Specifying a Custom Configuration File
If you want to use a custom YAML configuration file for issue templates:

```sh
dart run bin/aviary.dart create feature --feature=augmentations --config=path/to/your/config.yaml
```

### Adding labels

By default, features will be tagged with a `feature-$featureName` label.  If you desire a custom label, you can pass the label flag as `--label=$myCustomLabel` or if you desire no label at all, you can pass the `--no-label` flag. 

## Defaults
If no --owner or --repo flags are passed, the tool defaults to the dart-lang organization and the sdk repository:

- Default Owner: dart-lang
- Default Repository: sdk
