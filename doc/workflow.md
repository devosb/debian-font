# Debian package with gbp

# Initial

## Salsa

Under the section `Settings/General`
- Project description (optional): Debian packaging for fonts-sil-FontName
Under the section `Settings/CI CD` then `General pipelines`
- Custom CI configuration path: `debian/salsa-ci.yml`

## Local

- `git branch upstream`
- `gbp import-orig ../../upstream/FontName-version.tar.xz` # package name is fonts-sil-reponame, not FontName
- `git add debian`
- `git commit -m "Add packaging files"`

# Ongoing

## GPG key expiration

- `gpg --edit-key keyid`
  - `expire`
  - `key 1`
  - `expire`
- `gpg --export keyid`
- upload to
  - Ubuntu keyserver
  - GitHub
  - PSO
  - Thunderbird

## Release

- `gpg --armor --detach-sign Font-version.tar.xz`
- `gbp import-orig --uscan`
- `gbp import-orig ../../upstream/Font-version.tar.xz`

## Packaging

- `cd debian`
- `dch -i` # gbp dch -a # dch -r
- `code *`
- `grep -A 1 openTypeNameDescription source/*.ufo/*.plist`
- `wrap-and-sort -asb` # maybe
- `cd ..`
- `git commit -a`
- `gbp buildpackage`
- `git commit -a -m "Update packaging for new upstream release"`
- `git commit -a -m "Update and improve packaging"`
- `git tag -a debian/version` # i.e., debian/1.000-1 # gbp tag
- `git push --all` # gbp push
- `git push --tags`

## Reverse dependencies
- `build-rdeps`
- `apt rdepends`
