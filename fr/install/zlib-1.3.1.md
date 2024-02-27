# Installer Zlib 1.3.1 sous macOS depuis les sources

Zlib est une bibliothèque de compression et de décompression

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.3.1 de Zlib.

```
curl -LO http://zlib.net/zlib-1.3.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf zlib-1.3.1.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Zlib :

```
mkdir zlib-build
```

Puis rendez-vous dans ce répertoire :

```
cd zlib-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de Zlib, en nous contentant
d'indiquer le répertoire d'installation :

```
../zlib-1.3.1/configure --prefix=$HOME/.softwares/build/zlib-1.3.1
```

### Compilation

Nous allons désormais compiler Zlib avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de Zlib qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make test
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer Zlib dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/zlib-1.3.1 $HOME/.softwares/install/zlib
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Zlib' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/zlib/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/zlib/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf zlib-build
```

Puis finalement le dossier contenant les sources de zlib :

```
rm -rf zlib-1.3.1
```