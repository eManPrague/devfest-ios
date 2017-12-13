#!/bin/sh

#  eManVersioning.sh

BuildNumberFromGitCommitCount=$(git rev-list --all --count)
echo "Final build number: $BuildNumberFromGitCommitCount"

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '$BuildNumberFromGitCommitCount'" "../Project/Devfest/Devfest-Info.plist"

MainVersionFinal=$(appversion ${CI_COMMIT_REF_NAME} "$(git tag -l)")
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '$MainVersionFinal'" "../Project/Devfest/Devfest-Info.plist"
