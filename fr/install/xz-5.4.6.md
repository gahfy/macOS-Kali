# XZ 5.4.6

XZ contient des programmes et des bibliothèques permettant la compression et la
décompression avec l'algorithme LZMA.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 5.4.6 de XZ.

```
curl -LO  https://github.com/tukaani-project/xz/releases/download/v5.4.6/xz-5.4.6.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf xz-5.4.6.tar.xz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler XZ :

```
mkdir xz-build
```

Puis rendez-vous dans ce répertoire :

```
cd xz-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de XZ, en nous contentant
d'indiquer le répertoire d'installation :

```
../xz-5.4.6/configure --prefix=$HOME/.softwares/build/xz-5.4.6
```

### Compilation

Nous allons désormais compiler XZ avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de XZ qui vient d'être compilée fonctionnera 
comme prévu, nous vous recommandons de lancer la suite de tests qui vérifiera
que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer XZ dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/xz-5.4.6 $HOME/.softwares/install/xz
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## XZ' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/xz/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/xz/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/xz/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf xz-build
```

Puis finalement le dossier contenant les sources de xz :

```
rm -rf xz-5.4.6
```