# Installer libpng 1.6.42 sous macOS depuis les sources

libpng est une bibliothèque permettant d'afficher les fichiers png.

## Dépendances

* [**zlib**](zlib-1.3.1.md) Zlib est déjà fourni par le système macOS, mais ce
dernier ne fournit pas les fichiers pkgconfig de la bibliothèque, qui sont
requis par le fichier pkg-config de libpng

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.6.42 de libpng.

```
curl -LO http://prdownloads.sourceforge.net/libpng/libpng-1.6.42.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf libpng-1.6.42.tar.xz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler libpng :

```
mkdir libpng-build
```

Puis rendez-vous dans ce répertoire :

```
cd libpng-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de libpng, en nous contentant
d'indiquer le répertoire d'installation :

```
../libpng-1.6.42/configure --prefix=$HOME/.softwares/build/libpng-1.6.42
```

### Compilation

Nous allons désormais compiler libpng avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de libpng qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer libpng dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/libpng-1.6.42 $HOME/.softwares/install/libpng
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## libpng' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/libpng/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/libpng/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/libpng/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf libpng-build
```

Puis finalement le dossier contenant les sources de libpng :

```
rm -rf libpng-1.6.42
```