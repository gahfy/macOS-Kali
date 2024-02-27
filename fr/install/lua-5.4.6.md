# Installer Lua-5.4.6 sous macOS depuis les sources

Lua est un langage de programmation qui se veut léger et puissant.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 5.4.6 de Lua.

```
curl -LO https://www.lua.org/ftp/lua-5.4.6.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf lua-5.4.6.tar.gz
```

### Patch des sources

Par défaut, les Lua ne fournit pas de bibliothèque partagée, et les répertoires
d'installation ne sont pas optimaux (notamment pour man). Nous allons donc
appliquer un patch qui permet de corriger cela. Commencez par télécharger le
patch correctif :

```
curl -L https://raw.githubusercontent.com/Homebrew/formula-patches/11c8360432f471f74a9b2d76e012e3b36f30b871/lua/lua-dylib.patch -o lua-5.4.6-fix-dylib-man.patch
```

Nous allons ensuite appliquer ce patch sur nos sources :

```
patch --directory=lua-5.4.6 --strip=1 < lua-5.4.6-fix-dylib-man.patch
```

### Compilation

Commencez par vous rendre dans le répertoire contenant les sources de Lua :

```
cd lua-5.4.6
```

Nous allons désormais compiler Lua avec la commande suivante :

```
make INSTALL_TOP=$HOME/.softwares/build/lua-5.4.6
```

### Installation

Nous pouvons maintenant installer Lua avec la commande suivante :

```
make install INSTALL_TOP=$HOME/.softwares/build/lua-5.4.6
```

Nous allons changer le RPATH de la bibliothèque qui n'a pas été correctement
défini :

```
install_name_tool -id "$HOME/.softwares/build/lua-5.4.6/lib/liblua.dylib" \
    $HOME/.softwares/build/lua-5.4.6/lib/liblua.dylib
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/lua-5.4.6 $HOME/.softwares/install/lua
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Lua' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/lua/bin:$PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/lua/share/man:$MANPATH"' >> $HOME/.zshrc
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

Puis supprimez le dossier contenant les sources de lua :

```
rm -rf lua-5.4.6
```