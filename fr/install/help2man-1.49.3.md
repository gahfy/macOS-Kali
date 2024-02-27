# Installer help2man 1.49.3 sous macOS depuis les sources

help2man permet de convertir des fichiers d'aide en fichiers man.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.49.3 de help2man.

```
curl -LO https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf help2man-1.49.3.tar.xz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler help2man :

```
mkdir help2man-build
```

Puis rendez-vous dans ce répertoire :

```
cd help2man-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de help2man, en nous contentant
d'indiquer le répertoire d'installation :

```
../help2man-1.49.3/configure --prefix=$HOME/.softwares/build/help2man-1.49.3
```

### Compilation

Nous allons désormais compiler help2man avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer help2man dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/help2man-1.49.3 $HOME/.softwares/install/help2man
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Help2man' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/help2man/bin:$PATH"' >> $HOME/.zshrc
echo 'export INFOPATH="$HOME/.softwares/install/help2man/share/info:$INFOPATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/help2man/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf help2man-build
```

Puis finalement le dossier contenant les sources de help2man :

```
rm -rf help2man-1.49.3
```