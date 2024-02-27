# Installer Xpdf 4.05 sous macOS depuis les sources

Xpdf est à la fois une visionneuse de fichiers pdf, mais également un ensemble
d'outils pratique sur les fichiers pdf.

## Dépendances

### Facultatives :

* [**FreeType**](freetype-2.13.2.md) : Freetype est requis pour les exécutables
`pdftoppm`, `pdftopng`, `pdftohtml` et `xpdf`

* [**libpng**](libpng-1.6.42.md) : la bibliothèque libpng est requise pour les
exécutables `pdftopng` et `pdftohtml`.

* [**Qt5**](qt-5.15.12) : Qt5 est requis pour l'exécutable `xpdf`.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 4.05 de Xpdf.

```
curl -LO https://dl.xpdfreader.com/xpdf-4.05.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf xpdf-4.05.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Xpdf :

```
mkdir xpdf-build
```

Puis rendez-vous dans ce répertoire :

```
cd xpdf-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de Xpdf :

```
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.softwares/build/xpdf-4.05 \
    -DCMAKE_C_FLAGS="-I$HOME/.softwares/install/freetype/include/freetype2" \
    -DCMAKE_CXX_FLAGS="-I$HOME/.softwares/install/freetype/include/freetype2" \
    -DCMAKE_PREFIX_PATH=$HOME/.softwares/install/qt \
    -DPNG_PNG_INCLUDE_DIR="$HOME/.softwares/install/libpng/include" \
    -DPNG_LIBRARY_RELEASE="$HOME/.softwares/install/libpng/lib/libpng16.16.dylib" \
    -DFREETYPE_INCLUDE_DIR_ft2build="$HOME/.softwares/install/freetype/include" \
    -DFREETYPE_INCLUDE_DIR_freetype="$HOME/.softwares/install/freetype/include" \
    -DFREETYPE_LIBRARY="$HOME/.softwares/install/freetype/lib/libfreetype.6.dylib" \
    ../xpdf-4.05
```

### Compilation

Nous allons désormais compiler Xpdf avec la commande suivante :

```
cmake --build .
```

### Installation

Vous pouvez désormais installer Xpdf dans son répertoire de destination :

```
cmake --build . --target install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/xpdf-4.05 $HOME/.softwares/install/xpdf
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## XPdf' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/xpdf/bin:$PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/xpdf/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf xpdf-build
```

Puis finalement le dossier contenant les sources de xpdf :

```
rm -rf xpdf-4.05
```