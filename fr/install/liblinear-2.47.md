# Installer LibLinear 2.47 sous macOS depuis les sources

LibLinear est une bibliothèque pour les classifications linéaires à grande
échelle.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.47 de LibLinear.

```
curl -LO https://www.csie.ntu.edu.tw/~cjlin/liblinear/liblinear-2.47.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf liblinear-2.47.tar.gz
```

### Compilation

Commencez par vous rendre dans le répertoire contenant les sources de
liblinear :

```
cd liblinear-2.47
```

Nous allons désormais compiler LibLinear avec la commande suivante :

```
make all lib
```

### Installation

Nous allons désormais créer le répertoire dans lequel liblinear sera installé :

```
mkdir $HOME/.softwares/build/liblinear-2.47
```

Puis les répertoires contenant les exécutables, le répertoire contenant la
bibliothèque, et le répertoire contenant le fichier d'entêtes

```
mkdir $HOME/.softwares/build/liblinear-2.47/bin
mkdir $HOME/.softwares/build/liblinear-2.47/lib
mkdir $HOME/.softwares/build/liblinear-2.47/include
```

Nous alloons maintenant déplacer les deux fichiers exécutables dans leur
répertoire de destination :

```
mv train $HOME/.softwares/build/liblinear-2.47/bin/
mv predict $HOME/.softwares/build/liblinear-2.47/bin/
```

Puis la bibliothèque :

```
mv liblinear.so.5 $HOME/.softwares/build/liblinear-2.47/lib/liblinear.1.dylib
```

Et pour finir le fichier d'entêtes :

```
mv linear.h $HOME/.softwares/build/liblinear-2.47/include/
```

Enfin, nous allons modifier le RPATH de cette librairie :

```
install_name_tool -id "$HOME/.softwares/build/liblinear-2.47/lib/liblinear.1.dylib" \
    $HOME/.softwares/build/liblinear-2.47/lib/liblinear.1.dylib
```

Nous allons également créer un lien symbolique `dylib` vers cette bibliothèque :

```
ln -s liblinear.1.dylib $HOME/.softwares/build/liblinear-2.47/lib/liblinear.dylib
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/liblinear-2.47 $HOME/.softwares/install/liblinear
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## LibLinear' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/liblinear/bin:$PATH"' >> $HOME/.zshrc
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

Puis supprimez le dossier contenant les sources de liblinear :

```
rm -rf liblinear-2.47
```