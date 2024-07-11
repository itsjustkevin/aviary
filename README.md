# Aviary CLI

Aviary is a command-line interface (CLI) tool designed to streamline release management for Dart and Flutter projects. Named after an aviary, a place where birds are kept, Aviary is a fitting name for a tool designed to manage the "release" of software, much like birds are released from an aviary. The mascot for Dart and Flutter, Dash, is a vibrant and energetic female bird, symbolizing the freedom and agility that Aviary brings to your development workflow.

## Introduction

In the world of Dart and Flutter, managing releases can be a complex and time-consuming process. This is where Aviary comes into play. Just as an aviary provides a structured environment for birds before they take flight, Aviary offers a structured, efficient, and automated way to handle release management tasks. The name Aviary is a tribute to Dash, the beloved bird mascot of Dart and Flutter, representing the tool's purpose: to help your projects soar to new heights with smooth and controlled releases.

## Features

- **Automated Issue Creation**: Aviary automates the creation of GitHub issues, including umbrella issues and sub-issues for specific language features.
- **Customizable Configurations**: Define issues and assignees through a YAML configuration file, allowing for easy customization.
- **Flexible Labeling**: Optionally add custom labels to issues or disable labeling entirely.

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
