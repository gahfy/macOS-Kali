# Installer ExifTool 2.77 sous macOS depuis les sources

ExifTool est une bibliothèque Perl pour écrire et lire les données Exif

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.77 de ExifTool.

```
curl -LO https://exiftool.org/Image-ExifTool-12.77.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf Image-ExifTool-12.77.tar.gz
```

### Configuration de la compilation

Commencez par vous rendre dans le répertoire des sources :

```
cd Image-ExifTool-12.77
```

Et générez le fichier Makefile avec la commande suivante :

```
perl Makefile.PL
```

### Compilation

Nous allons désormais compiler ExifTool avec la commande suivante :

```
make all
```

### Installation

Nous pouvons désormais créer le dossier dans lequel sera installé ExifTool:

```
mkdir $HOME/.softwares/build/exiftool-2.77
```

Et créer les sous dossiers, en commençant par le dossier bin:

```
mkdir $HOME/.softwares/build/exiftool-2.77/bin
```

Puis les dossiers man :

```
mkdir -p $HOME/.softwares/build/exiftool-2.77/share/man
```

Commençons par déplacer le dossier des bibliothèques dans ce dossier
d'installation :

```
mv ./lib $HOME/.softwares/build/exiftool-2.77/lib
```

Puis la documentation :

```
mv ./html $HOME/.softwares/build/exiftool-2.77/share/doc
```

Puis maintenant le fichier exécutable :

```
mv ./exiftool $HOME/.softwares/build/exiftool-2.77/bin/
```

Et pour finir les fichiers man :

```
mv ./blib/man1 $HOME/.softwares/build/exiftool-2.77/share/man/man1
mv ./blib/man3 $HOME/.softwares/build/exiftool-2.77/share/man/man3
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/exiftool-2.77 $HOME/.softwares/install/exiftool
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## ExifTool' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/exiftool/bin:$PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/exiftool/share/man:$MANPATH"' >> $HOME/.zshrc
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

Puis supprimez le dossier contenant les sources de ExifTool :

```
rm -rf Image-ExifTool-12.77
```