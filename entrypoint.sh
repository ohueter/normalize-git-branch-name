#!/bin/bash

set -eo pipefail

function normalize_branch_name {
    # normalize the branch name
    # * sed 's:^[/_\.\-]*::' -> remove all non-alphanumeric characters at beginning of string
    # * sed 's:/:-:g' -> replace slash by dash
    # * sed 's:-$::' -> remove trailing dash
    # * tr -cd '[a-zA-Z0-9-]')" -> delete all not allowed characters
    # * cut -c -64 -> truncate to 64 characters
    local branch_name=`echo "${1#refs/heads/}" | sed -e 's:^[/_\.\-]*::' -e 's:[/_\.]:-:g' | tr -cd '[a-zA-Z0-9-]' | sed 's:-$::' | cut -c -64`
    echo "$branch_name"
}

branch_name="$(normalize_branch_name $1)"

if [ -z "$branch_name" ]; then
    exit 1
fi

branch_sha1=`echo "$branch_name" | sha1sum | cut -c -8`

echo "::set-output name=name::$branch_name"
echo "::set-output name=hash::$branch_sha1"

echo "Normalized branch name: $branch_name"
echo "Branch SHA1 Checksum: $branch_sha1"
