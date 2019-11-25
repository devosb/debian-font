# Debian package with gbp

# Initial

## Salsa

Project description: Debian packaging for fonts-sil-YOURFONT

## Local

- `git add debian/gbp.conf`
- `git commit -m "create gbp.conf"`
- or
- `git commit -m "update gbp.conf"`
- git branch upstream
- gbp import-orig ../../upstream/Font-version.tar.xz
- git add debian
- git commit -m "Add packaging files"

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
- code *
- wrap-and-sort -asb # maybe
- cd ..
- git commit -a
- gbp buildpackage
- `git commit -a -m "Update packaging for new upstream release"`
- `git commit -a -m "Update and improve packaging"`
- git tag -a debian/version # i.e., debian/1.000-1
- git push --all
- git push --tags
