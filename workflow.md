# Debian package with gbp

# Initial

## Debian server

- ssh git.debian.org
- cd /srv/git.debian.org/git/pkg-fonts/
- ./setup-repository fonts-sil-YOURFONT 'Packaging for fonts-sil-YOURFONT'

Debian packaging for fonts-sil-YOURFONT


## Local

- `git add debian/gbp.conf`
- `git commit -m "create gbp.conf"`
- or
- `git commit -m "update gbp.conf"`
- git branch upstream
- gbp import-orig ../../upstream/Font-version.tar.xz
- git add debian
- git commit -m "Add packaging files"

### old

- gbp import-dsc --create-missing-branches package-name-version.dsc

### From Debian

# Ongoing

## Release

- `gpg --armor --detach-sign Font-version.tar.xz`
- `gbp import-orig --uscan`
- `gbp import-orig ../../upstream/Font-version.tar.xz`
- if needed, restore saved debian/ directory
  git add debian
- `git commit -m "Re-add the pre-existing debian directory"`

## Packaging

- `cd debian`
- dch -i
- gedit *
- cd ..
- git commit -a
- gbp buildpackage
- `git commit -a -m "Update packaging for new upstream release"`
- `git commit -a -m "Update and improve packaging"`
- git tag -a debian/version
- git push --all
- git push --tags
