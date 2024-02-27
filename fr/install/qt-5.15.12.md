# Installer Qt 5.15.12 sous macOS depuis les sources

# Dépendances

## Recommandées

* [**pkg-config**](pkg-config-0.29.2.md)
* [**libpng**](libpng-1.6.42.md)
* [**Freetype**](freetype-2.13.2.md)
* [**PCRE2**](pcre2-10.43.md)
* [**libjpeg-turbo**](libjpeg-turbo-3.0.2.md)
* [**Python 3.11**](python-3.11.8.md)
* [**Node**](node-20.11.1.md)
* [**GLib**](glib-2.79.2.md)
* [**Ninja**](ninja-1.11.1.md)

## Installation
### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 5.15.12 de Qt.

```
curl -LO https://download.qt.io/official_releases/qt/5.15/5.15.12/single/qt-everywhere-opensource-src-5.15.12.tar.xz
```

Extrayez ensuite l'archive contenant les sources :

```
tar -xf qt-everywhere-opensource-src-5.15.12.tar.xz
```

Rendez-vous dans le répertoire contenant les sources :

```
cd qt-everywhere-src-5.15.12
```

Nous allons maintenant passer à une version plus récente de qtwebengine.
Commencez par supprimer le répertoire existant :

```
rm -rf qtwebengine
```

Puis récupérez qtwebengine depuis le dépôt git :

```
git clone https://code.qt.io/qt/qtwebengine.git
```

Rendez-vous dans le dossier du dépôt :

```
cd qtwebengine
```

Récupérez la version 5.15.16 :

```
git checkout v5.15.16-lts
```

Initialisez les sous-module :

```
git submodule init
```

Puis récupérez-les :

```
git submodule update
```

Nous allons faire de même maintenant avec catapult. Rendez-vous dans le
répertoire des programmes tiers :

```
cd src/3rdparty/chromium/third_party
```

Et supprimez catapult :

```
rm -rf catapult
```

Récupérez catapult depuis le dépôt git :

```
git clone https://chromium.googlesource.com/catapult.git
```

Puis rendez-vous dans le répertoire du dépôt git

```
cd catapult
```

Et récupérez la version correspondant à la révision avec l'identifiant
`5eedfe23148a234211ba477f76fc2ea2e8529189` :

```
git checkout 5eedfe23148a234211ba477f76fc2ea2e8529189
```

Rendez-vous maintenant à nouveau dans le répertoires des sources principal :

```
cd $HOME/.softwares/sources
```

### Patch des sources

Il y a de nombreux correctifs à appliquer à Qt, et nous allons les appliquer
tous un par un.

```
curl -L 'https://github.com/qt/qtwebengine-chromium/commit/c98d28f2f0f23721b080c74bc1329871a529efd8.patch?full_index=1' -o qtwebengine-chromium-fix-libxml2-2.12.0.patch
patch --directory=qt-everywhere-src-5.15.12/qtwebengine/src/3rdparty --strip=1 < qtwebengine-chromium-fix-libxml2-2.12.0.patch

curl -L 'https://raw.githubusercontent.com/Homebrew/formula-patches/7ae178a617d1e0eceb742557e63721af949bd28a/qt5/qt5-webengine-chromium-python3.patch?full_index=1' -o qt5-webengine-chromium-python3.patch
patch --directory=qt-everywhere-src-5.15.12/qtwebengine/src/3rdparty --strip=1 < qt5-webengine-chromium-python3.patch

curl -L 'https://raw.githubusercontent.com/Homebrew/formula-patches/a6f16c6daea3b5a1f7bc9f175d1645922c131563/qt5/qt5-webengine-python3.patch?full_index=1' -o qt5-webengine-python3.patch
patch --directory=qt-everywhere-src-5.15.12/qtwebengine --strip=1 < qt5-webengine-python3.patch

curl -L https://sources.debian.org/data/main/q/qtwebengine-opensource-src/5.15.15%2Bdfsg-2/debian/patches/python3.11.patch -o qt5-python3.11.patch
patch --directory=qt-everywhere-src-5.15.12/qtwebengine --strip=1 < qt5-python3.11.patch

curl -L 'https://github.com/FFmpeg/FFmpeg/commit/effadce6c756247ea8bae32dc13bb3e6f464f0eb.patch?full_index=1' -o qt5-ffmpeg.patch
patch --directory=qt-everywhere-src-5.15.12/qtwebengine/src/3rdparty/chromium/third_party/ffmpeg --strip=1 < qt5-ffmpeg.patch

curl -L 'https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-qt/qtwebengine/files/qtwebengine-6.5.3-icu74.patch?id=ba397fa71f9bc9a074d9c65b63759e0145bb9fa0' -o qtwebengine-6.5.3-icu74.patch
patch --directory=qt-everywhere-src-5.15.12/qtwebengine --strip=1 < qtwebengine-6.5.3-icu74.patch

curl -L 'https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/5a07e1967dcc925d9def47accadae991436b9686.diff' -o fix-mapbox-gl-native-xcode-14.3.patch
patch --directory=qt-everywhere-src-5.15.12/qtlocation/src/3rdparty/mapbox-gl-native --strip=1 < fix-mapbox-gl-native-xcode-14.3.patch

curl -LO https://raw.githubusercontent.com/Homebrew/formula-patches/086e8cf/qt5/qt5-qmake-xcode15.patch
patch --directory=qt-everywhere-src-5.15.12 --strip=1 < qt5-qmake-xcode15.patch

curl -LO https://raw.githubusercontent.com/Homebrew/formula-patches/3f509180/qt5/qt5-qtmultimedia-xcode15.patch
patch --directory=qt-everywhere-src-5.15.12 --strip=1 < qt5-qtmultimedia-xcode15.patch

curl -LO https://gist.githubusercontent.com/gahfy/3b95ced26f823a9d0c4774ef1c84c452/raw/a445add41cab064f3909c03aa11843d49309ea04/qt5-qtbase-memory_resource.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-qtbase-memory_resource.patch

curl -L https://download.qt.io/official_releases/qt/5.15/CVE-2023-24607-qtbase-5.15.diff -o qt5-CVE-2023-24607-qtbase-5.15.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-24607-qtbase-5.15.patch

curl -L https://invent.kde.org/qt/qt/qtsvg/-/commit/5b1b4a99d6bc98c42a11b7a3f6c9f0b0f9e56f34.diff -o qt5-fix-qtsvg.patch
patch --directory=qt-everywhere-src-5.15.12/qtsvg --strip=1 < qt5-fix-qtsvg.patch

curl -L https://invent.kde.org/qt/qt/qtbase/-/commit/1286cab2c0e8ae93749a71dcfd61936533a2ec50.diff -o qt5-CVE-2023-32762-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-32762-qtbase.patch

curl -L https://invent.kde.org/qt/qt/qtbase/-/commit/deb7b7b52b6e6912ff8c78bc0217cda9e36c4bba.diff -o qt5-CVE-2023-32763-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-32763-qtbase.patch

curl -L https://invent.kde.org/qt/qt/qtbase/-/commit/21f6b720c26705ec53d61621913a0385f1aa805a.diff -o qt5-CVE-2023-33285-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-33285-qtbase.patch

curl -L https://invent.kde.org/qt/qt/qtbase/-/commit/2ad1884fee697e0cb2377f3844fc298207e810cc.diff -o qt5-CVE-2023-34410-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-34410-qtbase.patch

curl -L https://download.qt.io/official_releases/qt/5.15/CVE-2023-37369-qtbase-5.15.diff -o qt5-CVE-2023-37369-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-37369-qtbase.patch

curl -L https://download.qt.io/official_releases/qt/5.15/CVE-2023-38197-qtbase-5.15.diff -o qt5-CVE-2023-38197-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-38197-qtbase.patch

curl -L https://download.qt.io/official_releases/qt/5.15/0001-CVE-2023-51714-qtbase-5.15.diff -o qt5-CVE-2023-51714-1-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-51714-1-qtbase.patch

curl -L https://download.qt.io/official_releases/qt/5.15/0002-CVE-2023-51714-qtbase-5.15.diff -o qt5-CVE-2023-51714-2-qtbase.patch
patch --directory=qt-everywhere-src-5.15.12/qtbase --strip=1 < qt5-CVE-2023-51714-2-qtbase.patch

sed -i.bck 's|rebase_path("$clang_base_path/bin/", root_build_dir)|""|' qt-everywhere-src-5.15.12/qtwebengine/src/3rdparty/chromium/build/toolchain/mac/BUILD.gn
sed -i.bck 's|"Assistant.app/Contents/MacOS/Assistant"|"Assistant"|' qt-everywhere-src-5.15.12/qttools/src/designer/src/designer/assistantclient.cpp
sed -i.bck 's|"Assistant.app/Contents/MacOS/Assistant"|"Assistant"|' qt-everywhere-src-5.15.12/qttools/src/linguist/linguist/mainwindow.cpp
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Qt :

```
mkdir qt-build
```

Puis rendez-vous dans ce répertoire :

```
cd qt-build
```
### Configuration de la compilation

Nous allons maintenant configurer la compilation de Qt. Mais avant cela, nous
allons créer un lien temporaire `python` qui pointe vers `python3` :

```
ln -s python3 $HOME/.softwares/install/Python3/bin/python
```

Nous pouvons maintenant configurer la compilation de Qt :

```
../qt-everywhere-src-5.15.12/configure \
    -verbose \
    -prefix $HOME/.softwares/build/qt-5.15.12 \
    -verbose \
    -release \
    -opensource \
    -confirm-license \
    -nomake examples \
    -nomake tests \
    -pkg-config \
    -dbus-runtime \
    -proprietary-codecs \
    -system-freetype \
    -system-libjpeg \
    -system-libpng \
    -system-pcre \
    -system-zlib \
    -no-rpath \
    -no-assimp
```

### Compilation

Nous allons désormais compiler Qt avec la commande suivante :

```
make
```

### Suppression du lien temporaire

Nous pouvons désormais supprimer le lien temporaire vers le binaire `python3` :
```
rm -rf $HOME/.softwares/install/Python3/bin/python
```

### Installation

Vous pouvez désormais installer Qt dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/qt-5.15.12 $HOME/.softwares/install/qt
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Qt' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/qt/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/qt/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
```

Finalement, il ne nous reste plus qu'à prendre en compte ces variables
d'environnement dans le terminal en cours d'exécution :

```
source $HOME/.zshrc
```

### Nettoyage

Nous allons désormais supprimer les deux dossier que nous venons de créer dans
le répertoire des sources. Tout d'abord, rendez-vous dans le répertoire des
sources :

```
cd ..
```

Puis supprimez le dossier contenant les fichiers de compilation :

```
rm -rf qt-build
```

Puis finalement le dossier contenant les sources de qt :

```
rm -rf qt-everywhere-src-5.15.12
```