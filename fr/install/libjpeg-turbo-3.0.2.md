# Installer libjpeg-turbo-3.0.2 sous macOS depuis les sources

libjpeg-turbo est une bibliothèque permettant d'afficher les fichiers jpeg.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.6.42 de libjpeg-turbo.

```
curl -LO https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.0.2/libjpeg-turbo-3.0.2.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf libjpeg-turbo-3.0.2.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler libjpeg-turbo :

```
mkdir libjpeg-turbo-build
```

Puis rendez-vous dans ce répertoire :

```
cd libjpeg-turbo-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de libjpeg-turbo, en nous
contentant d'indiquer le répertoire d'installation :

```
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.softwares/build/libjpeg-turbo-3.0.2 \
    ../libjpeg-turbo-3.0.2
```

### Compilation

Nous allons désormais compiler libjpeg-turbo avec la commande suivante :

```
cmake --build .
```

### Test des exécutables

Afin de nous assurer que la version de libjpeg-turbo qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
cmake --build . --target test
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer libjpeg-turbo dans son répertoire de
destination :

```
cmake --build . --target install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/libjpeg-turbo-3.0.2 $HOME/.softwares/install/libjpeg-turbo
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## libjpeg-turbo' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/libjpeg-turbo/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/libjpeg-turbo/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/libjpeg-turbo/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf libjpeg-turbo-build
```

Puis finalement le dossier contenant les sources de libjpeg-turbo :

```
rm -rf libjpeg-turbo-3.0.2
```