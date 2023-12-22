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

## Packaging

- [repo] `cd sid/fonts-sil-font`
- [repo] `git pull --all`
- [repo] `gbp import-orig --uscan`
- [repo] `gbp import-orig ../../upstream/Font-version.tar.xz`
- [repo] `cd debian`
- [repo] `dch -i`
- [repo] `code .`
- [repo] `grep -A 1 openTypeNameDescription source/*.ufo/*.plist`
- [repo] `wrap-and-sort -asb` # maybe
- [build] `cd build`
- [build] `./build ../sid/fonts-sil-reponame`
- [result] `cd result`
- [result] `pbuilder-sid build *.dsc`
- [repo] `cd ..`
- [repo] `git commit -a -m "Update packaging for new upstream release"`
- [repo] `git commit -a -m "Update and improve packaging"`
- [repo] `gbp tag` # debian/1.000-1
- [repo] `gbp push` # git push --all; git push --tags
- [result] `pbuilder-sid sign`
- [result] `pbuilder-sid upload`
- [result] `pbuilder-pso build *.dsc`
- [result] `pbuilder-pso sign`
- [result] `pbuilder-pso upload`

## Reverse dependencies
- `build-rdeps`
- `apt rdepends`
