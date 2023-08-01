#!/bin/sh
set -eux

gh auth status || gh auth login

username=$(gh api user --jq .login)
dirname=github-backup-${username}-$(date -u +"%Y%m%dT%H%M%SZ")

mkdir "${dirname}"
cd "${dirname}"

# Clone gists
mkdir gists
cd gists
gh gist list | while read -r gist; do
	id=$(echo "${gist}" | cut -f 1)
	gh gist clone "${id}"
done
cd ..

# Clone repos
mkdir repos
cd repos
gh repo list | while read -r repo; do
	name=$(echo "${repo}" | cut -f 1)
	gh repo clone "${name}"
done
cd ..

# Create archive
cd ..
tar czvf "${dirname}.tar.gz" "${dirname}"
rm -rf "${dirname}"
