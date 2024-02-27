# Installer PCRE2 10.43 sous macOS depuis les sources

PCRE2 est un panel d'outils concernant les expressions régulières.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 10.43 de PCRE2.

```
curl -LO https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.43/pcre2-10.43.tar.bz2
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf pcre2-10.43.tar.bz2
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler PCRE2 :

```
mkdir pcre2-build
```

Puis rendez-vous dans ce répertoire :

```
cd pcre2-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de PCRE2 :

```
../pcre2-10.43/configure --prefix=$HOME/.softwares/build/pcre2-10.43 \
    --enable-pcre2-16 \
    --enable-pcre2-32 \
    --enable-pcre2grep-libz \
    --enable-pcre2grep-libbz2 \
    --enable-jit
```

### Compilation

Nous allons désormais compiler PCRE2 avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de PCRE2 qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer PCRE2 dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/pcre2-10.43 $HOME/.softwares/install/pcre2
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## PCRE2' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/pcre2/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/pcre2/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/pcre2/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf pcre2-build
```

Puis finalement le dossier contenant les sources de pcre2 :

```
rm -rf pcre2-10.43
```