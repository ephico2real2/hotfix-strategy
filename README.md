# hotfix-strategy

Here is the full script updated with the version verification step:

# Hotfix Version Management Script

## Overview

This script automates version updates for Maven projects when commits are made to branches designated for hotfixes. Specifically, it targets branches ending in `-hotfix`. The script checks the branch name, updates the `pom.xml` with a new version number that appends a hotfix identifier, commits this change, and tags it in the repository.

## Prerequisites

- **Git**: Version control system must be installed.
- **Maven**: 3.6.1 or newer for the `--no-transfer-progress` option.

## Environment Variables

The script requires the following environment variables:

- `GITLAB_USERNAME`: Your username on GitLab.
- `GITLAB_ACCESS_TOKEN`: An access token for authentication with GitLab.
- `CI_SERVER_PROTOCOL`: The protocol used to access the GitLab server (typically `https`).
- `CI_REPOSITORY_URL`: The repository URL, usually provided in a CI environment.

## Script Functionality

1. **Check Current Branch**: Ensures the script operates on branches ending with `-hotfix`.
2. **Update POM Version**:
   - Fetches the current version from `pom.xml`.
   - Checks for a `-HF` suffix and increments the number if present; otherwise, adds `-HF1`.
   - Updates `pom.xml` with the new version and verifies the change.
3. **Commit and Tag**:
   - Commits the updated `pom.xml`.
   - Constructs a URL with authentication for repository operations.
   - Tags the new version in the repository.
   - Pushes the tag to the remote repository.
4. **Completion**: Outputs a success message upon completion.

## Usage

Run the script at the root of your Maven project, where the `pom.xml` is located. It can be integrated into your `.gitlab-ci.yml` for GitLab CI/CD pipelines or executed manually.

## Testing

Thoroughly test the script in a non-production environment before incorporating it into your CI/CD workflow. Ensure that it functions correctly and safely updates the project version.

## Important Note

This script modifies the project's `pom.xml` file. Always backup your project and use version control best practices when running scripts that alter your codebase.
