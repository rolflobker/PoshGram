# PoshGram Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [10/13/2019]

No Version Change

- Updated gitignore references
- Updated README to reflect 6.1+ PowerShell version
- Updated vscode settings for Stroustrup code formatting
- Added Git community files
  - Code of conduct
  - Pull request template
  - bug report template
  - Changelog
  - Contributing guidelines
- Updated modules references in install_modules to latest versions


## [1.0.2]

- Addressed bug where certain UTF-8 characters would fail to send properly in Send-TelegramTextMessage
- Cosmetic code change for Invoke functions to use splat parameters

## [1.0.0]

- Addressed bug in Send-TelegramTextMessage that was not handling underscores
- Added code to support AWS Codebuild

## [0.9.0]

- Restructured module for CI/CD Workflow
- Added Invoke-Build capabilities to module
- Added Animation functionality:
  - Send-TelegramLocalAnimation
  - Send-TelegramURLAnimation
- Added location functionality:
  - Send-TelegramLocation
- Added multi-media functionality:
  - Send-TelegramMediaGroup
- Consolidated private support functions
- Code Logic improvements

## [0.8.4]

- Added IconURI to manifest

## [0.8.3]

- 0.8.3 Initial beta release.