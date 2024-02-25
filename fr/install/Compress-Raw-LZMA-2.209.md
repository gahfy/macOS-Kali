# Installer Compress::Raw::LZMA 2.209

Compress::Raw::LZMA est une bibliothèque perl fournissant des fonctionnalités de
compression et de décompression avec l'algorithme LZMA.

## Dépendances

### Indispensable

* [**XZ**](xz-5.4.6) : XZ fournit la bibliothèque LZMA nécessaire à la
compilation de la bibliothèque Perl.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.209 de Compress::Raw::LZMA.

```
curl -L https://github.com/pmqs/Compress-Raw-Lzma/archive/refs/tags/v2.209.tar.gz -o Compress-Raw-LZMA-2.209.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf Compress-Raw-LZMA-2.209.tar.gz
```

Puis rendez-vous dans le répertoire que vous venez d'extraire :

```
cd Compress-Raw-Lzma-2.209
```

### Configuration de la compilation

Nous allons maintenant générer le fichier Makefile :

```
LIBLZMA_LIB="$HOME/.softwares/install/xz/lib" \
    LIBLZMA_INCLUDE="$HOME/.softwares/install/xz/include" \
    perl Makefile.PL
```

### Compilation

Nous allons désormais compiler Compress::Raw::LZMA avec la commande suivante :

```
make
```

### Installation

Nous allons maintenant installer le module dans Perl

```
sudo make install
```

### Nettoyage

Nous allons désormais supprimer les deux dossier que nous venons de créer dans
le répertoire des sources. Tout d'abord, rendez-vous dans le répertoire des
sources :

```
cd ..
```

Puis supprimez le dossier contenant les fichiers sources :

```
rm -rf Compress-Raw-Lzma-2.209
```