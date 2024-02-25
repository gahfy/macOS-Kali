# LibreSSL 3.8.2

LibreSSL est une collection d'outils et de bibliothèques compatibles avec
OpenSSL, mais ayant mis l'accent sur la sécurité et les bonnes pratiques de
développement

## Dépendances

_Aucune_

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 3.8.2 de LibreSSL :

```
curl -LO  https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.8.2.tar.gz
```


Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf libressl-3.8.2.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler LibreSSL :

```
mkdir libressl-build
```

Puis rendez-vous dans ce répertoire :

```
cd libressl-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de LibreSSL, en nous contentant
d'indiquer le répertoire d'installation :

```
../libressl-3.8.2/configure --prefix=$HOME/.softwares/build/libressl-3.8.2
```

### Compilation

Nous allons désormais compiler LibreSSL avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de LibreSSL qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer LibreSSL dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/libressl-3.8.2 $HOME/.softwares/install/libressl
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## LibreSSL' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/libressl/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/libressl/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/libressl/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf libressl-build
```

Puis finalement le dossier contenant les sources de libressl :

```
rm -rf libressl-3.8.2
```