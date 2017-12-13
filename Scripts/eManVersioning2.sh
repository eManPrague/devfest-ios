#!/bin/sh

#  eManVersioning.sh
#  Pre-build version script. Sets version by eMan standards depending on preprocessor definitions.
#  Uses PlistBuddy expected at path /usr/libexec/.
#  Script only updates plist in app build. Original project plist is not touched.
#
#  Created by Martin Dohnal on 03.11.13.
#  Copyright (c) 2013 eMan s.r.o. All rights reserved.

# build properties
AppStore=0

# parse preprocessor definitions
PrepDefinitions=$(echo $GCC_PREPROCESSOR_DEFINITIONS | tr ";" "\n")
for Definition in $PrepDefinitions
    do
        # split each preprocessor definition name and value
        # echo "> [$Definition]"
        name=$(echo "${Definition}" | cut -d'=' -f1)
        value=$(echo "${Definition}" | cut -d'=' -f2-)
        # echo Name-Value "${name}" "${value}"

        if [ "$name" = "APPSTORE" ]; then
            AppStore=$value;
        fi
done

StoreVersion=1
if [ "$AppStore" -ne 1 ] || [ "$EM_STORE_VERSION" -ne 1 ] || [ -z "$EM_STORE_VERSION" ]; then
    StoreVersion=0
fi

Branch=$(git branch | grep \* | cut -d ' ' -f2 | tr '[:lower:]' '[:upper:]') #$(git rev-parse --abbrev-ref HEAD | tr '[:lower:]' '[:upper:]')
Commit=$(git rev-parse --short HEAD)

if [ $StoreVersion -eq 0 ]; then
    VersionExtension=" ${EM_CONFIGURATION_STRING} ${Commit}"

    if [[ "$Branch" =~ rc$ ]] || [[ "$Branch" =~ uat$ ]] || [[ "$Branch" =~ dev$ ]] || [[ "$Branch" =~ hf$ ]]; then
    Version="${Branch}${VersionExtension}"
    fi
fi

# project plist
buildPlistIn="$INFOPLIST_FILE"

MainVersionFinal=$(appversion ${CI_COMMIT_REF_NAME} "$(git tag -l)" $1)

BuildNumberFromGitCommitCount=$(git rev-list HEAD --count)
echo "MainVersionFinal: $MainVersionFinal"

# build plist
buildPlistOut="$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"
echo "buildPlistOut: $buildPlistOut"

# write version string to output plist
echo "Final version $MainVersionFinal"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '$MainVersionFinal'" "$buildPlistOut"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '$BuildNumberFromGitCommitCount'" "$buildPlistOut"


# Icon badge

BadgeColor="#000000"
if [[ $Branch =~ DEV$ ]]; then
BadgeColor="#de3737"
elif [[ $Branch =~ UAT$ ]]; then
BadgeColor="#feab0c"
elif [[ $Branch =~ RC$ ]]; then
BadgeColor="#3cd956"
elif [[ $Branch =~ HF$ ]]; then
BadgeColor="#378dde"
fi

function generateIcon () {
IconPath="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/$1"

scale=$2
if [ "$scale" == "" ]; then
scale="1.0"
echo "In $scale"
fi
echo "Out $scale"


if [ -f "$IconPath" ]; then
${PROJECT_DIR}/Scripts/iconbadge --input "$IconPath" --text "$Branch" --textcolor "#ffffff" --background "$BadgeColor" --textscale $scale --output "$IconPath" &>/dev/null
fi
}

#if [ $StoreVersion -eq 0 ]; then
#generateIcon "AppIcon60x60@2x.png"
#generateIcon "AppIcon60x60@3x.png" "1.5"
#generateIcon "AppIcon40x40@2x.png" "0.7"
#generateIcon "AppIcon40x40@3x.png" "0.7"
#generateIcon "AppIcon29x29@2x.png" "0.5"
#generateIcon "AppIcon29x29@3x.png" "0.7"
#generateIcon "AppIcon76x76~ipad.png" "0.7"
#generateIcon "AppIcon76x76@2x~ipad.png"
#generateIcon "AppIcon40x40~ipad.png" "0.4"
#generateIcon "AppIcon40x40@2x~ipad.png" "0.7"
#generateIcon "AppIcon29x29~ipad.png" "0.7"
#generateIcon "AppIcon29x29@2x~ipad.png" "0.4"
#fi
