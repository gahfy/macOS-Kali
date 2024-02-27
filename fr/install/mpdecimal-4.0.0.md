# Installer MPDecimal 4.0.0 sous macOS depuis les sources

MPDecimal est une bibliothèque C/C++ pour les calculs sur les nombres décimaux.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 4.0.0 de MPDecimal.

```
curl -LO https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.0.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf mpdecimal-4.0.0.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler MPDecimal :

```
mkdir mpdecimal-build
```

Puis rendez-vous dans ce répertoire :

```
cd mpdecimal-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de MPDecimal, en nous
contentant d'indiquer le répertoire d'installation :

```
../mpdecimal-4.0.0/configure --prefix=$HOME/.softwares/build/mpdecimal-4.0.0
```

### Compilation

Nous allons désormais compiler MPDecimal avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer MPDecimal dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/mpdecimal-4.0.0 $HOME/.softwares/install/mpdecimal
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## MPDecimal' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/mpdecimal/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/mpdecimal/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf mpdecimal-build
```

Puis finalement le dossier contenant les sources de mpdecimal :

```
rm -rf mpdecimal-4.0.0
```