# Installer Freetype 2.13.2 sous macOS depuis les sources

Freetype contient des bibliothèques permettant d'afficher des polices de
caractère.

## Dépendances

### Recommandées

* [**libpng**](libpng-1.6.42.md)

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.13.2 de Freetype.

```
curl -LO https://sourceforge.net/projects/freetype/files/freetype2/2.13.2/freetype-2.13.2.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf freetype-2.13.2.tar.xz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Freetype :

```
mkdir freetype-build
```

Puis rendez-vous dans ce répertoire :

```
cd freetype-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de Freetype :

```
LIBPNG_CFLAGS="-I$HOME/.softwares/install/libpng/include" \
    LIBPNG_LIBS="-L$HOME/.softwares/install/libpng/lib -lpng" \
    ../freetype-2.13.2/configure --prefix=$HOME/.softwares/build/freetype-2.13.2
```

### Compilation

Nous allons désormais compiler Freetype avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer Freetype dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/freetype-2.13.2 $HOME/.softwares/install/freetype
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Freetype' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/freetype/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export ACLOCAL_PATH="$HOME/.softwares/install/freetype/share/aclocal:$ACLOCAL_PATH"' >> $HOME/.zshrc
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
rm -rf freetype-build
```

Puis finalement le dossier contenant les sources de cmake :

```
rm -rf freetype-2.13.2
```