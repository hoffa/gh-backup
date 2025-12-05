#!/bin/sh
set -eux

LIMIT=1000

if ! command -v gh >/dev/null; then
	echo "gh not found"
	echo "On macOS, you can install it with Homebrew:"
	echo "  brew install gh"
	exit 1
fi

gh auth status || gh auth login

username=$(gh api user --jq .login)
dirname=github-backup-${username}-$(date -u +"%Y%m%dT%H%M%SZ")
mkdir "${dirname}"
cd "${dirname}"

# Clone gists
mkdir gists
cd gists
gh gist list --limit "${LIMIT}" | while read -r gist; do
	id=$(echo "${gist}" | cut -f 1)
	gh gist clone "${id}"
done
cd ..

# Clone user repos
mkdir repos
cd repos
mkdir -p "${username}"
(
	cd "${username}"
	gh repo list "${username}" --limit "${LIMIT}" | while read -r repo; do
		name=$(echo "${repo}" | cut -f 1)
		gh repo clone "${name}"
	done
)

# Clone repos for orgs the user belongs to
gh api user/orgs --jq '.[].login' | while read -r org; do
	mkdir -p "${org}"
	(
		cd "${org}"
		gh repo list "${org}" --limit "${LIMIT}" | while read -r repo; do
			name=$(echo "${repo}" | cut -f 1)
			gh repo clone "${name}"
		done
	)
done

cd ..

# Create archive
cd ..
tar czvf "${dirname}.tar.gz" "${dirname}"
rm -rf "${dirname}"
