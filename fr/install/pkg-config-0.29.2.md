# Installer pkg-config 0.29.2 sous macOS depuis les sources

Pkg-config est un outil permettant de gérer les dépendances avec des
bibliothèques lors de la compilation de programmes.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 0.29.2 de pkg-config.

```
curl -LO https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf pkg-config-0.29.2.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler pkg-config :

```
mkdir pkg-config-build
```

Puis rendez-vous dans ce répertoire :

```
cd pkg-config-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de pkg-config :

```
../pkg-config-0.29.2/configure --prefix=$HOME/.softwares/build/pkg-config-0.29.2 \
    --with-internal-glib
```

### Compilation

Nous allons désormais compiler pkg-config avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de pkg-config qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer pkg-config dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/pkg-config-0.29.2 $HOME/.softwares/install/pkg-config
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Pkg-config' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/pkg-config/bin:$PATH"' >> $HOME/.zshrc
echo 'export ACLOCAL_PATH="$HOME/.softwares/install/pkg-config/share/aclocal:$ACLOCAL_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/pkg-config/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf pkg-config-build
```

Puis finalement le dossier contenant les sources de pkg-config :

```
rm -rf pkg-config-0.29.2
```