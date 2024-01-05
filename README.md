# hotfix-strategy

Certainly! Below is a README that outlines the purpose and functionality of the script:

---

# Hotfix Version Management Script

## Overview

This script is designed to automate the process of versioning in a Maven project when commits are made to branches designated for hotfixes. The script checks for the naming convention of the branch and, if it matches the `-hotfix` suffix, it performs a series of operations to update the project's `pom.xml` with an incremented hotfix version number.

## Prerequisites

- Git must be installed on the system where the script is executed.
- Maven (3.6.1 or newer) must be installed to use the `--no-transfer-progress` option.
- The script must be run within a Git repository with the `pom.xml` file at its root.

## Environment Variables

The script relies on the following environment variables:

- `GITLAB_USERNAME`: The username for GitLab access.
- `GITLAB_ACCESS_TOKEN`: A GitLab access token with permissions to commit and tag the repository.
- `CI_SERVER_PROTOCOL`: The protocol used by the GitLab server (e.g., `https`).
- `CI_REPOSITORY_URL`: The repository URL provided by the CI environment.

These variables should be set in the CI/CD environment or exported in the shell before running the script manually.

## Script Functionality

1. **Check Current Branch**: The script first determines the current branch. If it ends with `-hotfix`, it proceeds; otherwise, it exits without taking action.

2. **Update POM Version**:
    - Retrieves the current version from `pom.xml`.
    - Checks if this version already has a `-HF` suffix with a number.
    - If it does, it increments this number by 1. If not, it appends `-HF1` to the version.

3. **Commit New Version**:
    - Adds the modified `pom.xml` to the Git staging area.
    - Commits the change with a message that includes the new version number.

4. **Identify Source Repository**:
    - Checks if `CI_REPOSITORY_URL` is set. If not, it assumes a local environment.
    - Parses the repository URL to include the GitLab username and access token for authentication.

5. **Tag New Version**:
    - Tags the new commit with the new version number.
    - Pushes the new tag to the source repository.

6. **Completion**: The script outputs a completion message if the operations are successful.

## Usage

To use the script, you can either include it directly in your `.gitlab-ci.yml` pipeline or run it manually in a shell environment. For manual execution, ensure all required environment variables are set in your session.

## Testing

Test this script in a controlled environment before deploying it in a production setting. It's advisable to have a separate branch and test project to validate the script's behavior.
