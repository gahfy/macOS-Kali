# Installer LevelDB 1.22 sous macOS depuis les sources

LevelDB est une base de données rapide sous la forme clé/valeur développée par
Google.

## Dépendances

### Indispensables

* [**CMake**](cmake-3.28.3.md) : La compilation et l'installation de LevelDB se
faisant avec CMake, son installation est indispensable.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Récupérez ensuite le dépôt git contenant les sources de leveldb.

```
git clone https://github.com/google/leveldb
```

Rendez-vous dans le répertoire du dépôt :

```
cd leveldb
```

Ensuite, placez vous sur le tag correspondant à la version 1.22 :

```
git checkout 1.22
```

Initialisez la récupération des sous-modules :

```
git submodule init
```

Puis récupérez-les :

```
git submodule update
```

Revenez maintenant dans le répertoire des sources :

```
cd ..
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler leveldb :

```
mkdir leveldb-build
```

Puis rendez-vous dans ce répertoire :

```
cd leveldb-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de leveldb :

```
CXXFLAGS="-Wno-error=deprecated-copy -Wno-error=unused-but-set-variable" \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
    -DLEVELDB_BUILD_TESTS=OFF \
    -DLEVELDB_BUILD_BENCHMARKS=OFF \
    -DCMAKE_INSTALL_PREFIX=$HOME/.softwares/build/leveldb-1.22 \
    -DCMAKE_INSTALL_RPATH=$HOME/.softwares/build/leveldb-1.22/lib \
    -DBUILD_SHARED_LIBS=ON \
    ../leveldb
```

### Compilation

Nous allons désormais compiler leveldb avec la commande suivante :

```
cmake --build .
```
```

### Installation

Vous pouvez désormais installer LevelDB dans son répertoire de destination :

```
cmake --build . --target install
```

Le rpath des bibliothèques n'étant pas défini de manière correcte, nous allons
le modifier :

```
install_name_tool -id "$HOME/.softwares/build/leveldb-1.22/lib/libleveldb.1.22.0.dylib" "$HOME/.softwares/build/leveldb-1.22/lib/libleveldb.1.22.0.dylib"
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/leveldb-1.22 $HOME/.softwares/install/leveldb
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## LevelDB' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/leveldb/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
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
rm -rf leveldb-build
```

Puis finalement le dossier contenant les sources de leveldb :

```
rm -rf leveldb
```