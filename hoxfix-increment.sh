#!/bin/bash

# Exit script if any command fails
set -e

# Function to update the POM version and verify the update
update_pom_version() {
    # Use Maven to get the current project version, suppressing transfer progress
    CURRENT_VERSION=$(mvn --no-transfer-progress help:evaluate -Dexpression=project.version -q -DforceStdout)

    # Check if version already has -HF suffix
    if [[ $CURRENT_VERSION =~ -HF([0-9]+)$ ]]; then
        # Extract the current counter
        COUNTER=$(echo $CURRENT_VERSION | sed -r 's/.*-HF([0-9]+)$/\1/')
        # Increment the counter
        let COUNTER=COUNTER+1
    else
        # Start with HF1 suffix
        COUNTER=1
    fi
    # Form the new version
    NEW_VERSION="${CURRENT_VERSION%-HF*}-HF${COUNTER}"

    # Use Maven to set the new version, suppressing transfer progress
    mvn --no-transfer-progress build-helper:parse-version versions:set -DnewVersion="$NEW_VERSION" versions:commit

    # Verify the new version
    UPDATED_VERSION=$(mvn --no-transfer-progress help:evaluate -Dexpression=project.version -q -DforceStdout)
    if [ "$UPDATED_VERSION" != "$NEW_VERSION" ]; then
        echo "Error: Version update verification failed. Expected $NEW_VERSION, but found $UPDATED_VERSION."
        exit 1
    fi
}

# Function to commit and tag the new version
commit_and_tag() {
    # Commit new version
    echo "committing new version"
    git add pom.xml
    git commit -m "$NEW_VERSION"

    # Identify source repository (handles local or CI)
    if [ -z "$CI_REPOSITORY_URL" ]; then
        REPOSITORY_URL=""
    else
        URL_ARRAY=(${CI_REPOSITORY_URL//@/ })
        REPOSITORY_URL="$CI_SERVER_PROTOCOL://${GITLAB_USERNAME}:${GITLAB_ACCESS_TOKEN}@${URL_ARRAY[1]}"
    fi
    echo "REPOSITORY_URL = $REPOSITORY_URL"

    # Tag new version
    echo "tagging version $NEW_VERSION"
    git tag -a "$NEW_VERSION" -m "$NEW_VERSION"
    git push --follow-tags "$REPOSITORY_URL" "$CURRENT_BRANCH"
}

# Main script execution
if [[ $CURRENT_BRANCH =~ .*-hotfix$ ]]; then
    echo "Hotfix branch detected, updating version."
    update_pom_version
    commit_and_tag
    echo "...done"
else
    echo "Not a hotfix branch, no action taken."
fi
