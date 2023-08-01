#!/bin/sh
set -eux

username=$(gh api user | jq -r .login)

dirname=gh-backup-${username}-$(date -u +"%Y%m%dT%H%M%SZ")

mkdir "${dirname}"
cd "${dirname}"

mkdir repos
mkdir gists

gh gist list | while read -r gist; do
    id=$(echo "${gist}" | cut -f 1)
    filename=$(echo "${gist}" | cut -f 2)
    gh gist clone "${id}" "gists/${id}"
done
