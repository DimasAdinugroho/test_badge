#!/bin/bash

#get highest tag number
# git fetch --tags --force
# VERSION=`git describe --abbrev=0 --tags 2>/dev/null`
VERSION=${steps.tagger.outputs.tag}

echo $VERSION

if [ -z $VERSION ];then
    NEW_TAG="v1.0b0"
    echo "No tag present."
    echo "Creating tag: $NEW_TAG"
    git tag $NEW_TAG
    git push --tags
    echo "Tag created and pushed: $NEW_TAG"
    exit 0;
fi

#replace . with space so can split into an array
VERSION_BITS=(${VERSION//./ })

#get number parts and increase last one by 1
MAJOR=${VERSION_BITS[0]:1} # remove the v
MINOR=${VERSION_BITS[1]}
BUILDVER=${MINOR//b/ }


REGEXMINOR='([0-9]+)b'
[[ "$MINOR" =~ $REGEXMINOR ]]
if [[ $1 == "master" ]]; then
    MAJOR=$((MAJOR+1))
else
    MINOR=$((BASH_REMATCH[1]+1))
fi

#create new tag
NEW_TAG="v${MAJOR}.${MINOR}b${BUILDVER[1]}"

#get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
CURRENT_COMMIT_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`
echo "tag with: $NEW_TAG"

#only tag if no tag already (would be better if the git describe command above could have a silent option)
if [ -z "$CURRENT_COMMIT_TAG" ]; then
    echo "Updating $VERSION to $NEW_TAG"
    git tag $NEW_TAG
    git push --tags
    echo "Tag created and pushed: $NEW_TAG"
else
    echo "This commit is already tagged as: $CURRENT_COMMIT_TAG"
fi
