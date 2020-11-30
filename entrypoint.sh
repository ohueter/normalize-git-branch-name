#!/bin/bash

set -eo pipefail

function normalize_branch_name {
    # normalize the branch name
    # * sed 's:^[/_\.\-]*::' -> remove all non-alphanumeric characters at beginning of string
    # * sed 's:/:-:g' -> replace slash by dash
    # * sed 's:-$::' -> remove trailing dash
    # * tr -cd '[a-zA-Z0-9-]')" -> delete all not allowed characters
    # * cut -c -64 -> truncate to 64 characters
    local branch_name=`echo "$1" | sed -e 's:^[/_\.\-]*::' -e 's:[/_\.]:-:g' | tr -cd '[a-zA-Z0-9-]' | sed 's:-$::' | cut -c -64`
    echo "$branch_name"
}

REF=${1#refs/heads/}
HEAD_REF=$2

# If the $HEAD_REF is non-empty (i.e. pull requests), use it. Otherwise, use $ref (pushes).
if [ -n "$HEAD_REF" ]; then
    GH_BRANCH=$HEAD_REF
else
    GH_BRANCH=$REF
fi

branch_name="$(normalize_branch_name $GH_BRANCH)"

if [ -z "$branch_name" ]; then
    exit 1
fi

branch_sha1=`echo "$branch_name" | sha1sum | cut -c -8`

echo "::set-output original-name=name::$GH_BRANCH"
echo "::set-output name=name::$branch_name"
echo "::set-output name=hash::$branch_sha1"

echo "Original branch name: $GH_BRANCH"
echo "Normalized branch name: $branch_name"
echo "Branch SHA1 Checksum: $branch_sha1"
