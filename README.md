# gh-backup

Zero-config [script](gh-backup.sh) to backup GitHub repos and gists.

Requires [GitHub CLI](https://cli.github.com).

## Usage

```bash
curl https://raw.githubusercontent.com/hoffa/gh-backup/main/gh-backup.sh | sh 
```

Which will create an archive in the form `github-backup-<username>-<timestamp>.tar.gz`.
