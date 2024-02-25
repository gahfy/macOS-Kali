# Installer LZO 2.10 sous macOS depuis les sources

LZO est un outil permettant la compression et la décompression en utilisant
l'algorithme LZO.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.10 de LZO.

```
curl -LO http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf lzo-2.10.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler LZO :

```
mkdir lzo-build
```

Puis rendez-vous dans ce répertoire :

```
cd lzo-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de LZO :

```
../lzo-2.10/configure --prefix=$HOME/.softwares/build/lzo-2.10 \
    --enable-shared
```

### Compilation

Nous allons désormais compiler LZO avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de LZO qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer LZO dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/lzo-2.10 $HOME/.softwares/install/lzo
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## LZO' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/lzo/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
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
rm -rf lzo-build
```

Puis finalement le dossier contenant les sources de lzo :

```
rm -rf lzo-2.10
```