# Installer LibSSH2 1.11.0 sous macOS depuis les sources

LibSSH2 est une bibliothèque C implémentant le côté client d'une connexion SSH2.

## Dépendances

### Indispensables

* [**LibreSSL**](libressl-3.8.2.md) : LibreSSL est requis pour les opérations de
chiffrement de la bibliothèque LibSSH2

### Faculatives

* **Docker** : Docker est requis pour lancer la suite de tests. Docker
fournissant un installeur binaire, et la compilation de Docker étant
particulièrement complexe, nous vous recommandons de passer directement par les
binaires fournis de Docker Desktop si vous souhaitez lancer la suite de tests.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.11.0 de LibSSH2.

```
curl -LO https://libssh2.org/download/libssh2-1.11.0.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf libssh2-1.11.0.tar.xz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler CMake :

```
mkdir libssh2-build
```

Puis rendez-vous dans ce répertoire :

```
cd libssh2-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de LibSSH2 :

```
../libssh2-1.11.0/configure --prefix=$HOME/.softwares/build/libssh2-1.11.0 \
    --with-libssl-prefix=$HOME/.softwares/install/libressl
```

### Compilation

Nous allons désormais compiler LibSSH2 avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de LibSSH2 qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

_Si vous avez choisi de ne pas installer Docker, de nombreux tests échoueront.
Vous pouvez ignorer ces échecs si vous ne souhaitez pas installer Docker._

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer LibSSH2 dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/libssh2-1.11.0 $HOME/.softwares/install/libssh2
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## LibSSH2' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/libssh2/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/libssh2/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf libssh2-build
```

Puis finalement le dossier contenant les sources de libssh2 :

```
rm -rf libssh2-1.11.0
```