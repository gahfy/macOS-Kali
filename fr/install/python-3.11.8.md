# Installer Python 3.11.8 sous macOS depuis les sources

Python est un langage de programmation et également un programme permettant
d'exécuter des programmes écrits dans ce langage.

## Dépendances

### Recommandées

* [**OpenSSL**](openssl-3.2.1.md) : OpenSSL a des fonctionnalités spécifiques
utilisées par Python, et donc sera préféré à LibreSSL pour la dépendance
* [**SQLite**](sqlite-3.45.1.md)
* [**XZ**](xz-5.4.6.md)

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 3.11.8 de Python.

```
curl -LO https://www.python.org/ftp/python/3.11.8/Python-3.11.8.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf Python-3.11.8
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Python :

```
mkdir Python-build
```

Puis rendez-vous dans ce répertoire :

```
cd Python-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de Python :

```
LIBSQLITE3_CFLAGS="-I$HOME/.softwares/install/sqlite/include" \
    LIBSQLITE3_LIBS="-L$HOME/.softwares/install/sqlite/lib" \
    LIBLZMA_CFLAGS="-I$HOME/.softwares/install/xz/include" \
    LIBLZMA_LIBS="-L$HOME/.softwares/install/xz/lib" \
    ../Python-3.11.8/configure --prefix=$HOME/.softwares/build/Python-3.11.8 \
    --with-openssl=$HOME/.softwares/install/openssl \
    --enable-optimizations
```

### Compilation

Nous allons désormais compiler Python avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer Python dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/Python-3.11.8 $HOME/.softwares/install/Python3
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Python3' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/Python3/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/Python3/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/Python3/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf Python-build
```

Puis finalement le dossier contenant les sources de Python :

```
rm -rf Python-3.11.8
```