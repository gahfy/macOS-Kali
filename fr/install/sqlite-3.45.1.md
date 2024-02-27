# Installer SQLite 3.45.1 sous macOS depuis les sources

SQLite est un logiciel et une bibliothèque de gestion de base de données
relationnelle.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 3.45.1 de SQLite.

```
curl -LO https://www.sqlite.org/2024/sqlite-autoconf-3450100.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf sqlite-autoconf-3450100.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler SQLite :

```
mkdir sqlite-build
```

Puis rendez-vous dans ce répertoire :

```
cd sqlite-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de SQLite, en nous contentant
d'indiquer le répertoire d'installation :

```
../sqlite-autoconf-3450100/configure --prefix=$HOME/.softwares/build/sqlite-3.45.1
```

### Compilation

Nous allons désormais compiler SQLite avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer SQLite dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/sqlite-3.45.1 $HOME/.softwares/install/sqlite
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## SQLite' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/sqlite/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/sqlite/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/sqlite/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf sqlite-build
```

Puis finalement le dossier contenant les sources de sqlite :

```
rm -rf sqlite-autoconf-3450100
```