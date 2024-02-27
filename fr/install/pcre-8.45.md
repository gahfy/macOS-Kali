# Installer PCRE 8.45 sous macOS depuis les sources

PCRE est un panel d'outils concernant les expressions régulières.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 8.45 de PCRE.

```
curl -LO https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.bz2
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf pcre-8.45.tar.bz2
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler PCRE :

```
mkdir pcre-build
```

Puis rendez-vous dans ce répertoire :

```
cd pcre-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de PCRE :

```
../pcre-8.45/configure --prefix=$HOME/.softwares/build/pcre-8.45 \
    --enable-utf8 \
    --enable-pcre8 \
    --enable-pcre16 \
    --enable-pcre32 \
    --enable-unicode-properties \
    --enable-pcregrep-libz \
    --enable-pcregrep-libbz2
```

### Compilation

Nous allons désormais compiler PCRE avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de PCRE qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer PCRE dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/pcre-8.45 $HOME/.softwares/install/pcre
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## PCRE' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/pcre/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/pcre/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/pcre/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf pcre-build
```

Puis finalement le dossier contenant les sources de pcre :

```
rm -rf pcre-8.45
```